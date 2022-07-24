const String tableCounter = 'counter';

class CounterFields {
  static final List<String> values = [
    /// Add all fields
    id, stockId, machine, shift, createdTime, stockCategory, group, stockClass, weight, qty, baseUOM
  ];

  static const String id = '_id';
  static const String stockId = 'stockId';
  static const String stockCode = 'stockCode';
  static const String machine = 'machine';
  static const String shift = 'shift';
  static const String createdTime = 'createdTime';
  static const String stockCategory = 'stockCategory';
  static const String group = 'group';
  static const String stockClass = 'stockClass';
  static const String weight = 'weight';
  static const String qty = 'qty';
  static const String baseUOM = 'description';
}


class Counter {
  final int id;
  final String stockId;
  final String stockCode;
  final String machine;
  final String shift;
  final DateTime createdTime;
  final String stockCategory;
  final String group;
  final String stockClass;
  final int weight;
  final int qty;
  final String baseUOM;

  Counter({
    required this.id,
    required this.stockId,
    required this.stockCode,
    required this.machine,
    required this.shift,
    required this.createdTime,
    required this.stockCategory,
    required this.group,
    required this.stockClass,
    required this.weight,
    required this.qty,
    required this.baseUOM,
  });

  Counter copy({
    int? id,
    String? stockId,
    String? stockCode,
    String? machine,
    String? shift,
    DateTime? createdTime,
    String? stockCategory,
    String? group,
    String? stockClass,
    int? weight,
    int? qty,
    String? baseUOM
  }) =>
      Counter(
        id: id ?? this.id,
        stockId: stockId ?? this.stockId,
        stockCode: stockCode ?? this.stockCode,
        machine: machine ?? this.machine,
        shift: shift ?? this.shift,
        createdTime: createdTime ?? this.createdTime,
        stockCategory: stockCategory ?? this.stockCategory,
        group: stockId ?? this.group,
        stockClass: stockClass ?? this.stockClass,
        weight: weight ?? this.weight,
        qty: qty ?? this.qty,
        baseUOM: baseUOM ?? this.baseUOM
      );

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      id: json[CounterFields.id] as int,
      stockId: json[CounterFields.stockId] as String,
      stockCode: json[CounterFields.stockCode] as String,
      machine: json[CounterFields.machine] as String,
      shift: json[CounterFields.shift] as String,
      createdTime: DateTime.parse(json[CounterFields.createdTime] as String),
      stockCategory: json[CounterFields.stockCategory] as String,
      group: json[CounterFields.group] as String,
      stockClass: json[CounterFields.stockClass] as String,
      weight: json[CounterFields.weight] as int,
      qty: json[CounterFields.qty] as int,
      baseUOM: json[CounterFields.baseUOM] as String,
    );
  }

  Map<String, Object?> toJson() => {
    CounterFields.id: id,
    CounterFields.stockId: stockId,
    CounterFields.stockCode: stockCode,
    CounterFields.machine: machine,
    CounterFields.shift: shift,
    CounterFields.createdTime: createdTime.toIso8601String(),
    CounterFields.stockCategory: stockCategory,
    CounterFields.group: group,
    CounterFields.stockClass: stockClass,
    CounterFields.weight: weight,
    CounterFields.qty: qty,
    CounterFields.baseUOM: baseUOM,

  };
}