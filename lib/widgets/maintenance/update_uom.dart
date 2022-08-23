import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helper/utils.dart';
import '../../database/stock_db.dart';
import '../../helper/stock_api.dart';
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
  final api = StockApi();

  bool _isButtonClicked = false;
  String ip = '', port = '', dbCode = '';
  String urlStatus = 'not found';
  String url = '';

  Future<List> _fetchAndSaveStockData() async {
    await initProfileData();
    final now = DateTime.now();
    print('URL: 👉 $url');
    var data = await api.getStocks(dbCode, url).catchError((err) {
      print('🚨 : $err');
      setState(() {
        _isButtonClicked = false;
      });
      return '[]';
    });
    if(data.contains('Timed out! Wrong service address')) {
      Utils.openDialogPanel(context, 'close', 'Oops!', data, 'Try again');
      setState(() {
        _isButtonClicked = false;
      });
      return [];
    }
    var receivedData = json.decode(data);
    print('\n\n Len: ${receivedData.length} \n\n');
    var validList = [];
    for (int i = 0; i < receivedData.length; i++) {
      print('StockCode #${i + 1}: ${receivedData[i]['stockCode']}');

      if(receivedData[i]['remark1'] == null) {
        receivedData[i]['remark1'] = '1';
      }

      if(receivedData[i]['category'] == null) {
        receivedData[i]['category'] = 'c';
      }

      if(receivedData[i]['group'] == null) {
        receivedData[i]['group'] = 'g';
      }

      if(receivedData[i]['class'] == null) {
        receivedData[i]['class'] = 'c';
      }

      if(receivedData[i]['weight'] == null) {
        receivedData[i]['weight'] = 0.0;
      }

      if(receivedData[i]['isActive'] && receivedData[i]['baseUOM'] != null) {
        validList.add(receivedData[i]);
      }
    }

    stockList = validList.map<Stock>((json) => Stock.fromJson(json)).toList();

    print('Parsed!');

    // Clear the existing table to avoid repetition
    await StockDatabase.instance.readAllStocks().then((value) async {
      if(value.isEmpty) {
        for(int i = 0; i < stockList.length; i++) {
          await StockDatabase.instance.create(stockList[i]);
        }
      } else {
        await StockDatabase.instance.deleteAll().then((value) async {
          for(int i = 0; i < stockList.length; i++) {
            await StockDatabase.instance.create(stockList[i]);
          }
        });
      }
    });


    FileManager.saveInteger('stock_length', stockList.length);

    var last =  DateFormat.yMd().add_jm().format(now);
    // print('Last: $last');
    FileManager.saveString('last_update', last.toString());
    setState(() {
      stockCounter = stockList.length;
      lastUpdateTime = last.toString();
      _isButtonClicked = false;
    });
    print('Last update: $last');
    return stockList;
  }

  late Future? fetching = _fetchAndSaveStockData();

  Future initProfileData() async {
    ip =  await FileManager.readString('qne_ip_address');
    port =  await FileManager.readString('qne_port_number');
    dbCode =  await FileManager.readString('db_code');
    if(ip != '' && port != '' && dbCode != '') {
      url = 'http://$ip:$port/api/Stocks';
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
                            _isButtonClicked = true;
                          });
                          _fetchAndSaveStockData();
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
                _isButtonClicked ? 
                const Center(
                  child: CircularProgressIndicator(),
                ) : Text(
                  '${stockCounter.toString()} Stocks',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: style.Colors.button2,
                  ),
                ),
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