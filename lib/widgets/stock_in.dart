import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/stockCounter.dart';
import '../model/stockIn.dart';
// import '../database/counter_in_db.dart';
import '../helper/stock_counter_api.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../helper/counter_api.dart';
import '../../helper/stock_api.dart';
import '../styles/theme.dart' as style;

class StockInWidget extends StatefulWidget {
  const StockInWidget({Key? key}) : super(key: key);

  @override
  State<StockInWidget> createState() => _StockInWidgetState();
}

class _StockInWidgetState extends State<StockInWidget> {
  final _masterController = TextEditingController();
  final _deleteController = TextEditingController();

  final FocusNode _masterNode = FocusNode();

  static final _masterFormKey = GlobalKey<FormFieldState>();

  List<StockCounter> _counterInList = [];
  // List<CounterIn> _counterInListView = [];
  
  bool _isCheckerLoading = false;
  bool _isLoading = false;
  bool _isSaveDisabled = true;
  String _qneUrl = '';
  String _url = '';
  String _dbCode = '';
  String _scanDelay = '15';
  String _location = '';
  String _docPrefix = '';
  String _deviceName = '';
  String _project = '';
  String _whId = '';
  bool isPosting = false;
  String _supervisorPassword = '';

  // _prepareListView() {
  //   _counterInListView = [];
  //   for (var el in _counterInList) {
  //     var index = _counterInListView.indexWhere((item) => item.stock == el.stock);
  //     if(index > -1) {
  //       CounterIn updateCounterInView = CounterIn(
  //         id: el.id,
  //         stock: el.stock,
  //         description: el.description,
  //         machine: el.machine,
  //         shift: el.shift,
  //         device: el.device,
  //         uom: el.uom,
  //         qty: _counterInListView[index].qty + el.qty,
  //         purchasePrice: el.purchasePrice,
  //         isPosted: false,
  //         shiftDate: el.shiftDate,
  //         createdAt: el.createdAt,
  //         updatedAt: el.updatedAt
  //       );
  //       _counterInListView[index] = updateCounterInView;
  //     } else {
  //       _counterInListView.add(el);
  //     }
  //   }
  // }

  Future _deletePostedStockIns() async {
    final currentTime = DateTime.now();

    final result = await StockCounterApi.readStockCountersPosted(_url);
  
    result.when((err) async {
      if('$err'.contains('404')) {
        print('Err empty: $err');
      }
    }, (c) async {
      for (var el in c) {
        final diff = currentTime.difference(el.updatedAt);
        if(diff.inHours > 23) {
          await StockCounterApi.delete(el.id.toString(), _url);
        }
      }
    });
  }

  Future _clearTextController(BuildContext context,
      TextEditingController _controller, FocusNode node) async {
    setState(() {
      _controller.clear();
    });
    FocusScope.of(context).requestFocus(node);
  }

  Future masterListener() async {
    String buffer = '';
    String trueVal = '';
    buffer = _masterController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _masterNode.unfocus();

      await Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _masterController.text = trueVal;
          _isSaveDisabled = false;
        });
        _masterNode.unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    if(buffer.isEmpty) {
      setState(() {
        _isSaveDisabled = true;
      });
    }
  }

  Future initSettings() async {
    _scanDelay = await FileManager.readString('scan_delay');
    _supervisorPassword = await FileManager.readString('supervisor_password');
    _location = await FileManager.readString('location');
    _docPrefix = await FileManager.readString('doc_prefix');
    _deviceName = await FileManager.readString('device_name');
    _project = await FileManager.readString('project_code');
    _whId = await FileManager.readString('wh_id');
    final ip =  await FileManager.readString('counter_ip_address');
    final port =  await FileManager.readString('counter_port_number');
    if(ip != '' && port != '') {
      _url = 'http://$ip:$port';
    } else {
      _url = 'http://localhost:8080';
    }
    print('URL ⭐️ : $_url');

    final qneIp =  await FileManager.readString('qne_ip_address');
    final qnePort =  await FileManager.readString('qne_port_number');
    _dbCode = await FileManager.readString('db_code');
    if(qneIp != '' && qnePort != '' && _dbCode != '') {
      _qneUrl = 'http://$qneIp:$qnePort';
    } else {
      _qneUrl = 'https://dev-api.qne.cloud';
      _dbCode = 'fazsample';
    }

    // await CounterInDatabase.instance.delete(1);

    final result = await StockCounterApi.readStockCountersNotPosted(_url);

    result.when(
      (e) {
        // Utils.openDialogPanel(context, 'close', 'Oops!', 'StockIn table is empty.', 'Understand');
        print('Empty list: $e');
      },
      (res) {
        _counterInList = res;
        // _prepareListView();
      }
    );
    // _deletePostedStockIns();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
    _masterController.addListener(masterListener);
  }

  @override
  void dispose() {
    _masterController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.now();

    Widget _scannerInput(String hintext, TextEditingController _controller,
        FocusNode currentNode, double currentWidth, GlobalKey _formKey) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 52,
          width: currentWidth,
          child: TextFormField(
            key: _formKey,
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
              suffixIcon:IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.blueAccent,
                  size: 24,
                ),
                onPressed: () {
                  _clearTextController(context, _controller, currentNode);
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
        margin: const EdgeInsets.only(top: 12, bottom: 5),
        padding: const EdgeInsets.all(5),
        height: 320,
        width: 440,
        child: child,
      );
    }

    Widget _stockInTable(BuildContext context) {
      return buildContainer(
        SingleChildScrollView(
          child: DataTable(
          columnSpacing: 15,
          showCheckboxColumn: false,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Stocks:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Qty:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'UOMs:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Date:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          rows: _counterInList.map((row) => DataRow(
            cells: [
              DataCell(
                Text(
                  row.stock,
                  style: const TextStyle(
                    fontSize: 12,
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                ),
              ),
              DataCell(
                Text(
                  DateFormat('dd/MM/yyyy').format(row.shiftDate),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                )
              ),
            ]
          )).toList(),
          
          ),
        )
      );
    }

    Widget _postBtn(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const Expanded(
                flex: 6,
                child: Text('')
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () async {
                    if(isPosting) return;
                    setState(() {
                      isPosting = true;
                    });
                    DateTime currentTime = DateTime.now();
                    DateTime shiftConvertedTime = await Utils.getShiftConvertedTime(currentTime);

                    // For Same day logic check

                    List<Details> details = [];
                    for (var i = 0; i < _counterInList.length; i++) {
                      Details n = Details(
                        numbering: (i + 1).toString(),
                        stock: _counterInList[i].stock,
                        pos: 0,
                        description: 'From production ${_counterInList[i].stock} | $_deviceName | ${_counterInList[i].machine} | ${_counterInList[i].shift} | ${DateFormat("HH:mm:ss").format(currentTime)} | $_whId',
                        price: _counterInList[i].purchasePrice,
                        uom: _counterInList[i].uom,
                        qty: _counterInList[i].qty,
                        amount: _counterInList[i].qty * _counterInList[i].purchasePrice,
                        note: '$_deviceName ${_counterInList[i].shift} ${_counterInList[i].machine} ${DateFormat("ddMMyyyy HH:mm").format(currentTime)}',
                        costCentre: '',
                        project: _project.isEmpty ? '' : _project,
                        stockLocation: _location.isEmpty ? '' : _location,
                      );
                      details.add(n);
                    }
                    // print('👉 date format: ${DateFormat("yyMMddHHmmss").format(currentTime)}');
                    StockIn newValue = StockIn(
                      stockInCode: '$_docPrefix${DateFormat("yyMMddHHmmss").format(currentTime)}',
                      stockInDate: shiftConvertedTime.toUtc(),
                      description: 'App Stock In from $_deviceName',
                      referenceNo: '',
                      title: '',
                      notes: currentTime.toUtc().toIso8601String(),
                      costCentre: '',
                      project: _project.isEmpty ? '' : _project,
                      stockLocation: _location.isEmpty ? '' : _location,
                      details: details,
                    );
                    
                    await StockApi.postStockIns(_dbCode, newValue.toJson(), _qneUrl).then((status) async {
                      if(status == 200) {
                        // Update isPosted status to TRUE
                        for (StockCounter el in _counterInList) {

                          final result = await StockCounterApi.updatePostedStatus(el.id.toString(), true, _url);

                          result.when((err) async {
                            if('$err'.contains('404')) {
                              print('Wrong ❌');
                            }
                          }, (c) async {
                            
                            print('Done ✅');
                          });
                        }
                        // setState(() {
                        _counterInList = [];
                        // _counterInListView = [];
                        // });
                        Utils.openDialogPanel(context, 'accept', 'Done!', 'StockIn is successfully posted!', 'Okay');
                      } else if(status == 408) {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Timed out! Check your network connection.', 'Understand');
                      } else {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Code: $status \n Failed to post StockIns', 'Understand');
                      }
                      isPosting = false;
                    }).catchError((err) {
                      print('Err:  ❌ $err');
                      Utils.openDialogPanel(context, 'close', 'Oops!', 'Error: $err', 'Understand');
                      isPosting = false;
                    });
                    setState(() {});
                  },
                  child: isPosting ? Transform.scale(
                    scale: 0.6,
                    child: const CircularProgressIndicator(
                        strokeWidth: 8.0,
                        valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
                      ),
                    ) : const Text('Post'),
                  style: ElevatedButton.styleFrom(
                    primary: style.Colors.button4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
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
            '⚙️ Scan Stock: ',
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
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(''),
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
                flex: 3,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isLoading == true) { return; }
                    if (_isSaveDisabled == true) { return; }

                    setState(() {
                      _isLoading = true;
                    });
                    var currentTime = DateTime.now();
                    // Add isPosted flag
                    // Read Counter with stockCode from Counter API (Network server)
                    await CounterApi.readCounterByCodeAndDate(_masterController.text.trim(), _url).then((c) async {
                      print('✅ Counter: ${c.purchasePrice} : ${c.stockId} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');
                      print('✅ Counter: ${c.device} : ${c.shift} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');

                      var counterShiftDate = DateFormat('dd/MM/yyyy').format(c.shiftDate);
                      
                      // SameDay logic
                      bool isFoundStockIn = false;

                      //💡 _counterList from the Server, then update the table 💡

                      //💡 I/flutter ( 7614): Error: 👉 👉 👉 Concurrent modification during iteration: Instance(length:3) of '_GrowableList'.
                      for (var el in _counterInList) {
                        var stockInShiftDate = DateFormat('dd/MM/yyyy').format(el.shiftDate);
                        if(counterShiftDate == stockInShiftDate) {
                          print('💡 Found it');
                          isFoundStockIn = true;
                          await StockCounterApi.readCounter(el.id.toString(), _url).then((res) async {
                            print('💡 Id = ${res.id}');

                            if(res.counterId == c.id) {

                              StockCounter updateCounterIn = StockCounter(
                                id: res.id,
                                counterId: res.counterId, // Counter Id for current selection
                                stock: res.stock,
                                description: res.description,
                                machine: res.machine,
                                shift: res.shift,
                                device: res.device,
                                uom: res.uom,
                                qty: res.qty + 1,
                                purchasePrice: res.purchasePrice,
                                isPosted: false,
                                shiftDate: res.shiftDate,
                                createdAt: res.createdAt,
                                updatedAt: currentTime
                              );

                              final result = await StockCounterApi.update(updateCounterIn.toJsonFull(), _url);
                              
                              result.when((err) {
                                print('Err -> Updating: $err');
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to update StockIn counter.', 'Understand');

                              }, (updatedCounter) {
                                _counterInList[_counterInList.indexWhere((item) => item.id == updatedCounter.id)] = updatedCounter;
                                // _prepareListView();
                                _masterController.text = '';
                                if(c.qty > 0) {
                                  CounterApi.dropCounter(c.id.toString(), DateTime.now().toIso8601String(), (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(), _url, 'Stock In', _deviceName).then((r) {
                                    print('👉 Updated ID: $r');
                                  }).catchError((err) {
                                    print('Error: $err');
                                  });
                                }
                              });
                            } else {
                              StockCounter newCounterIn = StockCounter(
                                counterId: c.id,
                                stock: c.stockCode, // necessary
                                description: c.stockName,
                                machine: c.machine, // necessary
                                shift: c.shift,
                                device: _deviceName,
                                uom: c.uom,
                                qty: 1,
                                purchasePrice: c.purchasePrice,
                                isPosted: false,
                                shiftDate: c.shiftDate,
                                createdAt: c.createdTime,
                                updatedAt: currentTime
                              );
                              final result = await StockCounterApi.create(newCounterIn.toJson(), _url);
                              
                              result.when((err) {
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to create new StockIn counter: $err', 'Understand');
                              }, (newlyCreated) {
                                _counterInList.add(newlyCreated);

                                _masterController.text = '';

                                if(c.qty > 0) {
                                  CounterApi.dropCounter(c.id.toString(), DateTime.now().toIso8601String(), (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(), _url, 'Stock In', _deviceName).then((r) {
                                    print('👉 Updated ID: $r');
                                  }).catchError((err) {
                                    print('Error: $err');
                                  });
                                }
                              });
                              
                            }
                          }).catchError((err) async {
                            print('Error -> 2: $err');
                              StockCounter newCounterIn = StockCounter(
                                counterId: c.id,
                                stock: c.stockCode, // necessary
                                description: c.stockName,
                                machine: c.machine, // necessary
                                shift: c.shift,
                                device: _deviceName,
                                uom: c.uom,
                                qty: 1,
                                purchasePrice: c.purchasePrice,
                                isPosted: false,
                                shiftDate: c.shiftDate,
                                createdAt: c.createdTime,
                                updatedAt: currentTime
                              );
                              final result = await StockCounterApi.create(newCounterIn.toJson(), _url);
                              
                              result.when((err) {
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to create new StockIn counter: $err', 'Understand');
                              }, (newlyCreated) {
                                _counterInList.add(newlyCreated);

                                _masterController.text = '';

                                if(c.qty > 0) {
                                  CounterApi.dropCounter(c.id.toString(), DateTime.now().toIso8601String(), (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(), _url, 'Stock In', _deviceName).then((r) {
                                    print('👉 Updated ID: $r');
                                  }).catchError((err) {
                                    print('Error: $err');
                                  });
                                }
                              });
                          });
                        }
                      }

                      if(!isFoundStockIn) {
                        StockCounter newCounterIn = StockCounter(
                          counterId: c.id,
                          stock: c.stockCode, // necessary
                          description: c.stockName,
                          machine: c.machine, // necessary
                          shift: c.shift,
                          device: _deviceName,
                          uom: c.uom,
                          qty: 1,
                          purchasePrice: c.purchasePrice,
                          isPosted: false,
                          shiftDate: c.shiftDate,
                          createdAt: c.createdTime,
                          updatedAt: currentTime
                        );
                        await StockCounterApi.create(newCounterIn.toJson(), _url).then((res) {
                          _counterInList.add(newCounterIn);
                          // _prepareListView();
                          _masterController.text = '';

                          if(c.qty > 0) {
                            CounterApi.dropCounter(c.id.toString(), DateTime.now().toIso8601String(), (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(), _url, 'Stock In', _deviceName).then((r) {
                              print('👉 Updated ID: $r');
                            }).catchError((err) {
                              print('Error: $err');
                            });
                          }
                        }).catchError((err) {
                          print('Error: 👉 $err');
                          Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to create new StockIn counter.', 'Understand');
                        });
                      }
                      // Search the stock in the Current list

                      // if it is available, Update it to the CounterIn database (Locally)

                      // Else, Save it to the CounterIn database (Locally)

                      // if(c.qty > 0) {
                      //   CounterApi.dropCounter(c.id.toString(), DateTime.now().toIso8601String(), (c.qty - 1).toString(), (c.totalQty - (c.totalQty/c.qty)).toInt().toString(), _url, 'Stock In', _deviceName).then((r) {
                      //     print('👉 Updated ID: $r');
                      //   }).catchError((err) {
                      //     print('Error: $err');
                      //   });
                      // }
                      setState(() {
                        _isLoading = false;
                      });
                    }).catchError((err) async {
                      print('Error: 👉 👉 👉 $err');
                      setState(() {
                        _isLoading = false;
                      });
                      Utils.openDialogPanel(context, 'close', 'Oops!', 'No counter is available for the stockCode', 'Understand');
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: _isSaveDisabled ? style.Colors.mainDarkGrey : style.Colors.button4,
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
          _addView(context),
          _stockInTable(context),
          _counterInList.isEmpty ? const Text('') : _postBtn(context)
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
