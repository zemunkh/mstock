import './uoms.dart';

class Stock1Fields {
  static final List<String> values = [
    /// Add all fields
    stockId, stockCode, stockName, baseUOM, remark1, isActive
  ];

  static const String stockId = 'id';
  static const String stockCode = 'stockCode';
  static const String stockName = 'stockName';
  static const String baseUOM = 'baseUOM';
  static const String remark1 = 'remark1';
  static const String isActive = 'isActive';
  static const String uoMs = 'uoMs';
}


class Stock1 {
  final String stockId;
  final String stockCode;
  final String stockName;
  final String baseUOM;
  final bool isActive;
  final Uoms uoMs;

  Stock1({
    required this.stockId,
    required this.stockCode,
    required this.stockName,
    required this.baseUOM,
    required this.isActive,
    required this.uoMs
  });

  factory Stock1.fromJson(Map<String, dynamic> json) {
    return Stock1(
      stockId: json[Stock1Fields.stockId] as String,
      stockCode: json[Stock1Fields.stockCode] as String,
      stockName: json[Stock1Fields.stockName] as String,
      baseUOM: json[Stock1Fields.baseUOM] as String,
      isActive: json[Stock1Fields.isActive] as bool,
      uoMs: Uoms.fromJson(json[Stock1Fields.uoMs])
    );
  }
}