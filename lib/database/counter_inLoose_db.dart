import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:multiple_result/multiple_result.dart';
import '../model/counterInLoose.dart';

class CounterInLooseDatabase {
  static final CounterInLooseDatabase instance = CounterInLooseDatabase._init();

  static Database? _database;

  CounterInLooseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('counterInLoose.db');
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
      CREATE TABLE $tableCounterInLoose ( 
        ${CounterInLooseFields.id} $idType, 
        ${CounterInLooseFields.stock} $textType,
        ${CounterInLooseFields.description} $textType,
        ${CounterInLooseFields.machine} $textType,
        ${CounterInLooseFields.shift} $textType,
        ${CounterInLooseFields.device} $textType,
        ${CounterInLooseFields.uom} $textType,
        ${CounterInLooseFields.qty} $integerType,
        ${CounterInLooseFields.totalQty} $integerType,
        ${CounterInLooseFields.purchasePrice} $realType,
        ${CounterInLooseFields.isPosted} $integerType,
        ${CounterInLooseFields.shiftDate} $textType,
        ${CounterInLooseFields.createdAt} $textType,
        ${CounterInLooseFields.updatedAt} $textType
        )
      ''');
  }

  Future<CounterInLoose> create(CounterInLoose counter) async {
    final db = await instance.database;

    // final json = counter.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableCounterInLoose, counter.toJson());
    return counter.copy(id: id);
  }

  Future<Result<Exception, List<CounterInLoose>>> readCounterInsLooseNotPosted() async {
    final db = await instance.database;
    const orderBy = '${CounterInLooseFields.updatedAt} DESC';

    final maps = await db.query(
      tableCounterInLoose,
      columns: CounterInLooseFields.values,
      where: '${CounterInLooseFields.isPosted} = ?',
      whereArgs: [0],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      return Success(maps.map((json) => CounterInLoose.fromJson(json)).toList());
    } else {
      return Error(Exception('Stocks from Counter stockIns are not found'));
    }
  }

  Future<List<CounterInLoose>> readCounterInsPosted() async {
    final db = await instance.database;
    const orderBy = '${CounterInLooseFields.updatedAt} ASC';

    final maps = await db.query(
      tableCounterInLoose,
      columns: CounterInLooseFields.values,
      where: '${CounterInLooseFields.isPosted} = ?',
      whereArgs: [1],
      orderBy: orderBy
    );

    if (maps.isNotEmpty) {
      // print('👉 Search: $maps');
      return maps.map((json) => CounterInLoose.fromJson(json)).toList();
    } else {
      throw Exception('Stocks from Counter stockIns are not found');
    }
  }

  Future<List<CounterInLoose>> readAllCounterIns() async {
    final db = await instance.database;

    const orderBy = '${CounterInLooseFields.stock} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableCounterInLoose, orderBy: orderBy);

    return result.map((json) => CounterInLoose.fromJson(json)).toList();
  }

  Future<int> update(CounterInLoose counter) async {
    final db = await instance.database;

    return db.update(
      tableCounterInLoose,
      counter.toJson(),
      where: '${CounterInLooseFields.id} = ?',
      whereArgs: [counter.id],
    );
  }

  Future<int> updatePostedStatus(int id) async {
    final db = await instance.database;

    return db.update(
      tableCounterInLoose,
      {
        CounterInLooseFields.isPosted: 1,
      },
      where: '${CounterInLooseFields.id} = ?',
      whereArgs: [id],
    );
  }


  Future<int> deleteByStockCode(String stockCode) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterInLoose,
      where: '${CounterInLooseFields.stock} = ?',
      whereArgs: [stockCode],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterInLoose,
      where: '${CounterInLooseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}