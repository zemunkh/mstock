const String tableCounter = 'counter';

class CounterFields {
  static final List<String> values = [
    /// Add all fields
    id, stockId, stockCode, machine, shift, createdTime, updatedTime, stockCategory, stockGroup, stockClass, weight, qty, totalQty, baseUOM
  ];

  static const String id = 'id';
  static const String stockId = 'stockId';
  static const String stockCode = 'stockCode';
  static const String machine = 'machine';
  static const String shift = 'shift';
  static const String createdTime = 'created_at';
  static const String updatedTime = 'updated_at';
  static const String stockCategory = 'category';
  static const String stockGroup = 'stockGroup';
  static const String stockClass = 'class';
  static const String weight = 'weight';
  static const String qty = 'qty';
  static const String totalQty = 'totalQty'; 
  static const String baseUOM = 'baseUOM';
}


class Counter {
  int? id;
  final String stockId;
  final String stockCode;
  final String machine;
  final String shift;
  final DateTime createdTime;
  final DateTime updatedTime;
  final String stockCategory;
  final String group;
  final String stockClass;
  final double weight;
  final int qty;
  final int totalQty;
  final String baseUOM;

  Counter({
    this.id,
    required this.stockId,
    required this.stockCode,
    required this.machine,
    required this.shift,
    required this.createdTime,
    required this.updatedTime,
    required this.stockCategory,
    required this.group,
    required this.stockClass,
    required this.weight,
    required this.qty,
    required this.totalQty,
    required this.baseUOM,
  });

  Counter copy({
    int? id,
    String? stockId,
    String? stockCode,
    String? machine,
    String? shift,
    DateTime? createdTime,
    DateTime? updatedTime,
    String? stockCategory,
    String? group,
    String? stockClass,
    double? weight,
    int? qty,
    int? totalQty,
    String? baseUOM
  }) =>
      Counter(
        id: id ?? this.id,
        stockId: stockId ?? this.stockId,
        stockCode: stockCode ?? this.stockCode,
        machine: machine ?? this.machine,
        shift: shift ?? this.shift,
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime,
        stockCategory: stockCategory ?? this.stockCategory,
        group: stockId ?? this.group,
        stockClass: stockClass ?? this.stockClass,
        weight: weight ?? this.weight,
        qty: qty ?? this.qty,
        totalQty: totalQty ?? this.totalQty,
        baseUOM: baseUOM ?? this.baseUOM
      );

  factory Counter.fromJsonSQL(Map<String, dynamic> json) {
    return Counter(
      id: json[CounterFields.id] as int,
      stockId: json[CounterFields.stockId] as String,
      stockCode: json[CounterFields.stockCode] as String,
      machine: json[CounterFields.machine] as String,
      shift: json[CounterFields.shift] as String,
      createdTime: DateTime.parse(json[CounterFields.createdTime] as String),
      updatedTime: DateTime.parse(json[CounterFields.updatedTime] as String),
      stockCategory: json[CounterFields.stockCategory] as String,
      group: json[CounterFields.stockGroup] as String,
      stockClass: json[CounterFields.stockClass] as String,
      weight: json[CounterFields.weight] as double,
      qty: json[CounterFields.qty] as int,
      totalQty: json[CounterFields.totalQty] as int,
      baseUOM: json[CounterFields.baseUOM] as String,
    );
  }

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      id: json[CounterFields.id] as int,
      stockId: json[CounterFields.stockId] as String,
      stockCode: json[CounterFields.stockCode] as String,
      machine: json[CounterFields.machine] as String,
      shift: json[CounterFields.shift] as String,
      createdTime: DateTime.parse(json[CounterFields.createdTime] as String),
      updatedTime: DateTime.parse(json[CounterFields.updatedTime] as String),
      stockCategory: json[CounterFields.stockCategory] as String,
      group: json[CounterFields.stockGroup] as String,
      stockClass: json[CounterFields.stockClass] as String,
      weight: json[CounterFields.weight] as double,
      qty: json[CounterFields.qty] as int,
      totalQty: json[CounterFields.totalQty] as int,
      baseUOM: json[CounterFields.baseUOM] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    CounterFields.stockId: stockId,
    CounterFields.stockCode: stockCode,
    CounterFields.machine: machine,
    CounterFields.shift: shift,
    CounterFields.createdTime: createdTime.toIso8601String(),
    CounterFields.updatedTime: updatedTime.toIso8601String(),
    CounterFields.stockCategory: stockCategory,
    CounterFields.stockGroup: group,
    CounterFields.stockClass: stockClass,
    CounterFields.weight: weight.toString(),
    CounterFields.qty: qty.toString(),
    CounterFields.totalQty: totalQty.toString(),
    CounterFields.baseUOM: baseUOM,
  };
}