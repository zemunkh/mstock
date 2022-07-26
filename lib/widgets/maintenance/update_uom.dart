import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/stock_db.dart';
import '../../helper/api.dart';
import '../../model/stock.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;

class UpdateUOM extends StatefulWidget {
  const UpdateUOM({ Key? key }) : super(key: key);

  @override
  State<UpdateUOM> createState() => _UpdateUOMState();
}

class _UpdateUOMState extends State<UpdateUOM> {
  String lastUpdateTime = '';
  DateFormat lastUpdateFormat = DateFormat.yMd().add_jm();

  List<Stock> stockList =[];
  int stockCounter = 0;
  final api = Api();

  bool _isButtonClicked = false;
  String ip = '', port = '', dbCode = '';
  String urlStatus = 'not found';
  String url = '';

  Future<List> _fetchAndSaveStockData() async {
    final now = DateTime.now();
    var data = await api.getStocks(dbCode, url);

    var receivedData = json.decode(data);
    print('\n\n Len: ${receivedData.length} \n\n');
    var validList = [];
    for (int i = 0; i < receivedData.length; i++) {
      print('Item remark1 #${i + 1}: ${receivedData[i]['remark1']}');
      // receivedData[i]['_id'] = i;
      if(receivedData[i]['baseUOM'] == null) {
        receivedData[i]['baseUOM'] = 'UNIT';
      }
      if(receivedData[i]['description'] == null) {
        receivedData[i]['description'] = 'Empty';
      }
      if(receivedData[i]['remark1'] == null) {
        receivedData[i]['remark1'] = 4;
      }

      if(receivedData[i]['isActive'] != null) {
        if(receivedData[i]['isActive']) {
          validList.add(receivedData[i]);
        }
      }
    }

    stockList = validList.map<Stock>((json) => Stock.fromJson(json)).toList(); 

    print('Parsed!');

    // Clear the existing table to avoid repetition

    await StockDatabase.instance.deleteAll().then((value) async {
      print('Delete result: $value');

      for(int i = 0; i < stockList.length; i++) {
        print('Saving Stock name: ${stockList[i].stockName}');
        await StockDatabase.instance.create(stockList[i]);
      }
    });

    FileManager.saveInteger('stock_length', stockList.length);

    var last =  DateFormat.yMd().add_jm().format(now);
    // print('Last: $last');
    FileManager.saveString('last_update', last.toString());
    setState(() {
      stockCounter = stockList.length;
      lastUpdateTime = last.toString(); 
    });
    print('Last update: $last');
    return stockList;
  }

late final Future? fetching = _fetchAndSaveStockData();

  Future initProfileData() async {
    ip =  await FileManager.readString('ip_address');
    port =  await FileManager.readString('port_number');
    dbCode =  await FileManager.readString('company_name');
    if(ip != '' && port != '' && dbCode != '') {
      // url = 'http://$ip:$port/api/Stocks';
      url = 'https://dev-api.qne.cloud/api/Stocks?%24skip=0&%24top=25';
      dbCode = 'fazsample';
    } else {
      url = 'https://dev-api.qne.cloud/api/Stocks?%24skip=0&%24top=25';
      dbCode = 'fazsample';
    }
    setState((){
      urlStatus = url;
    });
  }

  Future initSettings() async {
    lastUpdateTime = await FileManager.readString('last_update');
    stockCounter = await FileManager.readInteger('stock_length');
    setState(() {});
  }

  @override
  void initState() {
    initSettings();
    initProfileData();
    super.initState();
  }

  @override
  void dispose() {
    StockDatabase.instance.close();

    super.dispose();
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
                            _isButtonClicked = !_isButtonClicked;
                          });
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
                FutureBuilder(
                  future: _isButtonClicked ? fetching : null,
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                          '$stockCounter.toString() Stocks',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            color: style.Colors.button2,
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                        if(snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return const Text('Error during fetching data!');
                        }
                        return Text(
                          stockCounter.toString(),
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
                  flex: 5,
                  child: Text(
                    'Last Update:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: style.Colors.mainGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(lastUpdateTime == '' ? 'Not yet updated!' : lastUpdateTime,
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