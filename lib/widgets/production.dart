import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/stock.dart';
import '../model/counter.dart';
import '../../database/counter_db.dart';
import '../../database/stock_db.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../styles/theme.dart' as style;

class Production extends StatefulWidget {
  const Production({Key? key}) : super(key: key);

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  final _machineLineController = TextEditingController();
  final _masterController = TextEditingController();
  final _stickerController = TextEditingController();
  final _stickerDeleteController = TextEditingController();

  final FocusNode _masterNode = FocusNode();
  final FocusNode _machineLineNode = FocusNode();
  final FocusNode _stickerNode = FocusNode();
  final FocusNode _stickerDeleteNode = FocusNode();

  static final _machineLineFormKey = GlobalKey<FormFieldState>();
  static final _masterFormKey = GlobalKey<FormFieldState>();
  static final _stickerFormKey = GlobalKey<FormFieldState>();
  static final _stickerDeleteFormKey = GlobalKey<FormFieldState>();

  List<Counter> counterList = [];
  bool isSaveDisabled = true;
  bool _isMatched = false;
  String _shiftValue = '';
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
    weight: 0,
    isActive: false,
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
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _masterNode.unfocus();

      await StockDatabase.instance.readStockByCode(trueVal).then((val) async {
        print('Found stock: ${val.stockName}');
        // Add stock data to Counter table
        // 1. Search the stock in the existing table

        await Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _masterStock = val;
            _masterController.text = trueVal;
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
        // print('Adding...');
        if(_masterStock.remark1 != '4') {
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
          isSaveDisabled = true;
          // Utils.openDialogPanel(context, 'close', 'Oops!', 'Already filled!', 'Try again');
        }
      }

      setState(() {});

      // if True, add stock item to the list

      // else, remove stock item/decrease by the count 

      Future.delayed(const Duration(milliseconds: 1000), () {
        _stickerController.text = trueVal;
      }).then((value) {
        _stickerNode.unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
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

  bool isFound = false;

  Future machineLineListener() async {
    buffer = _machineLineController.text;
    print('Machine text: ${_machineLineController.text}');
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      // Load list of Machine Lines from Maintenance
      for (var el in _machineList) {
        if(trueVal == el) {
          isFound = true;
        }
      }

      if (isFound) {
        Utils.openDialogPanel(context, 'accept', 'Done!', 'Matched machine line.', 'Okay');
        setState(() {
          _isMatched = true;
        });
      } else {
        Utils.openDialogPanel(context, 'close', 'Oops!', 'No found!', 'Try again');
        setState(() {
          _isMatched = false;
        });
      }
      
      // Search and compare the result
      // If found, go to the next section
      // If not, alert to user.
      await Future.delayed(const Duration(milliseconds: 1000), () {
        _machineLineController.text = trueVal;
      }).then((value) {
        _machineLineNode.unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  Future initSettings() async {
    _machineList = await FileManager.readStringList('machine_line');
    _shiftValue = await Utils.getShiftName();
    counterList = await CounterDatabase.instance.readAllCounters();
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
                      _stickerController.text = '';
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
              // _clearTextController(context, _mainController, _mainNode);
            },
          ),
        ),
      );
    }

    Widget _productionTable(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: DataTable(
          columnSpacing: 20,
          showCheckboxColumn: false,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Stocks:',
              ),
            ),
            DataColumn(
              label: Text(
                'Qty:',
              ),
            ),
            DataColumn(
              label: Text(
                'UOMs:',
              ),
            ),
          ],
          rows: counterList.map((row) => DataRow(
            cells: [
              DataCell(Text(row.stockCode)),
              DataCell(Text(row.qty.toString())),
              DataCell(Text(row.baseUOM)),
            ]
          )).toList(),
          
          ),

          // rows: <DataRow>[
          //   DataRow(
          //     cells: const <DataCell>[
          //       DataCell(Text('F-CB-RYT0250X160-WT', style: TextStyle(fontSize: 14),)),
          //       DataCell(Text('23', style: TextStyle(fontSize: 14),)),
          //       DataCell(Text('PALLET', style: TextStyle(fontSize: 14),)),
          //     ],
          //     onSelectChanged: (newValue) {
          //       print('row 1 pressed');
          //     },
          //   ),
          //   DataRow(
          //     cells: const <DataCell>[
          //       DataCell(Text('HS-8.P12.5-032-100-BK', style: TextStyle(fontSize: 14),)),
          //       DataCell(Text('4', style: TextStyle(fontSize: 14),)),
          //       DataCell(Text('BOX', style: TextStyle(fontSize: 14),)),
          //     ],
          //     onSelectChanged: (newValue) {
          //       print('row 2 pressed');
          //     },
          //   ),
          // ],
        // ),
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
                flex: 4,
                child: _scannerInput(
                  'A1...',
                  _machineLineController,
                  _machineLineNode,
                  120,
                  _machineLineFormKey
                ),
              ),
              Expanded(
                flex: 6,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          levelBar(activeList[0] ? Colors.green : Colors.grey),
                          levelBar(activeList[1] ? Colors.green : Colors.grey),
                          levelBar(activeList[2] ? Colors.green : Colors.grey),
                          levelBar(activeList[3] ? Colors.green : Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 3, child: Text('')),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    if (isSaveDisabled == true) { return; }
                    print('Clicked the Save');
                    CounterDatabase.instance.readCounterByCode(_masterStock.stockCode).then((c) {
                        print('Counter: ${c.id} : ${c.stockId} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');
                      // 2. if available, add quantity by 1 and save it to db
                        
                        Counter updatedCounter = Counter(
                          id: c.id,
                          stockId: c.stockId,
                          stockCode: c.stockCode,
                          machine: _machineLineController.text.trim(),
                          shift: _shiftValue,
                          createdTime: DateTime.now(),
                          qty: c.qty + 1,
                          baseUOM: c.baseUOM,
                          stockCategory: c.stockCategory,
                          group: c.group,
                          stockClass: c.stockClass,
                          weight: c.weight
                        );

                        CounterDatabase.instance.update(updatedCounter).then((res) {
                          print('Updated ID: $res');

                          setState(() {
                            counterList[counterList.indexWhere((item) => item.stockId == updatedCounter.stockId)] = updatedCounter;
                          });

                        }).catchError((err) {
                          print('Error: $err');
                        });

                      }).catchError((err) {
                        print('Error: $err');
                      // 3. if not, create new Counter object
                        Counter newCounter = Counter(
                          id: 0,
                          stockId: _masterStock.stockId,
                          stockCode: _masterStock.stockCode,
                          machine: _machineLineController.text.trim(),
                          shift: _shiftValue,
                          createdTime: DateTime.now(),
                          qty: 1,
                          baseUOM: _masterStock.baseUOM,
                          stockCategory: _masterStock.category,
                          group: _masterStock.group,
                          stockClass: _masterStock.stockClass,
                          weight: _masterStock.weight
                        );
                      // 4. save it to the db.
                        CounterDatabase.instance.create(newCounter).then((res) {
                          print('Newly added ID: $res');
                          setState(() {
                            counterList.add(newCounter);
                          });
                        }).catchError((err) {
                          print('Error: $err');
                        });
                      });
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const Expanded(
                flex: 3,
                child: Text(''),
              ),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAddView = true;
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
