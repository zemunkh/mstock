import 'package:flutter/foundation.dart';

class Stock {
  final String id;
  final String stockCode;
  final String stockName;
  final String stockName2;
  final String description;
  final String furtherDescription;
  final String baseUOM;
  // final double minQty;
  // final double maxQty;
  // final double reorderLevel;
  // final double reorderQty;
  // final double listPrice;
  // final double minPrice;
  // final String salesDiscount;
  // final double purchasePrice;
  // final String purchaseDiscount;
  // final String barCode;
  // final double weight;
  // final double volumn;
  // final double currentBalance;
  // final DateTime lastSellingDate;
  // final DateTime lastPurchaseDate;
  // final bool isActive;
  // final bool isBundled;
  // final String createDate;
  // final bool stockControl;
  // final bool useSerialNo;
  // final String serialNoPrefix;
  // final String serialNoSuffix;
  // final String remark1;
  // final String remark2;
  // final String remark3;
  // final String remark4;
  // final String remark5;
  // final bool useBatchNo;
  // final String itemTypeCode;
  // final String category;
  // final String group;
  // final String clas;
  // final String defaultInputTaxCode;
  // final String defaultOutputTaxCode;

  Stock({
    required this.id,
    required this.stockCode,
    required this.stockName,
    required this.stockName2,
    required this.description,
    required this.furtherDescription,
    required this.baseUOM,
    // @required this.minQty,
    // @required this.maxQty,
    // @required this.reorderLevel,
    // @required this.reorderQty,
    // @required this.listPrice,
    // @required this.minPrice,
    // @required this.salesDiscount,
    // @required this.purchasePrice,
    // @required this.purchaseDiscount,
    // @required this.barCode,
    // @required this.weight,
    // @required this.volumn,
    // @required this.currentBalance,
    // @required this.lastSellingDate,
    // @required this.lastPurchaseDate,
    // @required this.isActive,
    // @required this.isBundled,
    // @required this.createDate,
    // @required this.stockControl,
    // @required this.useSerialNo,
    // @required this.serialNoPrefix,
    // @required this.serialNoSuffix,
    // @required this.remark1,
    // @required this.remark2,
    // @required this.remark3,
    // @required this.remark4,
    // @required this.remark5,
    // @required this.useBatchNo,
    // @required this.itemTypeCode,
    // @required this.category,
    // @required this.group,
    // @required this.clas,
    // @required this.defaultInputTaxCode,
    // @required this.defaultOutputTaxCode, 
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] as String,
      stockCode: json['stockCode'] as String,
      stockName: json['stockName'] as String,
      stockName2: json['stockName2'] as String,
      description: json['description'] as String,
      furtherDescription: json['furtherDescription'] as String,
      baseUOM: json['baseUOM'] as String,
      // minQty: json['minQty'] as double,
      // maxQty: json['maxQty'] as double,
      // reorderLevel: json['reorderLevel'] as double,
      // reorderQty: json['reorderQty'] as double,
      // listPrice: json['listPrice'] as double,
      // minPrice: json['minPrice'] as double,
      // salesDiscount: json['salesDiscount'] as String,
      // purchasePrice: json['purchasePrice'] as double,
      // purchaseDiscount: json['purchaseDiscount'] as String,
      // barCode: json['barCode'] as String,
      // weight: json['weight'] as double,
      // volumn: json['volumn'] as double,
      // currentBalance: json['currentBalance'] as double,
      // lastSellingDate: json['lastSellingDate'] as DateTime,
      // lastPurchaseDate: json['lastPurchaseDate'] as DateTime,
      // isActive: json['isActive'] as bool,
      // isBundled: json['isBundled'] as bool,
      // createDate: json['createDate'] as String,
      // stockControl: json['stockControl'] as bool,
      // useSerialNo: json['useSerialNo'] as bool,
      // serialNoPrefix: json['serialNoPrefix'] as String,
      // serialNoSuffix: json['serialNoSuffix'] as String,
      // remark1: json['remark1'] as String,
      // remark2: json['remark2'] as String,
      // remark3: json['remark3'] as String,
      // remark4: json['remark4'] as String,
      // remark5: json['remark5'] as String,
      // useBatchNo: json['useBatchNo'] as bool,
      // itemTypeCode: json['itemTypeCode'] as String,
      // category: json['category'] as String,
      // group: json['group'] as String,
      // clas: json['class'] as String,
      // defaultInputTaxCode: json['defaultInputTaxCode'] as String,
      // defaultOutputTaxCode: json['defaultOutputTaxCode'] as String,
    );
  }
}