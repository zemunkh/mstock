import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:multiple_result/multiple_result.dart';
import '../model/counterIn.dart';

class CounterInDatabase {
  static final CounterInDatabase instance = CounterInDatabase._init();

  static Database? _database;

  CounterInDatabase._init();

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
        ${CounterInFields.id} $idType, 
        ${CounterInFields.stock} $textType,
        ${CounterInFields.description} $textType,
        ${CounterInFields.machine} $textType,
        ${CounterInFields.shift} $textType,
        ${CounterInFields.device} $textType,
        ${CounterInFields.uom} $textType,
        ${CounterInFields.qty} $integerType,
        ${CounterInFields.purchasePrice} $realType,
        ${CounterInFields.isPosted} $integerType,
        ${CounterInFields.shiftDate} $textType,
        ${CounterInFields.createdAt} $textType,
        ${CounterInFields.updatedAt} $textType
        )
      ''');
  }

  Future<CounterIn> create(CounterIn counter) async {
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

  Future<CounterIn> readCounterIn(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CounterIn.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<CounterIn> readCounterInByCode(String stockCode, String machine) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.stock} = ? AND ${CounterInFields.isPosted} = ? AND ${CounterInFields.machine} = ?',
      whereArgs: [stockCode, 0, machine],
    );

    if (maps.isNotEmpty) {
      return CounterIn.fromJson(maps.first);
    } else if(maps.isEmpty) {
      throw Exception('404'); 
    } else {
      throw Exception('StockCode from CounterIn $stockCode not found');
    }
  }

  Future<Result<Exception, List<CounterIn>>> readCounterInsNotPosted() async {
    final db = await instance.database;
    const orderBy = '${CounterInFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.isPosted} = ?',
      whereArgs: [0],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      return Success(maps.map((json) => CounterIn.fromJson(json)).toList());
    } else {
      return Error(Exception('Stocks from Counter stockIns are not found'));
    }
  }

  Future<List<CounterIn>> readCounterInsPosted() async {
    final db = await instance.database;
    const orderBy = '${CounterInFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.isPosted} = ?',
      whereArgs: [1],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      // print('👉 Search: $maps');
      return maps.map((json) => CounterIn.fromJson(json)).toList();
    } else {
      throw Exception('Stocks from Counter stockIns are not found');
    }
  }

  Future<List<CounterIn>> readCounterInByCodeAndMachine(String stock, String machine) async {
    final db = await instance.database;
    const orderBy = '${CounterInFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.stock} = ? AND ${CounterInFields.machine} = ?',
      whereArgs: [stock, machine],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      // print('👉 Search: $maps');
      return maps.map((json) => CounterIn.fromJson(json)).toList();
    } else {
      throw Exception('Stocks from Counter stockIns are not found');
    }
  }

  Future<List<CounterIn>> readAllCounterIns() async {
    final db = await instance.database;

    const orderBy = '${CounterInFields.stock} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableCounterIn, orderBy: orderBy);

    return result.map((json) => CounterIn.fromJson(json)).toList();
  }

  Future<int> update(CounterIn counter) async {
    final db = await instance.database;

    return db.update(
      tableCounterIn,
      counter.toJson(),
      where: '${CounterInFields.id} = ?',
      whereArgs: [counter.id],
    );
  }

  Future<int> updatePostedStatus(int id) async {
    final db = await instance.database;

    return db.update(
      tableCounterIn,
      {
        CounterInFields.isPosted: 1,
      },
      where: '${CounterInFields.id} = ?',
      whereArgs: [id],
    );
  }


  Future<int> deleteByStockCode(String stockCode) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterIn,
      where: '${CounterInFields.stock} = ?',
      whereArgs: [stockCode],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterIn,
      where: '${CounterInFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}