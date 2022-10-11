import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'stock_api.dart';
import '../../helper/file_manager.dart';
import '../../model/stock.dart';
import '../styles/theme.dart' as style;

class Utils {

  final stockApi = StockApi();


  Future<List> fetchAndSaveStockData(String _dbCode, String _url) async {
    var data = await stockApi.getStocks(_dbCode, _url);
    
    List<Stock> stockList =[];

    var receivedData = json.decode(data);
    stockList = receivedData.map<Stock>((json) => Stock.fromJson(json)).toList(); 

    int len = await FileManager.readString('stock_length');
    if(len == 0) {
      for(int i = 0; i < stockList.length; i++) {
        print('Saving Stock name: ${stockList[i].stockName}');
        // insertStock(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM, 'Ok');
      }
      FileManager.saveString('stock_length', stockList.length.toString());
    } else {
      // update the db by response.body
      for(int i = 0; i < stockList.length; i++) {
        print('Updating Stocks: ${stockList[i].stockName}');
        // updateStock(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM, 'Ok');
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
    if(currentTime >= start && currentTime < end) {
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


  static Future<DateTime> getShiftConvertedTime(DateTime _date) async {
    var _shiftList = await FileManager.readStringList('shift_list');
    var _dateHHmm = (_date.hour * 60) + _date.minute;

    for (var shift in _shiftList) {
      // var dayName = shift.split(',')[0];
      var startTime = shift.split(',')[1];
      var endTime = shift.split(',')[2];
      var startMin = int.parse(startTime.split(':')[0])*60 + int.parse(startTime.split(':')[1]);
      var endMin = int.parse(endTime.split(':')[0])*60 + int.parse(endTime.split(':')[1]);

      if(startMin > endMin && _dateHHmm >= 0) {
        // Elapsed preset intervals
        print('⭐️ Elapsed interval');
        if(Utils.isInRange(startMin, 1440, _dateHHmm) || Utils.isInRange(0, endMin, _dateHHmm)) {
          // Convert currentDay to 1 day before
          DateTime date = DateTime(
            _date.year,
            _date.month,
            _date.day - 1, 
            23,
            59,
          );
          print('Day before 👉 : $date');
          return date;
        }
      }
    }
    return _date;
  }


  static Widget _scannerInput(BuildContext context, String hintext, TextEditingController _controller,
      FocusNode currentNode, double currentWidth, GlobalKey _formKey, bool isObscure) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 40,
        width: currentWidth,
        child: TextFormField(
          key: _formKey,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF004B83),
            fontWeight: FontWeight.bold,
          ),
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintext,
            hintStyle: const TextStyle(
              color: Color(0xFF004B83),
              fontWeight: FontWeight.w200,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            errorStyle: const TextStyle(
              color: Colors.yellowAccent,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.qr_code,
                color: Colors.blueAccent,
                size: 24,
              ),
              onPressed: () {
                _controller.clear();
                FocusScope.of(context).requestFocus(currentNode);
              },
            ),
          ),
          autofocus: false,
          autocorrect: false,
          controller: _controller,
          focusNode: currentNode,
          onTap: () {
            // _clearTextController(context, _mainController, _mainNode);
          },
        ),
      ),
    );
  }

  static Future openPasswordPanel(BuildContext context, String password, TextEditingController passwordController, FocusNode _node, GlobalKey _formKey, String img, String title, String btnText, Function matchedCallback, Function unMatchedCallback, Function closedCallback) {
    final _alertKey = GlobalKey<FormFieldState>();
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          key: _alertKey,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              Image.asset("assets/icons/$img.png", width: 45.0),
              const SizedBox(height: 20.0),
              _scannerInput(
                context,
                'Admin Password',
                passwordController,
                _node,
                double.infinity,
                _formKey,
                true
              ),
              const SizedBox(height: 20.0),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent,)),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: style.Colors.mainAccent)),
                    onPressed: (){
                      passwordController.text = '';
                      // Timer(const Duration(milliseconds: 500), () => Navigator.of(context, rootNavigator: true).pop());
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainRed),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))
                    ),
                    child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                    onPressed: (){
                      // Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                      if(password == passwordController.text.trim()) {
                        print('\n\n Matched!!! \n\n');
                        matchedCallback();
                        // Timer(const Duration(milliseconds: 500), () {
                        //   Navigator.of(context, rootNavigator: true).pop();
                        //   passwordController.text = '';
                        // });
                        passwordController.text = '';
                      } else {
                        unMatchedCallback();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        );
      }
    ).then((_) {
      print('\n\n Called the close event');
      closedCallback();
    });
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
                  backgroundColor: MaterialStateProperty.all<Color>(btnText.contains('Try') ? style.Colors.mainRed : style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  // Timer(const Duration(milliseconds: 500), () => Navigator.of(context, rootNavigator: true).pop());
                  Navigator.of(context, rootNavigator: true).pop();
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
                  // Timer(const Duration(milliseconds: 500), () => Navigator.of(context, rootNavigator: true).pop());
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          ),
        );
      }
    );
  } 

}