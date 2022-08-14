import 'package:flutter/foundation.dart';

class Uom {
  final String id;
  final String stockCode;
  final String uomCode;
  final String description;
  // final double salesPrice;
  final double rate;
  final bool isBaseUOM;
  // final double purchasePrice;
  // final double minSalesPrice;
  // final double maxSalesPrice;
  // final double minPurchasePrice;
  // final double maxPurchasePrice;
  // final String salesDiscount;
  // final String purchaseDiscount;
  // final String barCode;
  // final int pos;
  final bool isActive;

  Uom({
    required this.id,
    required this.stockCode,
    required this.uomCode,
    required this.description,
    // required this.salesPrice,
    required this.rate,
    required this.isBaseUOM,
    // required this.purchasePrice,
    // required this.minSalesPrice,
    // required this.maxSalesPrice,
    // required this.minPurchasePrice,
    // required this.maxPurchasePrice,
    // required this.salesDiscount,
    // required this.purchaseDiscount,
    // required this.barCode,
    // required this.pos,
    required this.isActive,
  });

  factory Uom.fromJson(Map<String, dynamic> json) {
    return Uom(
      id: json['id'] as String,
      stockCode: json['stockCode'] as String,
      uomCode: json['uomCode'] as String,
      description: json['description'] as String,
      // salesPrice: json['salesPrice'] as double,
      rate: json['rate'] as double,
      isBaseUOM: json['isBaseUOM'] as bool,
      // purchasePrice: json['purchasePrice'] as double,
      // minSalesPrice: json['minSalesPrice'] as double,
      // maxSalesPrice: json['maxSalesPrice'] as double,
      // minPurchasePrice: json['minPurchasePrice'] as double,
      // maxPurchasePrice: json['maxPurchasePrice'] as double,
      // salesDiscount: json['salesDiscount'] as String,
      // purchaseDiscount: json['purchaseDiscount'] as String,
      // barCode: json['barCode'] as String,
      // pos: json['pos'] as int,
      isActive: json['isActive'] as bool,
    );
  }

}
