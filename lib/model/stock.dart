const String tableStocks = 'stocks';

class StockFields {
  static final List<String> values = [
    /// Add all fields
    id, stockId, stockCode, stockName, baseUOM, remark1, isActive, weight, category, stockGroup, stockClass
  ];

  static const String id = '_id';
  static const String stockId = 'id';
  static const String stockCode = 'stockCode';
  static const String stockName = 'stockName';
  static const String baseUOM = 'baseUOM';
  static const String remark1 = 'remark1';
  static const String isActive = 'isActive';
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
  // final String furtherDescription;
  final String baseUOM;
  // final double minQty;
  // final double maxQty;
  // final double reorderLevel;
  // final double reorderQty;
  // final double listPrice;
  // final double minPrice;
  // final String salesDiscount;
  // final double purchasePrice;
  // final String purchaseDiscount;
  // final String barCode;
  final double weight;
  // final double volume;
  // final double currentBalance;
  // final DateTime lastSellingDate;
  // final DateTime lastPurchaseDate;
  final bool isActive;
  // final bool isBundled;
  // final String createDate;
  // final bool stockControl;
  // final bool useSerialNo;
  // final String serialNoPrefix;
  // final String serialNoSuffix;
  final String remark1;
  // final String remark2;
  // final String remark3;
  // final String remark4;
  // final String remark5;
  // final bool useBatchNo;
  // final String itemTypeCode;
  final String category;
  final String group;
  final String stockClass;
  // final String defaultInputTaxCode;
  // final String defaultOutputTaxCode;

  Stock({
    required this.id,
    required this.stockId,
    required this.stockCode,
    required this.stockName,
    // required this.description,
    // required this.furtherDescription,
    required this.baseUOM,
    // @required this.minQty,
    // @required this.maxQty,
    // @required this.reorderLevel,
    // @required this.reorderQty,
    // @required this.listPrice,
    // @required this.minPrice,
    // @required this.salesDiscount,
    // @required this.purchasePrice,
    // @required this.purchaseDiscount,
    // @required this.barCode,
    required this.weight,
    // @required this.volume,
    // @required this.currentBalance,
    // @required this.lastSellingDate,
    // @required this.lastPurchaseDate,
    required this.isActive,
    // @required this.isBundled,
    // @required this.createDate,
    // @required this.stockControl,
    // @required this.useSerialNo,
    // @required this.serialNoPrefix,
    // @required this.serialNoSuffix,
    required this.remark1,
    // @required this.remark2,
    // @required this.remark3,
    // @required this.remark4,
    // @required this.remark5,
    // @required this.useBatchNo,
    // @required this.itemTypeCode,
    required this.category,
    required this.group,
    required this.stockClass,
    // @required this.defaultInputTaxCode,
    // @required this.defaultOutputTaxCode, 
  });

  Stock copy({
    int? id,
    String? stockId,
    String? stockCode,
    String? stockName,
    String? remark1,
    bool? isActive,
    String? baseUOM,
    double? weight,
    String? category,
    String? group,
    String? stockClass
  }) =>
      Stock(
        id: id ?? this.id,
        stockId: stockId ?? this.stockId,
        stockCode: stockCode ?? this.stockCode,
        stockName: stockName ?? this.stockName,
        remark1: remark1 ?? this.remark1,
        isActive: isActive ?? this.isActive,
        baseUOM: baseUOM ?? this.baseUOM,
        weight: weight ?? this.weight,
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
      // minQty: json['minQty'] as double,
      // maxQty: json['maxQty'] as double,
      // reorderLevel: json['reorderLevel'] as double,
      // reorderQty: json['reorderQty'] as double,
      // listPrice: json['listPrice'] as double,
      // minPrice: json['minPrice'] as double,
      // salesDiscount: json['salesDiscount'] as String,
      // purchasePrice: json['purchasePrice'] as double,
      // purchaseDiscount: json['purchaseDiscount'] as String,
      // barCode: json['barCode'] as String,
      weight: json[StockFields.weight] as double,
      // volume: json['volume'] as double,
      // currentBalance: json['currentBalance'] as double,
      // lastSellingDate: json['lastSellingDate'] as DateTime,
      // lastPurchaseDate: json['lastPurchaseDate'] as DateTime,
      isActive: json[StockFields.isActive] as bool,
      // isBundled: json['isBundled'] as bool,
      // createDate: json['createDate'] as String,
      // stockControl: json['stockControl'] as bool,
      // useSerialNo: json['useSerialNo'] as bool,
      // serialNoPrefix: json['serialNoPrefix'] as String,
      // serialNoSuffix: json['serialNoSuffix'] as String,
      remark1: json[StockFields.remark1] as String,
      // remark2: json['remark2'] as String,
      // remark3: json['remark3'] as String,
      // remark4: json['remark4'] as String,
      // remark5: json['remark5'] as String,
      // useBatchNo: json['useBatchNo'] as bool,
      // itemTypeCode: json['itemTypeCode'] as String,
      category: json[StockFields.category] as String,
      group: json['group'] as String,
      stockClass: json['class'] as String,
      // defaultInputTaxCode: json['defaultInputTaxCode'] as String,
      // defaultOutputTaxCode: json['defaultOutputTaxCode'] as String,
    );
  }

  factory Stock.fromJsonSQL(Map<String, dynamic> json) {
    return Stock(
      id: json[StockFields.id] as int?,
      stockId: json[StockFields.stockId] as String,
      stockCode: json[StockFields.stockCode] as String,
      stockName: json[StockFields.stockName] as String,
      // description: json['description'] ?? json['description'],
      baseUOM: json[StockFields.baseUOM] as String,
      // minQty: json['minQty'] as double,
      // maxQty: json['maxQty'] as double,
      // reorderLevel: json['reorderLevel'] as double,
      // reorderQty: json['reorderQty'] as double,
      // listPrice: json['listPrice'] as double,
      // minPrice: json['minPrice'] as double,
      // salesDiscount: json['salesDiscount'] as String,
      // purchasePrice: json['purchasePrice'] as double,
      // purchaseDiscount: json['purchaseDiscount'] as String,
      // barCode: json['barCode'] as String,
      weight: json[StockFields.weight] as double,
      // volume: json['volume'] as double,
      // currentBalance: json['currentBalance'] as double,
      // lastSellingDate: json['lastSellingDate'] as DateTime,
      // lastPurchaseDate: json['lastPurchaseDate'] as DateTime,
      isActive: json[StockFields.isActive] == 1,
      // isBundled: json['isBundled'] as bool,
      // createDate: json['createDate'] as String,
      // stockControl: json['stockControl'] as bool,
      // useSerialNo: json['useSerialNo'] as bool,
      // serialNoPrefix: json['serialNoPrefix'] as String,
      // serialNoSuffix: json['serialNoSuffix'] as String,
      remark1: json[StockFields.remark1] as String,
      // remark2: json['remark2'] as String,
      // remark3: json['remark3'] as String,
      // remark4: json['remark4'] as String,
      // remark5: json['remark5'] as String,
      // useBatchNo: json['useBatchNo'] as bool,
      // itemTypeCode: json['itemTypeCode'] as String,
      category: json[StockFields.category] as String,
      group: json[StockFields.stockGroup] as String,
      stockClass: json[StockFields.stockClass] as String,
      // defaultInputTaxCode: json['defaultInputTaxCode'] as String,
      // defaultOutputTaxCode: json['defaultOutputTaxCode'] as String,
    );
  }

  Map<String, Object?> toJson() => {
    StockFields.id: id,
    StockFields.stockId: stockId,
    StockFields.stockCode: stockCode,
    StockFields.stockName: stockName,
    StockFields.remark1: remark1,
    StockFields.isActive: isActive ? 1 : 0,
    StockFields.baseUOM: baseUOM,
    StockFields.weight: weight,
    StockFields.category: category,
    StockFields.stockGroup: group,
    StockFields.stockClass: stockClass
  };
}