import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:multiple_result/multiple_result.dart';
import '../model/stockCounter.dart';

class StockCounterDatabase {
  static final StockCounterDatabase instance = StockCounterDatabase._init();

  static Database? _database;

  StockCounterDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('counterIn.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    // const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCounterIn ( 
        ${StockCounterFields.id} $idType, 
        ${StockCounterFields.stock} $textType,
        ${StockCounterFields.description} $textType,
        ${StockCounterFields.machine} $textType,
        ${StockCounterFields.shift} $textType,
        ${StockCounterFields.device} $textType,
        ${StockCounterFields.uom} $textType,
        ${StockCounterFields.qty} $integerType,
        ${StockCounterFields.purchasePrice} $realType,
        ${StockCounterFields.isPosted} $integerType,
        ${StockCounterFields.shiftDate} $textType,
        ${StockCounterFields.createdAt} $textType,
        ${StockCounterFields.updatedAt} $textType
        )
      ''');
  }

  Future<StockCounter> create(StockCounter counter) async {
    final db = await instance.database;

    // final json = counter.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableCounterIn, counter.toJson());
    return counter.copy(id: id);
  }

  Future<StockCounter> readCounterIn(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounterIn,
      columns: StockCounterFields.values,
      where: '${StockCounterFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return StockCounter.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Future<StockCounter> readCounterInByCode(String stockCode, String machine) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     tableCounterIn,
  //     columns: StockCounterFields.values,
  //     where: '${StockCounterFields.stock} = ? AND ${StockCounterFields.isPosted} = ? AND ${StockCounterFields.machine} = ?',
  //     whereArgs: [stockCode, 0, machine],
  //   );

  //   if (maps.isNotEmpty) {
  //     return StockCounter.fromJson(maps.first);
  //   } else if(maps.isEmpty) {
  //     throw Exception('404'); 
  //   } else {
  //     throw Exception('StockCode from CounterIn $stockCode not found');
  //   }
  // }

  Future<Result<Exception, List<StockCounter>>> readCounterInsNotPosted() async {
    final db = await instance.database;
    const orderBy = '${StockCounterFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: StockCounterFields.values,
      where: '${StockCounterFields.isPosted} = ?',
      whereArgs: [0],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      return Success(maps.map((json) => StockCounter.fromJson(json)).toList());
    } else {
      return Error(Exception('Stocks from Counter stockIns are not found'));
    }
  }

  Future<List<StockCounter>> readCounterInsPosted() async {
    final db = await instance.database;
    const orderBy = '${StockCounterFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: StockCounterFields.values,
      where: '${StockCounterFields.isPosted} = ?',
      whereArgs: [1],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      // print('👉 Search: $maps');
      return maps.map((json) => StockCounter.fromJson(json)).toList();
    } else {
      throw Exception('Stocks from Counter stockIns are not found');
    }
  }

  Future<List<StockCounter>> readCounterInByCodeAndMachine(String stock, String machine) async {
    final db = await instance.database;
    const orderBy = '${StockCounterFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: StockCounterFields.values,
      where: '${StockCounterFields.stock} = ? AND ${StockCounterFields.machine} = ?',
      whereArgs: [stock, machine],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      // print('👉 Search: $maps');
      return maps.map((json) => StockCounter.fromJson(json)).toList();
    } else {
      throw Exception('Stocks from Counter stockIns are not found');
    }
  }

  Future<List<StockCounter>> readAllCounterIns() async {
    final db = await instance.database;

    const orderBy = '${StockCounterFields.stock} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableCounterIn, orderBy: orderBy);

    return result.map((json) => StockCounter.fromJson(json)).toList();
  }

  Future<int> update(StockCounter counter) async {
    final db = await instance.database;

    return db.update(
      tableCounterIn,
      counter.toJson(),
      where: '${StockCounterFields.id} = ?',
      whereArgs: [counter.id],
    );
  }

  Future<int> updatePostedStatus(int id) async {
    final db = await instance.database;

    return db.update(
      tableCounterIn,
      {
        StockCounterFields.isPosted: 1,
      },
      where: '${StockCounterFields.id} = ?',
      whereArgs: [id],
    );
  }


  // Future<int> deleteByStockCode(String stockCode) async {
  //   final db = await instance.database;

  //   return await db.delete(
  //     tableCounterIn,
  //     where: '${StockCounterFields.stock} = ?',
  //     whereArgs: [stockCode],
  //   );
  // }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterIn,
      where: '${StockCounterFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}