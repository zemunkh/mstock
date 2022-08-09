import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/counter_in.dart';

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
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCounterIn ( 
        ${CounterInFields.id} $idType, 
        ${CounterInFields.stockInCode} $textType,
        ${CounterInFields.description} $textType,
        ${CounterInFields.referenceNo} $textType,
        ${CounterInFields.stockLocation} $textType,
        ${CounterInFields.numbering} $textType,
        ${CounterInFields.stock} $textType,
        ${CounterInFields.uom} $textType,
        ${CounterInFields.qty} $integerType,
        ${CounterInFields.createdAt} $textType
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

  Future<CounterIn> readCounterInByCode(String stockCode) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounterIn,
      columns: CounterInFields.values,
      where: '${CounterInFields.stockInCode} = ?',
      whereArgs: [stockCode],
    );

    if (maps.isNotEmpty) {
      return CounterIn.fromJson(maps.first);
    } else {
      throw Exception('StockCode from CounterIn $stockCode not found');
    }
  }

  Future<List<CounterIn>> readAllCounterIns() async {
    final db = await instance.database;

    const orderBy = '${CounterInFields.stockInCode} ASC';
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


  Future<int> deleteByStockCode(String stockCode) async {
    final db = await instance.database;

    return await db.delete(
      tableCounterIn,
      where: '${CounterInFields.stockInCode} = ?',
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