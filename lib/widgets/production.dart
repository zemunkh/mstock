import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../model/uoms.dart';
import '../model/stock.dart';
import '../model/counter.dart';
import '../../database/stock_db.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../helper/counter_api.dart';
import '../../helper/stock_api.dart';
import '../styles/theme.dart' as style;

class Production extends StatefulWidget {
  const Production({Key? key}) : super(key: key);

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> with SingleTickerProviderStateMixin{
  final _machineLineController = TextEditingController();
  final _masterController = TextEditingController();
  final _stickerController = TextEditingController();
  final _stickerDeleteController = TextEditingController();
  final _passwordController = TextEditingController();


  final FocusNode _masterNode = FocusNode();
  final FocusNode _machineLineNode = FocusNode();
  final FocusNode _stickerNode = FocusNode();
  final FocusNode _stickerDeleteNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  static final _machineLineFormKey = GlobalKey<FormFieldState>();
  static final _masterFormKey = GlobalKey<FormFieldState>();
  static final _stickerFormKey = GlobalKey<FormFieldState>();
  static final _stickerDeleteFormKey = GlobalKey<FormFieldState>();
  static final _passwordFormKey = GlobalKey<FormFieldState>();


  List<Counter> _counterList = [];
  bool _isLoading = false;
  bool isSaveDisabled = true;
  bool _isMatched = false;
  bool _isCheckerLoading = false;
  String _shiftValue = '';
  String _supervisorPassword = '';
  String _deviceName = '';
  String _url = '';
  String _qneUrl = '';
  String _dbCode = '';
  String _scanDelay = '15';
  List<bool> activeList = [
    false,
    false,
    false,
    false,
  ];
  var level = 0;
  // activeList = level.toRadixString(2);
  // activeList[0]

  bool isAddView = true;
  Stock _masterStock = Stock(
    id: 0,
    stockId: '',
    stockCode: '',
    stockName: '',
    baseUOM: '',
    weight: 0.0,
    purchasePrice: 0.0,
    remark1: '',
    category: '',
    group: '',
    stockClass: '',
  );
  List<String> _machineList = [];

  Future _clearTextController(BuildContext context,
      TextEditingController _controller, FocusNode node) async {
    setState(() {
      _controller.clear();
    });
    FocusScope.of(context).requestFocus(node);
  }

  String buffer = '';
  String trueVal = '';

  Future masterListener() async {
    buffer = _masterController.text;
    if (buffer.isEmpty) {
      setState(() {
        isSaveDisabled = true;
        activeList = [false, false, false, false];
      });
    }
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _masterNode.unfocus();

      await StockDatabase.instance.readStockByCode(trueVal).then((val) async {
        print('Found stock w 👉: ${val.weight}');
        // Add stock data to Counter table
        // 1. Search the stock in the existing table

        await Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _masterStock = val;
            _masterController.text = trueVal;
            _stickerController.text = '';
            level = 0;
            activeList = [false, false,  false, false];
          });
          FocusScope.of(context).requestFocus(_stickerNode);
        });

      }).catchError((err) {
        print('Error: $err');

        Utils.openDialogPanel(context, 'close', 'Oops!', 'No such Stock is available!', 'Try again');

        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _masterController.text = '';
          });
        });
      });
    }
  }

  Future stickerListener() async {
    buffer = _stickerController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      // Check the status of __isAddView__
      
      if(trueVal == _masterController.text) {
        if(_masterStock.remark1 != '4') {
          isSaveDisabled = false;
          level = 4;
        } else {
          level++;
        }

        if (level <= 4) {
          switch (level) {
            case 0:
              activeList = [false, false, false, false];
              break;
            case 1:
              activeList = [true, false, false, false];
              break;
            case 2:
              activeList = [true, true, false, false];
              break;
            case 3:
              activeList = [true, true, true, false];
              break;
            case 4:
              isSaveDisabled = false;
              activeList = [true, true, true, true];
              break;
            default:
              activeList = [false, false, false, false];
          }
        } else {
          isSaveDisabled = false;
          activeList = [true, true, true, true];
          // Utils.openDialogPanel(context, 'close', 'Oops!', 'Already filled!', 'Try again');
        }
      } else {
        Utils.openDialogPanel(context, 'close', 'Oops!', '$trueVal is not matched!', 'Try again');
      }

      setState(() {});

      // if True, add stock item to the list

      // else, remove stock item/decrease by the count 

      Future.delayed(const Duration(milliseconds: 800), () {
        _stickerController.text = '';
      }).then((value) {
        // _stickerNode.unfocus();
        // FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  Future deleteListener() async {
    buffer = _stickerDeleteController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;


      await Future.delayed(const Duration(milliseconds: 1000), () {
        _stickerDeleteController.text = trueVal;
      }).then((value) {
        _stickerDeleteNode.unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }


  Future machineLineListener() async {
    buffer = _machineLineController.text;
    bool isFound = false;
    print('Machine text: ${_machineLineController.text}');
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _machineLineNode.unfocus();
      setState(() {
        _isMatched = false;
      });
      // Load list of Machine Lines from Maintenance
      for (var el in _machineList) {
        if(trueVal == el) {
          isFound = true;
        }
      }

      if (isFound) {
        await CounterApi.readCountersWithMachine(_url, trueVal).then((res) async {
          List<Counter> _parsedList = [];
          for (var el in res) {
            if(el.qty > 0) {
              _parsedList.add(el);
            }
          }
          _counterList = _parsedList;
          _isMatched = true;
          setState(() {});
        }).catchError((err) {
          print('Err: $err');
          Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
        });
      } else {
        Utils.openDialogPanel(context, 'close', 'Oops!', 'No found!', 'Try again');
        setState(() {
          _isMatched = false;
        });
      }
      
      await Future.delayed(const Duration(milliseconds: 200), () {
        _machineLineController.text = trueVal;
      }).then((value) async {
        // FocusScope.of(context).requestFocus(FocusNode());
        if(isFound) {
          await Future.delayed(const Duration(milliseconds: 200), () {
            _machineLineController.text = trueVal;
          }).then((value) {
            FocusScope.of(context).requestFocus(_masterNode);
          });
        }
      });
    }
    if(buffer.isEmpty) {
      setState(() {
        _isMatched = false;
        _masterController.text = '';
        _counterList = [];
      });
    }
  }

  _createNewCounter(DateTime currentTime) async {
    var _shiftConvertedDate = await Utils.getShiftConvertedTime(currentTime);
    // print('ID: ${_masterStock.stockId}');
    await StockApi.readFullStock(_dbCode, _masterStock.stockId, _qneUrl).then((res) async {
      print('Res: ✅  rate = ${res.uoMs[0]!.rate}');
      
      List<Uom> activeUoms = [];
      for (var u in res.uoMs) {
        if(u!.isActive) {
          // print('unit 👉 : ${u.uomCode} : ${u.rate}');
          activeUoms.add(u);
        }
      }
      activeUoms.sort((a, b) => a.rate.compareTo(b.rate));
      Uom bigger = activeUoms.last;
      // print('UOM: ✅  ${bigger.isActive} : ${bigger.uomCode} : ${bigger.rate}');

      Counter newCounter =  Counter(
        stockId: _masterStock.stockId,
        stockCode: _masterStock.stockCode,
        stockName: _masterStock.stockName,
        machine: _machineLineController.text.trim(),
        device: _deviceName,
        shift: _shiftValue,
        shiftDate: _shiftConvertedDate,
        createdTime: currentTime,
        updatedTime: currentTime,
        qty: 1,
        totalQty: bigger.rate.round(),
        // totalQty: 1,
        purchasePrice: _masterStock.purchasePrice,
        uom: bigger.uomCode,
        stockCategory: _masterStock.category,
        group: _masterStock.group,
        stockClass: _masterStock.stockClass,
        weight: _masterStock.weight
      );
    // 4. save it to the db.
      final result = await CounterApi.create(newCounter.toJson(), _url); 
      
      result.when((err) {
        print('Err -> 3: $err');
        Utils.openDialogPanel(context, 'close', 'Oops!', '3# $err', 'Understand');
        setState(() {
          _isLoading = false;
        });
      }, (newCounterRes) {
        if(newCounterRes.stockId == newCounter.stockId) {
          _counterList.add(newCounterRes);
          level = 0;
          activeList = [false, false,  false, false];
          isSaveDisabled = true;
          _masterController.text = '';
          _stickerController.text = '';
          _isLoading = false;
          FocusScope.of(context).requestFocus(_masterNode);
        }  else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:  Text("🚨 Not successful!", textAlign: TextAlign.center,),
            duration: Duration(milliseconds: 3000)
          ));
        }
        setState(() {
          _isLoading = false;
        });                            
      });

    }).catchError((err) {
      Utils.openDialogPanel(context, 'close', 'Oops!', '4# $err', 'Understand');
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _reloadTable(String _machineLine) async {
    await CounterApi.readCountersWithMachine(_url, _machineLine).then((res) async {
      List<Counter> _parsedList = [];
      for (var el in res) {
        if(el.qty > 0) {
          _parsedList.add(el);
        }
      }
      setState(() {
        _counterList = _parsedList;
      });
    }).catchError((err) {
      print('Err: $err');
    });
  }

  Future initSettings() async {
    _scanDelay = await FileManager.readString('scan_delay');
    _machineList = await FileManager.readStringList('machine_line');
    _supervisorPassword = await FileManager.readString('supervisor_password');
    _deviceName = await FileManager.readString('device_name');
    final ip =  await FileManager.readString('counter_ip_address');
    final port =  await FileManager.readString('counter_port_number');
    if(ip != '' && port != '') {
      _url = 'http://$ip:$port';
    } else {
      _url = 'http://localhost:8080';
    }

    final qneIp =  await FileManager.readString('qne_ip_address');
    final qnePort =  await FileManager.readString('qne_port_number');
    _dbCode = await FileManager.readString('db_code');
    if(qneIp != '' && qnePort != '' && _dbCode != '') {
      _qneUrl = 'http://$qneIp:$qnePort/api/Stocks';
    } else {
      _qneUrl = 'https://dev-api.qne.cloud/api/Stocks';
      _dbCode = 'fazsample';
    }

    _shiftValue = await Utils.getShiftName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
    _masterController.addListener(masterListener);
    _stickerController.addListener(stickerListener);
    _stickerDeleteController.addListener(deleteListener);
    _machineLineController.addListener(machineLineListener);
  }

  @override
  void dispose() {
    _masterController.dispose();
    _stickerController.dispose();
    _stickerDeleteController.dispose();
    _machineLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _scanControl(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(!isAddView) {
                      _stickerDeleteController.text = '';
                    }
                    setState(() {
                      isAddView = true;
                      level = 0;
                      activeList = [false, false,  false, false];
                    });
                  },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: isAddView
                        ? style.Colors.button4
                        : style.Colors.mainDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    if(isAddView) {
                      _stickerController.text = '';
                      _masterController.text = '';
                    }
                    setState(() {
                      isAddView = false;
                    });
                  },
                  child: const Text('Del.'),
                  style: ElevatedButton.styleFrom(
                    primary: isAddView
                        ? style.Colors.mainDarkGrey
                        : style.Colors.button2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _scannerInput(String hintext, TextEditingController _controller,
        FocusNode currentNode, double currentWidth, GlobalKey _formKey) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 40,
          width: currentWidth,
          child: TextFormField(
            key: _formKey,
            enabled: hintext.contains('Master') ? _isMatched : hintext.contains('Sticker') ? _isMatched : true,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF004B83),
              fontWeight: FontWeight.bold,
            ),
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
                  _clearTextController(context, _controller, currentNode);
                  if(!(hintext.contains('Master') || hintext.contains('Sticker'))) {
                    setState(() {
                      _isMatched = false;
                    });
                  }
                },
              ),
            ),
            autofocus: false,
            autocorrect: false,
            controller: _controller,
            focusNode: currentNode,
            onTap: () {
              _clearTextController(context, _controller, currentNode);
            },
          ),
        ),
      );
    }

    Widget buildContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(right: 2, left: 2, top: 5, bottom: 5),
        padding: const EdgeInsets.only(right: 2, left: 2, top: 5, bottom: 5),
        height: 480,
        width: 440,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: child,
        ),
      );
    }

    Widget _productionTable(BuildContext context) {
      return buildContainer(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
          columnSpacing: 12,
          showCheckboxColumn: false,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Stocks:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Qty:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'UOMs:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Date:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            DataColumn(
              label: Text(
                'Shift:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: style.Colors.mainGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          rows: _counterList.map((row) => DataRow(
            cells: [
              DataCell(
                Text(
                  row.stockCode,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                ),
              ),
              DataCell(Text(row.qty.toString())),
              DataCell(
                Text(
                  row.uom,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                ),
              ),
              DataCell(
                Text(
                  DateFormat('dd/MM/yyyy').format(row.shiftDate),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                )
              ),
              DataCell(
                Text(
                  row.shift,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                )
              ),
            ]
          )).toList(),
          
          ),
        )
      );
    }

    Widget _machineLine(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '⚙️ Machine Line: ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: style.Colors.mainGrey,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: _scannerInput(
                  'A1...',
                  _machineLineController,
                  _machineLineNode,
                  120,
                  _machineLineFormKey
                ),
              ),
              Expanded(
                flex: 4,
                child: _scanControl(context),
              ),
            ],
          )
        ],
      );
    }

    Widget levelBar(Color mainColor) {
      return Container(
        width: 24,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: mainColor,
        ),
      );
    }

    Widget _connectionChecker(BuildContext context) {
      return ElevatedButton(
        onPressed: () async {
          setState(() {
            _isCheckerLoading = true;
          });
          String _code = Random().nextInt(999999).toString().padLeft(6, '0');
          await CounterApi.connectionChecker(_code, _url).then((res) {
            if(res == _code) {
              setState(() {
                _isCheckerLoading = false;
              });
              Utils.openDialogPanel(context, 'accept', 'Done!', 'Connection is ok!', 'Okay');
            } else {
              Utils.openDialogPanel(context, 'close', 'Oops!', 'Connection is not okay', 'Understand');
              setState(() {
                _isCheckerLoading = false;
              });
            }
          }).catchError((err) {
            Utils.openDialogPanel(context, 'close', 'Oops!', 'Test is failed. Error: $err', 'Understand');
            setState(() {
              _isCheckerLoading = false;
            });
          });
          _reloadTable(_machineLineController.text);
        },
        child: _isCheckerLoading ? Transform.scale(
            scale: 0.6,
            child: const CircularProgressIndicator(
              strokeWidth: 8.0,
              valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
            ),
          ) : const Icon(
          Icons.replay,
          size: 24,
          color: style.Colors.mainGrey,
        ),
        style: ElevatedButton.styleFrom(
          primary: style.Colors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    Widget _addView(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '⚙️ Master: ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: style.Colors.mainGrey,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _scannerInput(
                  'Master key',
                  _masterController,
                  _masterNode,
                  double.infinity,
                  _masterFormKey,
                ),
              ),
            ],
          ),
          const Text(
            '🏷 Sticker: ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: style.Colors.mainGrey,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _scannerInput(
                  'Sticker key',
                  _stickerController,
                  _stickerNode,
                  double.infinity,
                  _stickerFormKey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 40,
                  width: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: _masterStock.remark1 == '4' ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          levelBar(activeList[0] ? Colors.green : Colors.grey),
                          levelBar(activeList[1] ? Colors.green : Colors.grey),
                          levelBar(activeList[2] ? Colors.green : Colors.grey),
                          levelBar(activeList[3] ? Colors.green : Colors.grey),
                        ],
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          levelBar(!isSaveDisabled ? Colors.green : Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(''),
              ),
              Expanded(
                flex: 2,
                child: _connectionChecker(context)
              ),
              const Expanded(
                flex: 1,
                child: Text(''),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isSaveDisabled == true) { return; }
                    if (_isLoading == true) { return; }
                    _shiftValue = await Utils.getShiftName();
                    setState(() {
                      _isLoading = true;
                    });
                    // print('Clicked the Save: $_url');
                    var currentTime = DateTime.now();
                    print('🚨 CurrentTime: $currentTime 🚨');
                    print('🟢🚨 Shift: $_shiftValue 🚨🟢');
                  
                    final result = await CounterApi.readCounterByCodeAndMachine(_masterController.text.trim(), _machineLineController.text.trim(), _url);
                    
                    result.when((err) async {
                      print('\n $err \n\n');
                      if('$err'.contains('404')) {

                        _createNewCounter(currentTime);

                      } else {
                        Utils.openDialogPanel(context, 'close', 'Oops!', '#2 $err', 'Understand');
                      }

                    }, (c) async {
                      print('Counter: ${c.id} : ${c.stockId} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');
                      // Check scan_delay is out of range with (createdTime & updatedTime)
                      var diff = currentTime.difference(c.updatedTime).inMinutes;
                      
                      if(_scanDelay.isNotEmpty) {
                        if(diff < int.parse(_scanDelay)) {
                          Utils.openDialogPanel(context, 'close', 'Oops!', 'You can enter the stock after $_scanDelay min later', 'Understand');
                          return;
                        }
                      }

                      if(c.qty <= 0) {
                        _createNewCounter(currentTime);
                      } else {

                        var shiftDiff = currentTime.difference(c.shiftDate);
                        print('\n Product: ${c.stockCode} : diff=${shiftDiff.inDays} By Hours: ${shiftDiff.inHours} \n');
    
                        DateTime shiftConvertedTime = await Utils.getShiftConvertedTime(currentTime);
                        print('👉 ShiftConvertedTime: $shiftConvertedTime : Counter Shift Date=${c.shiftDate}  \n');

                        if (shiftConvertedTime.day == c.shiftDate.day && shiftDiff.inDays == 0 && c.shift.contains(_shiftValue)) {
                          // Update or create new Counter card
                          // print('👉 Thought the same \n');

                          Counter updatedCounter = Counter(
                            id: c.id,
                            stockId: c.stockId,
                            stockCode: c.stockCode,
                            stockName: c.stockName, 
                            machine: _machineLineController.text.trim(),
                            device: _deviceName,
                            shift: _shiftValue,
                            shiftDate: c.shiftDate,
                            createdTime: c.createdTime,
                            updatedTime: DateTime.now(),
                            qty: c.qty + 1,
                            totalQty: ((c.totalQty / c.qty) * (c.qty + 1)).round(),
                            // totalQty: 1,
                            purchasePrice: c.purchasePrice,
                            uom: c.uom,
                            stockCategory: c.stockCategory,
                            group: c.group,
                            stockClass: c.stockClass,
                            weight: c.weight
                          );

                          await CounterApi.addCounter(
                              c.id.toString(),
                              updatedCounter.updatedTime.toIso8601String(),
                              (c.qty + 1).toString(), 
                              ((c.totalQty / c.qty) * (c.qty + 1)).round().toString(),
                              _url,
                              'Prod-Add',
                              _deviceName
                            )
                          .then((res) {
                            setState(() {
                              _counterList[_counterList.indexWhere((item) => item.id == updatedCounter.id)] = updatedCounter;
                              level = 0;
                              activeList = [false, false,  false, false];
                              isSaveDisabled = true;
                              _stickerController.text = '';
                              _masterController.text = '';
                              _isLoading = false;
                            });
                            _reloadTable(_machineLineController.text);
                            FocusScope.of(context).requestFocus(_masterNode);
                          }).catchError((err) {
                            Utils.openDialogPanel(context, 'close', 'Oops!', '#2 $err', 'Understand');
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        } else {
                          _createNewCounter(currentTime);
                        }
                      }
                    });
                  },
                  child: _isLoading ? Transform.scale(
                      scale: 0.6,
                      child: const CircularProgressIndicator(
                        strokeWidth: 8.0,
                        valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
                      ),
                    ) :  const Text(
                    'Add',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: isSaveDisabled ? style.Colors.mainDarkGrey : style.Colors.button4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Text(_masterStock.stockId),
          // Text(_qneUrl),
          // Text(_dbCode),
          // Text('Full url: $_qneUrl/${_masterStock.stockId}'),
        ],
      );
    }

    Widget _deleteView(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          const Text(
            '🏷 Sticker: ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: style.Colors.mainGrey,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _scannerInput(
                  'Sticker key',
                  _stickerDeleteController,
                  _stickerDeleteNode,
                  double.infinity,
                  _stickerDeleteFormKey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(''),
              ),
              Expanded(
                flex: 3,
                child: _connectionChecker(context)
              ),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () async {

                    await CounterApi.readCountersWithMachine(_url, _machineLineController.text).then((res) async {
                      List<Counter> _parsedList = [];
                      for (var el in res) {
                        if(el.qty > 0) {
                          _parsedList.add(el);
                        }
                      }
                      if(_parsedList.isEmpty) {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'There is no items to delete!', 'Understand');
                        setState(() {
                          _counterList = [];
                        });
                        return;
                      } else {
                        setState(() {
                          _counterList = _parsedList;
                        });
                        Utils.openPasswordPanel(
                          context,
                          _supervisorPassword,
                          _passwordController,
                          _passwordNode,
                          _passwordFormKey,
                          'padlock',
                          'Do you want to delete the counter?',
                          'Confirm',
                          () async {
                            print('You called!');
                            final result = await CounterApi.readCounterByCodeAndMachine(_stickerDeleteController.text.trim(), _machineLineController.text.trim(), _url);
                            
                            result.when((err) {
                              print('Error: $err');
                              Navigator.of(context, rootNavigator: true).pop();
                              Utils.openDialogPanel(context, 'close', 'Oops!', 'Not available on the Table', 'Okay');
                            }, (c) async {
                              print('Counter: ${c.id} : ${c.stockId} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');
                            // 2. if available, subtract quantity by 1 and save it to db
                              if(c.qty == 1) {
                                await CounterApi.delete(c.id.toString(), 'prod_delete', _url).then((res) {
                                  if(res == c.id) {
                                    setState(() {
                                      _counterList.removeWhere((item) => item.id == c.id);
                                      _stickerDeleteController.text = '';
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content:  Text("🚨 Not deleted successfully!", textAlign: TextAlign.center,),
                                      duration: Duration(milliseconds: 3000)
                                    ));
                                  }
                                });
                              } else if(c.qty == 0) {
                                Navigator.of(context, rootNavigator: true).pop();
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Quantity is 0. Already deducted.', 'Try again');
                              } else {
                                Counter updatedCounter = Counter(
                                  id: c.id,
                                  stockId: c.stockId,
                                  stockCode: c.stockCode,
                                  stockName: c.stockName,
                                  machine: _machineLineController.text.trim(),
                                  device: _deviceName,
                                  shift: _shiftValue,
                                  shiftDate: c.shiftDate,
                                  createdTime: c.createdTime,
                                  updatedTime: DateTime.now(),
                                  qty: c.qty - 1,
                                  // Here need some change
                                  totalQty: (c.totalQty - (c.totalQty/c.qty)).toInt(),
                                  purchasePrice: c.purchasePrice,
                                  uom: c.uom,
                                  stockCategory: c.stockCategory,
                                  group: c.group,
                                  stockClass: c.stockClass,
                                  weight: c.weight
                                );

                                CounterApi.dropCounter(
                                    c.id.toString(),
                                    updatedCounter.updatedTime.toIso8601String(),
                                    (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(),
                                    _url,
                                    'Prod-Deduct',
                                    _deviceName
                                ).then((res) {
                                    // print('Updated ID: $res');
                                  setState(() {
                                    _counterList[_counterList.indexWhere((item) => item.id == updatedCounter.id)] = updatedCounter;
                                    _stickerDeleteController.text = '';
                                  });
                                  _reloadTable(_machineLineController.text);
                                }).catchError((err) {
                                  print('Error: $err');
                                });
                              }
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          },
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content:  Text("❌ Wrong password!", textAlign: TextAlign.center,),
                              duration: Duration(milliseconds: 3000)
                            ));
                          },
                          () {
                            setState(() {
                              
                            });
                          }
                        );
                      }
                    }).catchError((err) {
                      // print('Err: $err');
                      Utils.openDialogPanel(context, 'close', 'Oops!', 'Error: $err', 'Understand');
                      return;
                    });
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: style.Colors.button2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _machineLine(context),
          isAddView ? _addView(context) : _deleteView(context),
          _productionTable(context),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: transaction,
      )
    );
  }
}
