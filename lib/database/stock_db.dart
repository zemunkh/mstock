import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/stock.dart';

class StockDatabase {
  static final StockDatabase instance = StockDatabase._init();

  static Database? _database;

  StockDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('stocks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableStocks ( 
        ${StockFields.id} $idType,
        ${StockFields.stockId} $textType,
        ${StockFields.stockCode} $textType,
        ${StockFields.stockName} $textType,
        ${StockFields.remark1} $textType,
        ${StockFields.weight} $realType,
        ${StockFields.purchasePrice} $realType,
        ${StockFields.stockGroup} $textType,
        ${StockFields.baseUOM} $textType,
        ${StockFields.category} $textType,
        ${StockFields.stockClass} $textType
        )
      ''');
  }

  Future<Stock> create(Stock stock) async {
    final db = await instance.database;
    final json = stock.toJson();

    // print('ITEM STOCK: $json');

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableStocks, json);
    print('ID: $id');
    return stock.copy(id: id);
  }

  Future<Stock> readStock(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableStocks,
      columns: StockFields.values,
      where: '${StockFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Stock.fromJsonSQL(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Stock> readStockByCode(String stockCode) async {
    final db = await instance.database;

    final maps = await db.query(
      tableStocks,
      columns: StockFields.values,
      where: '${StockFields.stockCode} = ?',
      whereArgs: [stockCode],
    );

    if (maps.isNotEmpty) {
      print('Row: ${maps.first}');
      return Stock.fromJsonSQL(maps.first);
    } else {
      throw Exception('Code $stockCode not found');
    }
  }


  Future<List<Stock>> readAllStocks() async {
    final db = await instance.database;

    final orderBy = '${StockFields.stockName} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableStocks, orderBy: orderBy);

    return result.map((json) => Stock.fromJsonSQL(json)).toList();
  }

  Future<int> update(Stock stock) async {
    final db = await instance.database;

    return db.update(
      tableStocks,
      stock.toJson(),
      where: '${StockFields.id} = ?',
      whereArgs: [stock.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableStocks,
      where: '${StockFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableStocks
    );
  }


  Future close() async {
    final db = await instance.database;

    db.close();
  }
}