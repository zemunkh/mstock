const String tableCounterInLoose = 'counterInLoose';

class CounterInLooseFields {
  static final List<String> values = [
    /// Add all fields
    id, stock, description, machine, shift, 
    device, uom, qty, totalQty, purchasePrice, isPosted, shiftDate, createdAt, updatedAt
  ];

  static const String id = '_id';
  static const String stock = 'stock'; // stockCode
  static const String description = 'description';
  static const String machine = 'machine';
  static const String shift = 'shift';
  static const String device = 'device';
  static const String uom = 'uom'; // BaseUOM
  static const String qty = 'qty'; // Quantity
  static const String totalQty = 'totalQty'; // Quantity
  static const String purchasePrice = 'purchasePrice'; // purchasePrice
  static const String isPosted = 'isPosted'; // Flag to identify Posted or not
  static const String shiftDate = 'shiftDate';
  static const String createdAt = 'created_at'; // createdDate
  static const String updatedAt = 'updated_at'; // updatedDate
}


class CounterInLoose {
  int? id;
  final String stock;
  final String description;
  final String machine;
  final String shift;
  final String device;
  final String uom;
  final int qty;
  final int totalQty;
  final double purchasePrice;
  final bool isPosted;
  final DateTime shiftDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  CounterInLoose({
    this.id,
    required this.stock,
    required this.description,
    required this.machine,
    required this.shift,
    required this.device,
    required this.uom,
    required this.qty,
    required this.totalQty,
    required this.purchasePrice,
    required this.isPosted,
    required this.shiftDate,
    required this.createdAt,
    required this.updatedAt
  });

  CounterInLoose copy({
    int? id,
    String? stock,
    String? description,
    String? machine,
    String? shift,
    String? device,
    String? uom,
    int? qty,
    int? totalQty,
    double? purchasePrice,
    bool? isPosted,
    DateTime? shiftDate,
    DateTime? createdAt,
    DateTime? updatedAt
  }) =>
      CounterInLoose(
        id: id ?? this.id,
        stock: stock ?? this.stock,
        description: description ?? this.description,
        machine: machine ?? this.machine,
        shift: shift ?? this.shift,
        device: device ?? this.device,
        uom: uom ?? this.uom,
        qty: qty ?? this.qty,
        totalQty: totalQty ?? this.totalQty,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        isPosted: isPosted ?? this.isPosted,
        shiftDate: shiftDate ?? this.shiftDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
      );

  factory CounterInLoose.fromJson(Map<String, dynamic> json) {
    return CounterInLoose(
      id: json[CounterInLooseFields.id] as int,
      stock: json[CounterInLooseFields.stock] as String,
      description: json[CounterInLooseFields.description] as String,
      machine: json[CounterInLooseFields.machine] as String,
      shift: json[CounterInLooseFields.shift] as String,
      device: json[CounterInLooseFields.device] as String,
      uom: json[CounterInLooseFields.uom] as String,
      qty: json[CounterInLooseFields.qty] as int,
      totalQty: json[CounterInLooseFields.totalQty] as int,
      purchasePrice: json[CounterInLooseFields.purchasePrice] as double,
      isPosted: json[CounterInLooseFields.isPosted]  == 1,
      shiftDate: DateTime.parse(json[CounterInLooseFields.shiftDate] as String),
      createdAt: DateTime.parse(json[CounterInLooseFields.createdAt] as String),
      updatedAt: DateTime.parse(json[CounterInLooseFields.updatedAt] as String)
    );
  }

  Map<String, dynamic> toJson() => {
    CounterInLooseFields.stock: stock,
    CounterInLooseFields.description: description,
    CounterInLooseFields.machine: machine,
    CounterInLooseFields.shift: shift,
    CounterInLooseFields.device: device,
    CounterInLooseFields.uom: uom,
    CounterInLooseFields.qty: qty.toString(),
    CounterInLooseFields.totalQty: totalQty.toString(),
    CounterInLooseFields.purchasePrice: purchasePrice.toString(),
    CounterInLooseFields.isPosted: isPosted ? 1 : 0,
    CounterInLooseFields.shiftDate: shiftDate.toIso8601String(),
    CounterInLooseFields.createdAt: createdAt.toIso8601String(),
    CounterInLooseFields.updatedAt: updatedAt.toIso8601String()
  };
  Map<String, dynamic> postedToJson() => {
    CounterInLooseFields.isPosted: 1,
  };
}