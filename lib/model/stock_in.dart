class Details {
  final String numbering;
  final String stock;
  final int pos;
  final String description;
  final double price;
  final String uom;
  final int qty;
  final double amount;
  final String note;
  final String costCentre;
  final String project;
  final String stockLocation;

  Details({
    required this.numbering,
    required this.stock,
    required this.pos,
    required this.description,
    required this.price,
    required this.uom,
    required this.qty,
    required this.amount,
    required this.note,
    required this.costCentre,
    required this.project,
    required this.stockLocation,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      numbering: json['numbering'] as String,
      stock: json['stock'] as String,
      pos: json['pos'] as int,
      description: json['description'] as String,
      price: json['price'] as double,
      uom: json['uom'] as String,
      qty: json['qty'] as int,
      amount: json['amount'] as double,
      note: json['note'] as String,
      costCentre: json['costCentre'] as String,
      project: json['project'] as String,
      stockLocation: json['stockLocation'] as String,
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'numbering': numbering,
    'stock': stock,
    'pos': pos,
    'description': description,
    'price': price,
    'uom': uom,
    'qty': qty,
    'amount': amount,
    'note': note,
    'costCentre': costCentre,
    'project': project,
    'stockLocation': stockLocation,
  };
}

class StockIn {
  final String stockInCode;
  final String stockInDate;
  final String description;
  final String referenceNo;
  final String title;
  final bool isCancelled;
  final String notes;
  final String costCentre;
  final String project;
  final String stockLocation;
  final List<Details?> details;

  StockIn({
    required this.stockInCode,
    required this.stockInDate,
    required this.description,
    required this.referenceNo,
    required this.title,
    required this.isCancelled,
    required this.notes,
    required this.costCentre,
    required this.project,
    required this.stockLocation,
    required this.details,
  });

  factory StockIn.fromJson(Map<String, dynamic> json) {
    return StockIn(
      stockInCode: json['stockInCode'] as String,
      stockInDate: json['stockInDate'] as String,
      description: json['description'] as String,
      referenceNo: json['referenceNo'] as String,
      title: json['title'] as String,
      isCancelled: json['isCancelled'] as bool,
      notes: json['notes'] as String,
      costCentre: json['costCentre'] as String,
      project: json['project'] as String,
      stockLocation: json['stockLocation'] as String,
      details: json['details'].map((e) => Details.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? details = this.details.map((i) => i!.toJson()).toList();
    return {
      'stockInCode': stockInCode,
      'stockInDate': stockInDate,
      'description': description,
      'referenceNo': referenceNo,
      'title': title,
      'isCancelled': isCancelled,
      'notes': notes,
      'costCentre': costCentre,
      'project': project,
      'stockLocation': stockLocation,
      'details': details,
    };
  }
}