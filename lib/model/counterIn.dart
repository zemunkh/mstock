const String tableCounterIn = 'counterIn';

class CounterInFields {
  static final List<String> values = [
    /// Add all fields
    id, stock, description, machine, shift, 
    device, uom, qty, purchasePrice, isPosted, createdAt, updatedAt
  ];

  static const String id = '_id';
  static const String stock = 'stock'; // stockCode
  static const String description = 'description';
  static const String machine = 'machine';
  static const String shift = 'shift';
  static const String device = 'device';
  static const String uom = 'uom'; // BaseUOM
  static const String qty = 'qty'; // Quantity
  static const String purchasePrice = 'purchasePrice'; // purchasePrice
  static const String isPosted = 'isPosted'; // Flag to identify Posted or not
  static const String createdAt = 'created_at'; // createdDate
  static const String updatedAt = 'updated_at'; // updatedDate
}


class CounterIn {
  int? id;
  final String stock;
  final String description;
  final String machine;
  final String shift;
  final String device;
  final String uom;
  final int qty;
  final double purchasePrice;
  final bool isPosted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CounterIn({
    this.id,
    required this.stock,
    required this.description,
    required this.machine,
    required this.shift,
    required this.device,
    required this.uom,
    required this.qty,
    required this.purchasePrice,
    required this.isPosted,
    required this.createdAt,
    required this.updatedAt
  });

  CounterIn copy({
    int? id,
    String? stock,
    String? description,
    String? machine,
    String? shift,
    String? device,
    String? uom,
    int? qty,
    double? purchasePrice,
    bool? isPosted,
    DateTime? createdAt,
    DateTime? updatedAt

  }) =>
      CounterIn(
        id: id ?? this.id,
        stock: stock ?? this.stock,
        description: description ?? this.description,
        machine: machine ?? this.machine,
        shift: shift ?? this.shift,
        device: device ?? this.device,
        uom: uom ?? this.uom,
        qty: qty ?? this.qty,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        isPosted: isPosted ?? this.isPosted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
      );

  factory CounterIn.fromJson(Map<String, dynamic> json) {
    return CounterIn(
      id: json[CounterInFields.id] as int,
      stock: json[CounterInFields.stock] as String,
      description: json[CounterInFields.description] as String,
      machine: json[CounterInFields.machine] as String,
      shift: json[CounterInFields.shift] as String,
      device: json[CounterInFields.device] as String,
      uom: json[CounterInFields.uom] as String,
      qty: json[CounterInFields.qty] as int,
      purchasePrice: json[CounterInFields.purchasePrice] as double,
      isPosted: json[CounterInFields.isPosted]  == 1,
      createdAt: DateTime.parse(json[CounterInFields.createdAt] as String),
      updatedAt: DateTime.parse(json[CounterInFields.updatedAt] as String)
    );
  }

  Map<String, dynamic> toJson() => {
    CounterInFields.stock: stock,
    CounterInFields.description: description,
    CounterInFields.machine: machine,
    CounterInFields.shift: shift,
    CounterInFields.device: device,
    CounterInFields.uom: uom,
    CounterInFields.qty: qty.toString(),
    CounterInFields.purchasePrice: purchasePrice.toString(),
    CounterInFields.isPosted: isPosted ? 1 : 0,
    CounterInFields.createdAt: createdAt.toIso8601String(),
    CounterInFields.updatedAt: updatedAt.toIso8601String()
  };
}