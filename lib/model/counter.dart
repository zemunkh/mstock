const String tableCounter = 'counter';

class CounterFields {
  static final List<String> values = [
    /// Add all fields
    id, stockId, stockCode, stockName, machine, device, shift, stockCategory, stockGroup, 
    stockClass, weight, qty, totalQty, purchasePrice, uom, createdTime, updatedTime
  ];

  static const String id = 'id';
  static const String stockId = 'stockId';
  static const String stockCode = 'stockCode';
  static const String stockName = 'stockName';
  static const String machine = 'machine';
  static const String device = 'device';
  static const String shift = 'shift';
  static const String stockCategory = 'category';
  static const String stockGroup = 'stockGroup';
  static const String stockClass = 'class';
  static const String weight = 'weight';
  static const String qty = 'qty';
  static const String totalQty = 'totalQty'; 
  static const String purchasePrice = 'purchasePrice';
  static const String uom = 'uom';
  static const String shiftDate = 'shiftDate';
  static const String createdTime = 'created_at';
  static const String updatedTime = 'updated_at';
}


class Counter {
  int? id;
  final String stockId;
  final String stockCode;
  final String stockName;
  final String machine;
  final String device;
  final String shift;
  final String stockCategory;
  final String group;
  final String stockClass;
  final double weight;
  final int qty;
  final int totalQty;
  final double purchasePrice;
  final String uom;
  final DateTime shiftDate;
  final DateTime createdTime;
  final DateTime updatedTime;

  Counter({
    this.id,
    required this.stockId,
    required this.stockCode,
    required this.stockName,
    required this.machine,
    required this.device,
    required this.shift,
    required this.stockCategory,
    required this.group,
    required this.stockClass,
    required this.weight,
    required this.qty,
    required this.totalQty,
    required this.purchasePrice,
    required this.uom,
    required this.shiftDate,
    required this.createdTime,
    required this.updatedTime
  });

  Counter copy({
    int? id,
    String? stockId,
    String? stockCode,
    String? stockName,
    String? machine,
    String? device,
    String? shift,
    String? stockCategory,
    String? group,
    String? stockClass,
    double? weight,
    int? qty,
    int? totalQty,
    double? purchasePrice,
    String? uom,
    DateTime? shiftDate,
    DateTime? createdTime,
    DateTime? updatedTime
  }) =>
      Counter(
        id: id ?? this.id,
        stockId: stockId ?? this.stockId,
        stockCode: stockCode ?? this.stockCode,
        stockName: stockName ?? this.stockName,
        machine: machine ?? this.machine,
        device: device ?? this.device,
        shift: shift ?? this.shift,
        stockCategory: stockCategory ?? this.stockCategory,
        group: stockId ?? this.group,
        stockClass: stockClass ?? this.stockClass,
        weight: weight ?? this.weight,
        qty: qty ?? this.qty,
        totalQty: totalQty ?? this.totalQty,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        uom: uom ?? this.uom,
        shiftDate: shiftDate ?? this.shiftDate,
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime
      );

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      id: json[CounterFields.id] as int,
      stockId: json[CounterFields.stockId] as String,
      stockCode: json[CounterFields.stockCode] as String,
      stockName: json[CounterFields.stockName] as String,
      machine: json[CounterFields.machine] as String,
      device: json[CounterFields.device] as String,
      shift: json[CounterFields.shift] as String,
      stockCategory: json[CounterFields.stockCategory] as String,
      group: json[CounterFields.stockGroup] as String,
      stockClass: json[CounterFields.stockClass] as String,
      weight: json[CounterFields.weight] as double,
      qty: json[CounterFields.qty] as int,
      totalQty: json[CounterFields.totalQty] as int,
      purchasePrice: json[CounterFields.purchasePrice] as double,
      uom: json[CounterFields.uom] as String,
      shiftDate: DateTime.parse(json[CounterFields.shiftDate] as String),
      createdTime: DateTime.parse(json[CounterFields.createdTime] as String),
      updatedTime: DateTime.parse(json[CounterFields.updatedTime] as String)
    );
  }

  Map<String, dynamic> toJson() => {
    CounterFields.stockId: stockId,
    CounterFields.stockCode: stockCode,
    CounterFields.stockName: stockName,
    CounterFields.machine: machine,
    CounterFields.device: device,
    CounterFields.shift: shift,
    CounterFields.stockCategory: stockCategory,
    CounterFields.stockGroup: group,
    CounterFields.stockClass: stockClass,
    CounterFields.weight: weight.toString(),
    CounterFields.qty: qty.toString(),
    CounterFields.totalQty: totalQty.toString(),
    CounterFields.purchasePrice: purchasePrice.toString(),
    CounterFields.uom: uom,
    CounterFields.shiftDate: shiftDate.toIso8601String(),
    CounterFields.createdTime: createdTime.toIso8601String(),
    CounterFields.updatedTime: updatedTime.toIso8601String(),
  };
}