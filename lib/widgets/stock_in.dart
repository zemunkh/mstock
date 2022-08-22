import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/counterIn.dart';
import '../model/stockIn.dart';
import '../database/counter_in_db.dart';
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
  final _passwordController = TextEditingController();

  final FocusNode _masterNode = FocusNode();
  final FocusNode _deleteNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  static final _masterFormKey = GlobalKey<FormFieldState>();
  static final _deleteFormKey = GlobalKey<FormFieldState>();
  static final _passwordFormKey = GlobalKey<FormFieldState>();
  List<CounterIn> _counterInList = [];
  
  bool _isLoading = false;

  String _qneUrl = '';
  String _url = '';
  String _dbCode = '';
  String _scanDelay = '15';
  String _location = '';
  String _docPrefix = '';
  String _deviceName = '';
  String _project = '';
  bool isAddView = true;
  bool isPosting = false;
  String _supervisorPassword = '';


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
      setState(() {
        _isLoading = true;
      });
      // Add isPosted flag
      // Read Counter with stockCode from Counter API (Network server)
      await CounterApi.readCounterByCodeAndDate(trueVal, _url).then((c) async {
        print('✅ Counter: ${c.id} : ${c.stockId} : ${c.stockCode} : ${c.machine} : ${c.createdTime} : QTY -> ${c.qty}');

        // If found, create CounterIn object
        await CounterInDatabase.instance.readCounterInByCode(c.stockCode).then((res) async {
          
          CounterIn updateCounterIn = CounterIn(
            id: res.id,
            stock: res.stock,
            description: res.description,
            machine: res.machine,
            shift: res.shift,
            device: res.device,
            uom: res.uom,
            qty: res.qty + 1,
            purchasePrice: res.purchasePrice,
            isPosted: false,
            createdAt: res.createdAt,
            updatedAt: DateTime.now()
          );

          await CounterInDatabase.instance.update(updateCounterIn).then((res) {
            setState(() {
              _counterInList[_counterInList.indexWhere((item) => item.stock == updateCounterIn.stock)] = updateCounterIn;
              _masterController.text = '';
            });
          }).catchError((err) {
            Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
          });

        }).catchError((err) async {
          print('Error -> 2: $err');
          CounterIn newCounterIn = CounterIn(
            stock: c.stockCode, // necessary
            description: c.stockName,
            machine: c.machine, // necessary
            shift: c.shift,
            device: _deviceName,
            uom: c.baseUOM,
            qty: c.qty,
            purchasePrice: c.purchasePrice,
            isPosted: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()
          );
          await CounterInDatabase.instance.create(newCounterIn).then((res) {
            setState(() {
              _counterInList.add(newCounterIn);
              _masterController.text = '';
            });
          }).catchError((err) {
            print('Error -> 3: $err');
            Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
          });
        });
        // Search the stock in the Current list

        // if it is available, Update it to the CounterIn database (Locally)

        // Else, Save it to the CounterIn database (Locally)


        await Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _masterController.text = trueVal;
            _isLoading = false;
          });
        });
      }).catchError((err) async {
        print('Error -> 3: $err');
        Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _masterController.text = '';
            _isLoading = false;
          });
        });
      });
    }
  }

  Future deleteListener() async {
    String buffer = '';
    String trueVal = '';
    buffer = _deleteController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _deleteNode.unfocus();
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _masterController.text = trueVal;
          _isLoading = false;
        });
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
    final ip =  await FileManager.readString('counter_ip_address');
    final port =  await FileManager.readString('counter_port_number');
    if(ip != '' && port != '') {
      _url = 'http://$ip:$port';
    } else {
      _url = 'http://localhost:3000';
    }

    final qneIp =  await FileManager.readString('qne_ip_address');
    final qnePort =  await FileManager.readString('qne_port_number');
    _dbCode = await FileManager.readString('db_code');
    if(qneIp != '' && qnePort != '' && _dbCode != '') {
      _qneUrl = 'http://$ip:$port';
    } else {
      _qneUrl = 'https://dev-api.qne.cloud';
      _dbCode = 'fazsample';
    }
    await CounterInDatabase.instance.readCounterInsNotPosted().then((res) {
      _counterInList = res;
    }).catchError((err) {
        print('Err: $err');
        Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
    _masterController.addListener(masterListener);
    _deleteController.addListener(deleteListener);
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
              suffixIcon: _isLoading ? Transform.scale(
                  scale: 0.6,
                  child: const CircularProgressIndicator(
                    strokeWidth: 8.0,
                    valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
                  ),
                ) : IconButton(
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
              // _clearTextController(context, _mainController, _mainNode);
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
        height: 400,
        width: 400,
        child: child,
      );
    }

    Widget _stockInTable(BuildContext context) {
      return buildContainer(
        SingleChildScrollView(
          child: DataTable(
          columnSpacing: 60,
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
          ],
          rows: _counterInList.map((row) => DataRow(
            cells: [
              DataCell(Text(row.stock)),
              DataCell(Text(row.qty.toString())),
              DataCell(Text(row.uom)),
            ]
          )).toList(),
          
          ),
        )
      );
    }

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
                      _deleteController.text = '';
                    }
                    setState(() {
                      isAddView = true;
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
                      _deleteController.text = '';
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

    Widget _actionTab(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text('')
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
                    DateTime currentTime = DateTime.now();
                    setState(() {
                      isPosting = true;
                    });

                    // For Same day logic check

                    List<Details> details = [];
                    for (var i = 0; i < _counterInList.length; i++) {
                      Details n = Details(
                        numbering: i.toString(),
                        stock: _counterInList[i].stock,
                        pos: 0,
                        description: _counterInList[i].description,
                        price: _counterInList[i].purchasePrice,
                        uom: _counterInList[i].uom,
                        qty: _counterInList[i].qty,
                        amount: _counterInList[i].qty * _counterInList[i].purchasePrice,
                        note: '$_deviceName ${_counterInList[i].shift} ${_counterInList[i].machine} ${DateFormat("ddMMyyyy HH:mm").format(currentTime)}',
                        costCentre: '',
                        project: _project,
                        stockLocation: _location
                      );
                      details.add(n);
                    }

                    StockIn newValue = StockIn(
                      stockInCode: '${_docPrefix}${DateFormat("ddMMyyyyHms").format(currentTime)}',
                      stockInDate: currentTime,
                      description: 'App Stock In from $_deviceName',
                      referenceNo: 'String',
                      title: '',
                      notes: '',
                      costCentre: '',
                      project: _project,
                      stockLocation: _location,
                      details: details,
                    );
                    
                    await StockApi.postStockIns(_dbCode, newValue.toJson(), _qneUrl).then((status) {
                      if(status == 200) {
                        Utils.openDialogPanel(context, 'accept', 'Done!', 'StockIn is successfully posted!', 'Okay');
                        // Update isPosted status to TRUE
                        for (var el in _counterInList) {
                          CounterInDatabase.instance.updatePostedStatus(el.id!).then((result) {
                            if(el.id == result) {
                              print('Done ✅');
                            }
                          }).catchError((err) {
                            Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
                          });
                        }
                        _counterInList = [];
                      } else if(status == 408) {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Timed out! Check your network connection.', 'Understand');
                      } else {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to post StockIns', 'Understand');
                      }
                      isPosting = false;
                    }).catchError((err) {
                      Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
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
                    ) : const Text('Save & Post'),
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
            '🏷 Delete stock: ',
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
                  'Delete key',
                  _deleteController,
                  _deleteNode,
                  double.infinity,
                  _deleteFormKey,
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
                  onPressed: () async {

                    Utils.openPasswordPanel(
                      context,
                      _supervisorPassword,
                      _passwordController,
                      _passwordNode,
                      _passwordFormKey,
                      'padlock',
                      'Do you want to delete the StockIn value?',
                      'Confirm',
                      () async {

                        await CounterInDatabase.instance.readCounterInByCode(_deleteController.text.trim()).then((res) async {
                          print('👉 Counter In : ${res.id} : ${res.stock} : ${res.stock} : ${res.description} : ${res.updatedAt} : QTY -> ${res.qty}');
                          
                          if(res.qty == 1) {
                            await CounterInDatabase.instance.delete(res.id!).then((result) {
                              if(result == res.id) {
                                setState(() {
                                  _counterInList.removeWhere((item) => item.stock == res.stock);
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content:  Text("🚨 Not deleted successfully!", textAlign: TextAlign.center,),
                                  duration: Duration(milliseconds: 3000)
                                ));
                              }
                            });
                          } else {
                            CounterIn updateCounterIn = CounterIn(
                              id: res.id,
                              stock: res.stock, // stockCode
                              description: res.description,
                              machine: res.machine,
                              shift: res.shift,
                              device: res.device,
                              uom: res.uom,
                              qty: res.qty - 1,
                              purchasePrice: res.purchasePrice,
                              isPosted: false,
                              createdAt: res.createdAt,
                              updatedAt: DateTime.now()
                            );

                            await CounterInDatabase.instance.update(updateCounterIn).then((res) {
                              setState(() {
                                _counterInList[_counterInList.indexWhere((item) => item.stock == updateCounterIn.stock)] = updateCounterIn;
                                _masterController.text = '';
                              });
                            }).catchError((err) {
                              Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
                            });
                          }


                        }).catchError((err) async {
                          print('Error -> 2: $err');

                        });


                      },
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:  Text("❌ Wrong password!", textAlign: TextAlign.center,),
                          duration: Duration(milliseconds: 3000)
                        ));
                      }
                    );
    
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
          _actionTab(context),
          isAddView ? _addView(context) : _deleteView(context),
          _stockInTable(context),
          _postBtn(context)
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
