import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'table_database_helper.dart';
import 'stock_database_helper.dart';
import '../../helper/api.dart';
import '../../helper/file_manager.dart';
import '../../model/stock.dart';
import '../styles/theme.dart' as style;

class Utils {
  final stockDbHelper = StockDatabaseHelper.instance;

  final api = Api();

  static Future<int> insertTableRow(
      String stockId,
      String machine,
      String shift,
      String dateTime,
      String stockCode,
      String stockCategory,
      String group,
      String stockClass,
      int weight,
      int qty,
      String baseUOM,
    ) async {
    final tableDbHelper = TableDatabaseHelper.instance;
    // row to insert
    Map<String, dynamic> row = {
      TableDatabaseHelper.columnStockId : stockId,
      TableDatabaseHelper.columnMachine : machine,
      TableDatabaseHelper.columnShift : shift,
      TableDatabaseHelper.columnDateTime : dateTime,
      TableDatabaseHelper.columnStockCode : stockCode,
      TableDatabaseHelper.columnStockCategory : stockCategory,
      TableDatabaseHelper.columnGroup : group,
      TableDatabaseHelper.columnStockClass : stockClass,
      TableDatabaseHelper.columnWeight : weight,
      TableDatabaseHelper.columnQty : qty,
      TableDatabaseHelper.columnBaseUOM : baseUOM
    };
    
    final id = await tableDbHelper.insert(row);
    print('inserted row id: $id');
    return id;
  }

  static Future<int> updateTableRow(
      String stockId,
      String machine,
      String shift,
      String dateTime,
      String stockCode,
      String stockCategory,
      String group,
      String stockClass,
      int weight,
      int qty,
      String baseUOM,
  ) async {
    final tableDbHelper = TableDatabaseHelper.instance;
    // row to update
    Map<String, dynamic> row = {
      TableDatabaseHelper.columnStockId : stockId,
      TableDatabaseHelper.columnMachine : machine,
      TableDatabaseHelper.columnShift : shift,
      TableDatabaseHelper.columnDateTime : dateTime,
      TableDatabaseHelper.columnStockCode : stockCode,
      TableDatabaseHelper.columnStockCategory : stockCategory,
      TableDatabaseHelper.columnGroup : group,
      TableDatabaseHelper.columnStockClass : stockClass,
      TableDatabaseHelper.columnWeight : weight,
      TableDatabaseHelper.columnQty : qty,
      TableDatabaseHelper.columnBaseUOM : baseUOM
    };
    final rowsAffected = await tableDbHelper.update(row);
    print('updated $rowsAffected row(s)');
    return rowsAffected;
  }



  static Future<int> insertStock(String stockId, String stockCode, String stockName, String baseUOM, String remark1) async {
    final stockDbHelper = StockDatabaseHelper.instance;
    // row to insert
    Map<String, dynamic> row = {
      StockDatabaseHelper.columnStockId : stockId,
      StockDatabaseHelper.columnStockCode : stockCode,
      StockDatabaseHelper.columnStockName : stockName,
      StockDatabaseHelper.columnBaseUOM : baseUOM,
      StockDatabaseHelper.columnRemark1 : remark1
    };

    final id = await stockDbHelper.insert(row);
    print('inserted row id: $id');
    return id;
  }

  static Future<int> updateStock(String stockId, String stockCode, String stockName, String baseUOM, String remark1) async {
    final stockDbHelper = StockDatabaseHelper.instance;
    // row to update
    Map<String, dynamic> row = {
      StockDatabaseHelper.columnStockId : stockId,
      StockDatabaseHelper.columnStockCode  : stockCode,
      StockDatabaseHelper.columnStockName  : stockName,
      StockDatabaseHelper.columnBaseUOM  : baseUOM,
      StockDatabaseHelper.columnRemark1 : remark1
    };
    final rowsAffected = await stockDbHelper.update(row);
    print('updated $rowsAffected row(s)');
    return rowsAffected;
  }

  Future<List> fetchAndSaveStockData(String _dbCode, String _url) async {
    var data = await api.getStocks(_dbCode, _url);
    
    List<Stock> stockList =[];

    var receivedData = json.decode(data);
    stockList = receivedData.map<Stock>((json) => Stock.fromJson(json)).toList(); 

    int len = await FileManager.readString('stock_length');
    if(len == 0) {
      for(int i = 0; i < stockList.length; i++) {
        print('Saving Stock name: ${stockList[i].stockName}');
        insertStock(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM, 'Ok');
      }
      FileManager.saveString('stock_length', stockList.length.toString());
    } else {
      // update the db by response.body
      for(int i = 0; i < stockList.length; i++) {
        print('Updating Stocks: ${stockList[i].stockName}');
        updateStock(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM, 'Ok');
      }
    }
    
    return stockList;
  }

  static bool isOverlapped(int s1, int e1, int s2, int e2) {
    if((s2 > s1 && s2 < e1) || (e2 > s1 && e2 < e1)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isInRange(int start, int end, int currentTime) {
    if(currentTime > start && currentTime < end) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getShiftName() async {
    var _shiftList = await FileManager.readStringList('shift_list');

    DateTime currentTime = DateTime.now();
    var currentHHmm = (currentTime.hour * 60) + currentTime.minute;

    for (var shift in _shiftList) {
      var dayName = shift.split(',')[0];
      var startTime = shift.split(',')[1];
      var endTime = shift.split(',')[2];
      var startMin = int.parse(startTime.split(':')[0])*60 + int.parse(startTime.split(':')[1]);
      var endMin = int.parse(endTime.split(':')[0])*60 + int.parse(endTime.split(':')[1]);


      print('Start min: $startMin, End min: $endMin');

      if(startMin > endMin) {
        // Elapsed preset intervals
        print('Elapsed interval');

        if(Utils.isInRange(startMin, 1440, currentHHmm) || Utils.isInRange(0, endMin, currentHHmm)) {
          return dayName;
        }

      } else {
        if(Utils.isInRange(startMin, endMin, currentHHmm)) {
          return dayName;
        }
      }
    }
    return 'Not found';
  }

  static Future openDialogPanel(BuildContext context, String img, String title, String msg, String btnText) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              Image.asset("assets/icons/$img.png", width: 45.0),
              const SizedBox(height: 20.0),
              Text(title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: style.Colors.mainGrey)),
              const SizedBox(height: 20.0),
              Text('$msg.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent, )),
              const SizedBox(height: 30.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                },
              )
            ],
          ),
        );
      }
    );
  }

  static Future openDownloadingPanel(BuildContext context, String img, String title, String msg, String btnText) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              const CircularProgressIndicator(),
              const SizedBox(height: 20.0),
              Text(title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: style.Colors.mainGrey)),
              const SizedBox(height: 20.0),
              Text('$msg.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent, )),
              const SizedBox(height: 30.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                },
              )
            ],
          ),
        );
      }
    );
  } 

}