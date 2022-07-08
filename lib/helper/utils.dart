import 'dart:async';
import 'dart:convert';
import '../../helper/api.dart';
import '../../helper/database_helper.dart';
import '../../helper/file_manager.dart';
import '../../model/stock.dart';
import 'package:flutter/material.dart';
import '../styles/theme.dart' as style;

class Utils {
  final dbHelper = DatabaseHelper.instance;
  final api = Api();

  void _insert(String stockId, String stockCode, String stockName, String baseUOM) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnStockId : stockId,
      DatabaseHelper.columnStockCode  : stockCode,
      DatabaseHelper.columnStockName  : stockName,
      DatabaseHelper.columnBaseUOM  : baseUOM
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _update(String stockId, String stockCode, String stockName, String baseUOM) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnStockId : stockId,
      DatabaseHelper.columnStockCode  : stockCode,
      DatabaseHelper.columnStockName  : stockName,
      DatabaseHelper.columnBaseUOM  : baseUOM
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
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
        _insert(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM);
      }
      FileManager.saveString('stock_length', stockList.length.toString());
    } else {
      // update the db by response.body
      for(int i = 0; i < stockList.length; i++) {
        print('Updating Stocks: ${stockList[i].stockName}');
        _update(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM);
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