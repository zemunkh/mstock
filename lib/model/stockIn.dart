import 'dart:convert' show json, utf8;

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
  final String ref1;
  // final String ref2;
  // final String ref3;
  // final String ref4;
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
    required this.ref1,
    // required this.ref2,
    // required this.ref3,
    // required this.ref4,
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
      ref1: json['ref1'] as String,
      // ref2: json['Ref2'] as String,
      // ref3: json['Ref3'] as String,
      // ref4: json['Ref4'] as String,
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
    'ref1': ref1,
    // 'Ref2': ref2,
    // 'Ref3': ref3,
    // 'Ref4': ref4,
    'costCentre': costCentre,
    'project': project,
    'stockLocation': stockLocation,
  };
}

class StockIn {
  final String stockInCode;
  final DateTime stockInDate;
  final String description;
  final String referenceNo;
  final String title;
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
    required this.notes,
    required this.costCentre,
    required this.project,
    required this.stockLocation,
    required this.details,
  });

  factory StockIn.fromJson(Map<String, dynamic> json) {
    return StockIn(
      stockInCode: json['stockInCode'] as String,
      stockInDate: DateTime.parse(json['stockInDate'] as String),
      description: json['description'] as String,
      referenceNo: json['referenceNo'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      costCentre: json['costCentre'] as String,
      project: json['project'] as String,
      stockLocation: json['stockLocation'] as String,
      details: json['details'].map((e) => Details.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> details = this.details.map((i) => i!.toJson()).toList();
    // print('Here 👉 ${details.join(',')}');
    return {
      'stockInCode': stockInCode,
      'stockInDate': stockInDate.toIso8601String(),
      'description': description,
      'referenceNo': referenceNo,
      'title': title,
      'notes': notes,
      'costCentre': costCentre,
      'project': project,
      'stockLocation': stockLocation,
      'details': details,
    };
  }
}