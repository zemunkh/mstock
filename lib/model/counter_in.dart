const String tableCounterIn = 'counterIn';

class CounterInFields {
  static final List<String> values = [
    /// Add all fields
    id, stockInCode, description, referenceNo, stockLocation, 
    numbering, stock, uom, qty, createdAt, updatedAt
  ];

  static const String id = '_id';
  static const String stockInCode = 'stockInCode'; // StockCode
  static const String description = 'description'; // Machine Line + Shift Name
  static const String referenceNo = 'referenceNo'; // Doc Prefix / Numbering
  static const String stockLocation = 'stockLocation'; // Location
  static const String numbering = 'numbering';
  static const String stock = 'stock'; // StockCode
  static const String uom = 'uom'; // BaseUOM
  static const String qty = 'qty'; // Quantity
  static const String createdAt = 'created_at'; // createdDate
  static const String updatedAt = 'updated_at'; // updatedDate
}


class CounterIn {
  int? id;
  final String stockInCode;
  final String description;
  final String referenceNo;
  final String stockLocation;
  final String numbering;
  final String stock;
  final String uom;
  final int qty;
  final DateTime createdAt;
  final DateTime updatedAt;

  CounterIn({
    this.id,
    required this.stockInCode,
    required this.description,
    required this.referenceNo,
    required this.stockLocation,
    required this.numbering,
    required this.stock,
    required this.uom,
    required this.qty,
    required this.createdAt,
    required this.updatedAt
  });

  CounterIn copy({
    int? id,
    String? stockInCode,
    String? description,
    String? referenceNo,
    String? numbering,
    String? stockLocation,
    String? stock,
    String? uom,
    int? qty,
    DateTime? createdAt,
    DateTime? updatedAt

  }) =>
      CounterIn(
        id: id ?? this.id,
        stockInCode: stockInCode ?? this.stockInCode,
        description: description ?? this.description,
        referenceNo: referenceNo ?? this.referenceNo,
        numbering: numbering ?? this.numbering,
        stockLocation: stockLocation ?? this.stockLocation,
        stock: stock ?? this.stock,
        uom: uom ?? this.uom,
        qty: qty ?? this.qty,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
      );

  factory CounterIn.fromJsonSQL(Map<String, dynamic> json) {
    return CounterIn(
      id: json[CounterInFields.id] as int,
      stockInCode: json[CounterInFields.stockInCode] as String,
      description: json[CounterInFields.description] as String,
      referenceNo: json[CounterInFields.referenceNo] as String,
      numbering: json[CounterInFields.numbering] as String,
      stockLocation: json[CounterInFields.stockLocation] as String,
      stock: json[CounterInFields.stock] as String,
      uom: json[CounterInFields.uom] as String,
      qty: json[CounterInFields.qty] as int,
      createdAt: DateTime.parse(json[CounterInFields.createdAt] as String),
      updatedAt: DateTime.parse(json[CounterInFields.updatedAt] as String)
    );
  }

  factory CounterIn.fromJson(Map<String, dynamic> json) {
    return CounterIn(
      id: json[CounterInFields.id] as int,
      stockInCode: json[CounterInFields.stockInCode] as String,
      description: json[CounterInFields.description] as String,
      referenceNo: json[CounterInFields.referenceNo] as String,
      numbering: json[CounterInFields.numbering] as String,
      stockLocation: json[CounterInFields.stockLocation] as String,
      stock: json[CounterInFields.stock] as String,
      uom: json[CounterInFields.uom] as String,
      qty: json[CounterInFields.qty] as int,
      createdAt: DateTime.parse(json[CounterInFields.createdAt] as String),
      updatedAt: DateTime.parse(json[CounterInFields.updatedAt] as String)
    );
  }

  Map<String, dynamic> toJson() => {
    CounterInFields.stockInCode: stockInCode,
    CounterInFields.description: description,
    CounterInFields.referenceNo: referenceNo,
    CounterInFields.numbering: numbering,
    CounterInFields.stockLocation: stockLocation,
    CounterInFields.stock: stock,
    CounterInFields.uom: uom,
    CounterInFields.qty: qty.toString(),
    CounterInFields.createdAt: createdAt.toIso8601String(),
    CounterInFields.updatedAt: updatedAt.toIso8601String()
  };
}