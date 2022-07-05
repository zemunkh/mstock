import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
  String lastUpdateTime = '16/06/2022 06:04 PM';

  List<Stock> stockList =[];
  String counter = '0';

  bool _isButtonClicked = false;
  String ip = '', port = '', dbCode = '';
  String urlStatus = 'not found';
  String url = '';


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
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: style.Colors.mainGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 1. Open Dialog to show the progress indicator of downloading
                          // 2. 
                          Utils.openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
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
                Expanded(
                  flex: 2,
                  child: Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: style.Colors.button4,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(''),
                ),
                const Expanded(
                  flex: 2,
                  child: Text('Last Update: '),
                ),
                Expanded(
                  flex: 5,
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