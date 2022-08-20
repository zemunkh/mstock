const String tableStocks = 'stocks';

class StockFields {
  static final List<String> values = [
    /// Add all fields
    id, stockId, stockCode, stockName, baseUOM, remark1, purchasePrice, weight, category, stockGroup, stockClass
  ];

  static const String id = '_id';
  static const String stockId = 'id';
  static const String stockCode = 'stockCode';
  static const String stockName = 'stockName';
  static const String baseUOM = 'baseUOM';
  static const String remark1 = 'remark1';
  static const String purchasePrice = 'purchasePrice';
  static const String weight = 'weight';
  static const String category = 'category';
  static const String stockGroup = 'stockGroup';
  static const String stockClass = 'stockClass';
}


class Stock {
  final int? id;
  final String stockId;
  final String stockCode;
  final String stockName;
  // final String description;
  final String baseUOM;
  final double weight;
  final double purchasePrice;
  final String remark1;
  final String category;
  final String group;
  final String stockClass;

  Stock({
    required this.id,
    required this.stockId,
    required this.stockCode,
    required this.stockName,
    // required this.description,
    required this.baseUOM,
    required this.weight,
    required this.purchasePrice,
    required this.remark1,
    required this.category,
    required this.group,
    required this.stockClass
  });

  Stock copy({
    int? id,
    String? stockId,
    String? stockCode,
    String? stockName,
    String? baseUOM,
    double? weight,
    double? purchasePrice,
    String? remark1,
    String? category,
    String? group,
    String? stockClass
  }) =>
      Stock(
        id: id ?? this.id,
        stockId: stockId ?? this.stockId,
        stockCode: stockCode ?? this.stockCode,
        stockName: stockName ?? this.stockName,
        baseUOM: baseUOM ?? this.baseUOM,
        weight: weight ?? this.weight,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        remark1: remark1 ?? this.remark1,
        category: category ?? this.category,
        group: group ?? this.group,
        stockClass: stockClass ?? this.stockClass,
      );

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json[StockFields.id] as int?,
      stockId: json[StockFields.stockId] as String,
      stockCode: json[StockFields.stockCode] as String,
      stockName: json[StockFields.stockName] as String,
      // description: json['description'] ?? json['description'],
      baseUOM: json[StockFields.baseUOM] as String,
      weight: json[StockFields.weight] as double,
      purchasePrice: json[StockFields.purchasePrice] as double,
      remark1: json[StockFields.remark1] as String,
      category: json[StockFields.category] as String,
      group: json['group'] as String,
      stockClass: json['class'] as String,
    );
  }

  Map<String, Object?> toJson() => {
    StockFields.id: id,
    StockFields.stockId: stockId,
    StockFields.stockCode: stockCode,
    StockFields.stockName: stockName,
    StockFields.baseUOM: baseUOM,
    StockFields.weight: weight,
    StockFields.purchasePrice: purchasePrice,
    StockFields.remark1: remark1,
    StockFields.category: category,
    StockFields.stockGroup: group,
    StockFields.stockClass: stockClass
  };
}