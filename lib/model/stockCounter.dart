const String tableCounterIn = 'counterIn';

class StockCounterFields {
  static final List<String> values = [
    /// Add all fields
    id, stock, description, machine, shift, 
    device, uom, qty, purchasePrice, isPosted, shiftDate, createdAt, updatedAt
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
  static const String shiftDate = 'shiftDate';
  static const String createdAt = 'created_at'; // createdDate
  static const String updatedAt = 'updated_at'; // updatedDate
}


class StockCounter {
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
  final DateTime shiftDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  StockCounter({
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
    required this.shiftDate,
    required this.createdAt,
    required this.updatedAt
  });

  StockCounter copy({
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
    DateTime? shiftDate,
    DateTime? createdAt,
    DateTime? updatedAt
  }) =>
      StockCounter(
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
        shiftDate: shiftDate ?? this.shiftDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
      );

  factory StockCounter.fromJson(Map<String, dynamic> json) {
    return StockCounter(
      id: json[StockCounterFields.id] as int,
      stock: json[StockCounterFields.stock] as String,
      description: json[StockCounterFields.description] as String,
      machine: json[StockCounterFields.machine] as String,
      shift: json[StockCounterFields.shift] as String,
      device: json[StockCounterFields.device] as String,
      uom: json[StockCounterFields.uom] as String,
      qty: json[StockCounterFields.qty] as int,
      purchasePrice: json[StockCounterFields.purchasePrice] as double,
      isPosted: json[StockCounterFields.isPosted]  == 1,
      shiftDate: DateTime.parse(json[StockCounterFields.shiftDate] as String),
      createdAt: DateTime.parse(json[StockCounterFields.createdAt] as String),
      updatedAt: DateTime.parse(json[StockCounterFields.updatedAt] as String)
    );
  }

  Map<String, dynamic> toJson() => {
    StockCounterFields.stock: stock,
    StockCounterFields.description: description,
    StockCounterFields.machine: machine,
    StockCounterFields.shift: shift,
    StockCounterFields.device: device,
    StockCounterFields.uom: uom,
    StockCounterFields.qty: qty.toString(),
    StockCounterFields.purchasePrice: purchasePrice.toString(),
    StockCounterFields.isPosted: isPosted ? 1 : 0,
    StockCounterFields.shiftDate: shiftDate.toIso8601String(),
    StockCounterFields.createdAt: createdAt.toIso8601String(),
    StockCounterFields.updatedAt: updatedAt.toIso8601String()
  };
  Map<String, dynamic> postedToJson() => {
    StockCounterFields.isPosted: 1,
  };
}