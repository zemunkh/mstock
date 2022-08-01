import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/counter.dart';

class CounterDatabase {
  static final CounterDatabase instance = CounterDatabase._init();

  static Database? _database;

  CounterDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('counter.db');
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
      CREATE TABLE $tableCounter ( 
        ${CounterFields.id} $idType, 
        ${CounterFields.stockId} $textType,
        ${CounterFields.stockCode} $textType,
        ${CounterFields.machine} $textType,
        ${CounterFields.shift} $textType,
        ${CounterFields.createdTime} $textType,
        ${CounterFields.stockGroup} $textType,
        ${CounterFields.stockClass} $textType,
        ${CounterFields.weight} $realType,
        ${CounterFields.qty} $integerType,
        ${CounterFields.stockCategory} $textType,
        ${CounterFields.baseUOM} $textType
        )
      ''');
  }

  Future<Counter> create(Counter counter) async {
    final db = await instance.database;

    // final json = counter.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableCounter, counter.toJson());
    return counter.copy(id: id);
  }

  Future<Counter> readCounter(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounter,
      columns: CounterFields.values,
      where: '${CounterFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Counter.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Counter> readCounterByCode(String stockCode) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCounter,
      columns: CounterFields.values,
      where: '${CounterFields.stockCode} = ?',
      whereArgs: [stockCode],
    );

    if (maps.isNotEmpty) {
      return Counter.fromJson(maps.first);
    } else {
      throw Exception('StockCode from Counter $stockCode not found');
    }
  }

  Future<List<Counter>> readAllCounters() async {
    final db = await instance.database;

    const orderBy = '${CounterFields.stockCode} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableCounter, orderBy: orderBy);

    return result.map((json) => Counter.fromJson(json)).toList();
  }

  Future<int> update(Counter counter) async {
    final db = await instance.database;

    return db.update(
      tableCounter,
      counter.toJson(),
      where: '${CounterFields.id} = ?',
      whereArgs: [counter.id],
    );
  }


  Future<int> deleteByStockCode(String stockCode) async {
    final db = await instance.database;

    return await db.delete(
      tableCounter,
      where: '${CounterFields.stockCode} = ?',
      whereArgs: [stockCode],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCounter,
      where: '${CounterFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}