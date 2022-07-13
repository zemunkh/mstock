import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helper/database_helper.dart';
import '../../helper/api.dart';
import '../../model/stock.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;

class UpdateUOM extends StatefulWidget {
  const UpdateUOM({ Key? key }) : super(key: key);

  @override
  State<UpdateUOM> createState() => _UpdateUOMState();
}

class _UpdateUOMState extends State<UpdateUOM> {
  String statusText = 'Completed!';
  String lastUpdateTime = '';
  DateFormat lastUpdateFormat = DateFormat.yMd().add_jm();

  List<Stock> stockList =[];
  String counter = '0';
  final dbHelper = DatabaseHelper.instance;
  final api = Api();

  bool _isButtonClicked = false;
  String ip = '', port = '', dbCode = '';
  String urlStatus = 'not found';
  String url = '';

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


  Future<List> _fetchAndSaveStockData() async {
    final now = DateTime.now();
    var data = await api.getStocks(dbCode, url);

    var receivedData = json.decode(data);
    stockList = receivedData.map<Stock>((json) => Stock.fromJson(json)).toList(); 

    int len = await FileManager.readInteger('stock_length');
    if(len == 0) {
      for(int i = 0; i < stockList.length; i++) {
        print('Saving Stock name: ${stockList[i].stockName}');
        _insert(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM);
      }
      FileManager.saveInteger('stock_length', stockList.length);
    } else {
      // update the db by response.body
      for(int i = 0; i < stockList.length; i++) {
        print('Updating Stocks: ${stockList[i].stockName}');
        _update(stockList[i].id, stockList[i].stockCode, stockList[i].stockName, stockList[i].baseUOM);
      }
    }
    var last =  DateFormat.yMd(now).add_jm();
    FileManager.saveString('last_update', last.toString());
    setState(() {
      lastUpdateTime = last.toString(); 
    });
    print('Last update: ${DateFormat.yMd(now).add_jm().toString()}');
    return stockList;
  }

  Future<List> _fetchExistingStock() async {
    List<Map> stockData = await dbHelper.queryAllRows();
    print('query all rows: ${stockData.length}');
    FileManager.saveInteger('stock_length', stockData.length);
    return stockData;
  }

  Future<Null> initProfileData() async {
    ip =  await FileManager.readString('ip_address');
    port =  await FileManager.readString('port_number');
    dbCode =  await FileManager.readString('company_name');
    if(ip != '' && port != '' && dbCode != '') {
      url = 'http://$ip:$port/api/Stocks';
    } else {
      url = 'https://dev-api.qne.cloud/api/Stocks';
      dbCode = 'OUCOP7';
    }
    setState((){
      urlStatus = url;
    });
  }

  Future initSettings() async {
    await FileManager.readString('last_update').then((value) => {
      lastUpdateTime = value != '' ? value : lastUpdateTime
    });
    print('Last update is fetched');
    setState(() {});
  }

  @override
  void initState() {
    initSettings();
    initProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget buildUpdateField(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    'Import StockCode & UOM:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: style.Colors.mainGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isButtonClicked == false ? _isButtonClicked = true : _isButtonClicked = false;
                          });
                          // Utils.openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
                        },
                        child: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          primary: style.Colors.button4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List>(
                  future: _isButtonClicked ? _fetchAndSaveStockData() : _fetchExistingStock(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                          statusText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: style.Colors.button4,
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                        if(snapshot.hasError) {
                          return const Text('Error during fetching data!');
                        }
                        return Text(
                          '${snapshot.data!.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            color: style.Colors.button2,
                          ),
                        );
                    }
                  }
                )
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(''),
                ),
                const Expanded(
                  flex: 3,
                  child: Text('Last Update: ', textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 3,
                  child: Text(lastUpdateTime,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: style.Colors.button4,
                    ),
                  ),
                ), 
              ],
            )
          ],
        ),
      );
    }
    return buildUpdateField(context);
  }
}