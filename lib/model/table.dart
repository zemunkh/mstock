import 'package:flutter/foundation.dart';

class Table {
  final String id;
  final String stockId;
  final String machine;
  final String shift;
  final String dateTime;
  final String stockCode;
  final String stockCategory;
  final String group;
  final String stockClass;
  final int weight;
  final int qty;
  final String baseUOM;

  Table({
    required this.id,
    required this.stockId,
    required this.machine,
    required this.shift,
    required this.dateTime,
    required this.stockCode,
    required this.stockCategory,
    required this.group,
    required this.stockClass,
    required this.weight,
    required this.qty,
    required this.baseUOM,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'] as String,
      stockId: json['stockId'] as String,
      machine: json['machine'] as String,
      shift: json['shift'] as String,
      dateTime: json['dateTime'] as String,
      stockCode: json['stockCode'] as String,
      stockCategory: json['stockCategory'] as String,
      group: json['group'] as String,
      stockClass: json['stockClass'] as String,
      weight: json['weight'] as int,
      qty: json['qty'] as int,
      baseUOM: json['baseUOM'] as String,
    );
  }
}