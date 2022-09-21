import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/counterInLoose.dart';
import '../model/counter.dart';
import '../model/uoms.dart';
import '../model/stockIn.dart';
import '../database/counter_inLoose_db.dart';
import '../../database/stock_db.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../helper/counter_api.dart';
import '../../helper/stock_api.dart';
import '../styles/theme.dart' as style;

class StockInLooseWidget extends StatefulWidget {
  const StockInLooseWidget({Key? key}) : super(key: key);

  @override
  State<StockInLooseWidget> createState() => _StockInLooseWidgetState();
}

class _StockInLooseWidgetState extends State<StockInLooseWidget> {
  final _masterController = TextEditingController();
  final _deleteController = TextEditingController();
  final _quantityController = TextEditingController();
  final _remarkController = TextEditingController();
  final _passwordController = TextEditingController();


  final FocusNode _masterNode = FocusNode();
  final FocusNode _quantityNode = FocusNode();
  final FocusNode _remarkNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  static final _masterFormKey = GlobalKey<FormFieldState>();
  static final _quantityFormKey = GlobalKey<FormFieldState>();
  static final _machineKey = GlobalKey<FormFieldState>();
  static final _shiftKey = GlobalKey<FormFieldState>();
  static final _remarkFormKey = GlobalKey<FormFieldState>();
  static final _passwordFormKey = GlobalKey<FormFieldState>();


  List<CounterInLoose> _counterInList = [];

  bool _isLoading = false;
  bool _isLoadingDel = false;
  bool _isSaveDisabled = true;
  String _qneUrl = '';
  String _url = '';
  String _dbCode = '';
  String _scanDelay = '15';
  String _location = '';
  String _docPrefix = '';
  String _deviceName = '';
  String _project = '';
  bool isPosting = false;
  String _supervisorPassword = '';

  String _baseUom = 'UNIT';
  double _biggerRate = 0;
  double _purchasePrice = 0;
  String _description = '';
  int _qty = 0;
  String lineVal = '';
  List<String> _machineList = [];
  String _shiftValue = '';
  bool _isEmptyValue = true;

  Future _clearTextController(BuildContext context,
      TextEditingController _controller, FocusNode node) async {
    setState(() {
      _controller.clear();
    });
    FocusScope.of(context).requestFocus(node);
  }

  Future quantityListener() async {
    String buffer = '';
    String trueVal = '';

    buffer = _quantityController.text;
    if(buffer.isNotEmpty) {
      setState(() {
        _qty = int.parse(buffer);
      });
    } else {
      setState(() {
        _qty = 0;
      });
    }
  }

  Future masterListener() async {
    String buffer = '';
    String trueVal = '';
    buffer = _masterController.text.trim();
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _masterNode.unfocus();
      setState(() {
        _isLoading = true;
      });

      await StockDatabase.instance.readStockByCode(trueVal).then((val) async {
        await StockApi.readFullStock(_dbCode, val.stockId, '$_qneUrl/api/Stocks').then((res) async {
          print('Res: ✅  ${res.stockId} rate = ${res.uoMs[0]!.rate}');
          List<Uom> activeUoms = [];
          for (var u in res.uoMs) {
            if(u!.isActive && u.isBaseUOM) {
              activeUoms.add(u);
            }
          }
          // activeUoms.sort((a, b) => a.rate.compareTo(b.rate));
          Uom baseUOM = activeUoms[0];

          setState(() {
            _baseUom = baseUOM.uomCode;
            _biggerRate = baseUOM.rate;
            _purchasePrice = val.purchasePrice;
            _isSaveDisabled = false;
            _isLoading = false;
          });

        }).catchError((err) {
          Utils.openDialogPanel(context, 'close', 'Oops!', '4# $err', 'Understand');
          setState(() {
            _isLoading = false;
          });
        });

      }).catchError((err) {
        print('Error: $err');

        Utils.openDialogPanel(context, 'close', 'Oops!', 'No such Stock is available!', 'Try again');

        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _isLoading = false;
          });
        });
      });

      await Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _masterController.text = trueVal;
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
    _machineList = await FileManager.readStringList('machine_line');
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
      _url = 'http://localhost:8080';
    }

    final qneIp =  await FileManager.readString('qne_ip_address');
    final qnePort =  await FileManager.readString('qne_port_number');
    _dbCode = await FileManager.readString('db_code');
    if(qneIp != '' && qnePort != '' && _dbCode != '') {
      _qneUrl = 'http://$qneIp:$qnePort';
    } else {
      _qneUrl = 'https://dev-api.qne.cloud';
      _dbCode = 'fazsample';
    }

    if(_machineList.isEmpty) {
      _machineList = ['A1', 'A2'];
      lineVal = 'A1';
    } else {
      lineVal = _machineList[0];
      _isEmptyValue = _isEmptyValue && false;
    }

    _shiftValue = await Utils.getShiftName();

    final result = await CounterInLooseDatabase.instance.readCounterInsLooseNotPosted();

    result.when(
      (e) {
        // Utils.openDialogPanel(context, 'close', 'Oops!', 'StockIn table is empty.', 'Understand');
        print('Empty list');
      },
      (res) {
        _counterInList = res;
      }
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
    // _deletePostedStockIns();
    _masterController.addListener(masterListener);
    _quantityController.addListener(quantityListener);
  }

  @override
  void dispose() {
    _masterController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget _mainSelectors(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const Text(
                  'Machine Line: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: style.Colors.mainGrey,
                  ),
                ),
                DropdownButton(
                  key: _machineKey,
                  // Initial Value
                  value: lineVal,
                  style: const TextStyle(
                    color: style.Colors.button2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: _machineList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (Object? value) {
                    lineVal = value.toString();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _scannerInput(String hintext, TextEditingController _controller,
        FocusNode currentNode, double currentWidth, GlobalKey _formKey, bool isSuffix) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 40,
          width: currentWidth,
          child: TextFormField(
            key: _formKey,
            keyboardType: hintext == '0' ? TextInputType.number : TextInputType.text,
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
              suffixIcon: isSuffix ? IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.blueAccent,
                  size: 24,
                ),
                onPressed: () {
                  _clearTextController(context, _controller, currentNode);
                },
              ) :  null,
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
          borderRadius: BorderRadius.circular(12),
        ),
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
          columnSpacing: 24,
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
                'Based-UOM:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Remark:',
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
              DataCell(Text(row.description)),
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
                        description: '${_counterInList[i].stock} | $_deviceName | ${_counterInList[i].machine} | ${_counterInList[i].shift} | ${DateFormat("HH:mm:ss").format(currentTime)}',
                        price: _counterInList[i].purchasePrice,
                        uom: _counterInList[i].uom,
                        qty: _counterInList[i].qty,
                        amount: _counterInList[i].qty * _counterInList[i].purchasePrice,
                        note: '$_deviceName ${_counterInList[i].shift} ${_counterInList[i].machine} ${DateFormat("ddMMyyyy HH:mm").format(currentTime)}',
                        // ref1: _deviceName,
                        costCentre: '',
                        project: _project.isEmpty ? '' : _project,
                        stockLocation: _location.isEmpty ? '' : _location,
                      );
                      details.add(n);
                    }
                    // print('👉 date format: ${DateFormat("yyMMddHHmmss").format(currentTime)}');
                    StockIn newValue = StockIn(
                      stockInCode: '${_docPrefix}${DateFormat("yyMMddHHmmss").format(currentTime)}',
                      stockInDate: shiftConvertedTime.toUtc(),
                      description: 'App Stock In from $_deviceName',
                      referenceNo: '',
                      title: ' From production | $_deviceName | $_shiftValue | $lineVal | ${DateFormat("HH:mm").format(currentTime)}',
                      notes: currentTime.toUtc().toIso8601String(),
                      costCentre: '',
                      project: _project.isEmpty ? '' : _project,
                      stockLocation: _location.isEmpty ? '' : _location,
                      details: details,
                    );
                    
                    await StockApi.postStockIns(_dbCode, newValue.toJson(), _qneUrl).then((status) async {
                      if(status == 200) {
                        // Update isPosted status to TRUE
                        for (CounterInLoose el in _counterInList) {
                          await CounterInLooseDatabase.instance.updatePostedStatus(el.id!).then((result) {
                            if(el.id == result) {
                              print('Done ✅');
                            }
                          }).catchError((err) {
                            // Utils.openDialogPanel(context, 'close', 'Oops!', '$err', 'Understand');
                            print('Wrong ❌');
                          });

                          await StockDatabase.instance.readStockByCode(el.stock).then((val) async {
                            Counter newCounterLog =  Counter(
                              stockId: val.stockId,
                              stockCode: el.stock,
                              stockName: val.stockName,
                              machine: el.machine,
                              shift: el.machine,
                              shiftDate: el.shiftDate,
                              createdTime: currentTime,
                              updatedTime: currentTime,
                              qty: el.qty,
                              totalQty: el.totalQty,
                              purchasePrice: el.purchasePrice,
                              uom: el.uom,
                              stockCategory: val.category,
                              group: val.group,
                              stockClass: val.stockClass,
                              weight: val.weight,
                            );
                            await CounterApi.createLog(newCounterLog.toJson(), _url).then((res){
                              print('Done ✅');
                            }).catchError((err){
                              print('Error when saving log ❌');
                            });
                          }).catchError((err) {
                            print('Error when getting stock data');
                          });
                        }
                        setState(() {
                          _counterInList = [];
                        });
                        Utils.openDialogPanel(context, 'accept', 'Done!', 'StockIn is successfully posted!', 'Okay');
                      } else if(status == 408) {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Timed out! Check your network connection.', 'Understand');
                      } else {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Code: $status \n Failed to post StockIns', 'Understand');
                      }
                      isPosting = false;
                    }).catchError((err) {
                      print('Err:  ❌ $err');
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

    Widget _qtyInput(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '💡 Quantity: ',
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
                  '0',
                  _quantityController,
                  _quantityNode,
                  150,
                  _quantityFormKey,
                  false,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  _baseUom,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: style.Colors.mainGrey,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }

    Widget _remarkInput(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '🏷 Remark: ',
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
                child: _scannerInput(
                  '',
                  _remarkController,
                  _remarkNode,
                  200,
                  _remarkFormKey,
                  true,
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
                  true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _qtyInput(context),
              ),
              Expanded(
                flex: 5,
                child: _remarkInput(context),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text('')
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isLoading == true) { return; }
                      if (_isSaveDisabled || _qty <= 0) { return; }

                      setState(() {
                        _isLoading = true;
                      });
                      var currentTime = DateTime.now();
                      
                      await StockDatabase.instance.readStockByCode(_masterController.text.trim()).then((val) async {

                      }).catchError((err){
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to fetch ${_masterController.text} stock', 'Understand');
                      });
                      

                      var _shiftConvertedDate = await Utils.getShiftConvertedTime(currentTime);
                      CounterInLoose newCounterIn = CounterInLoose(
                        stock: _masterController.text.trim(), // necessary
                        description: _remarkController.text,
                        machine: lineVal, // necessary
                        shift: _shiftValue,
                        device: _deviceName,
                        uom: _baseUom,
                        qty: int.parse(_quantityController.text),
                        totalQty: (_biggerRate * int.parse(_quantityController.text)).round(),
                        purchasePrice: _purchasePrice,
                        isPosted: false,
                        shiftDate: _shiftConvertedDate,
                        createdAt: currentTime,
                        updatedAt: currentTime
                      );
                      await CounterInLooseDatabase.instance.create(newCounterIn).then((res) {
                        _counterInList.insert(0, newCounterIn);
                        _masterController.text = '';
                        _quantityController.text = '';
                        _remarkController.text = '';
                        _baseUom = 'UNIT';
                        _biggerRate = 0.0;
                        _purchasePrice = 0.0;
                      }).catchError((err) {
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to create new StockIn counter.', 'Understand');
                      });
                      setState(() {
                        _isLoading = false;
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
                      primary: (_isSaveDisabled || _qty <= 0) ? style.Colors.mainDarkGrey : style.Colors.button4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isLoadingDel == true) { return; }
                      if(_counterInList.isEmpty) { return; }
                      if(_quantityController.text.isEmpty) { return; }
                      if(_quantityController.text == '0') { return; }

                      var currentTime = DateTime.now();
                      setState(() {
                        _isLoadingDel = true;
                      });

                      Utils.openPasswordPanel(
                        context,
                        _supervisorPassword,
                        _passwordController,
                        _passwordNode,
                        _passwordFormKey,
                        'padlock',
                        'Do you want to make change?',
                        'Confirm',
                        () async {
                          print('You called!');
                          
                          final firstRow = _counterInList[0];
                          final result = firstRow.qty - int.parse(_quantityController.text.trim());
                          if(result <= 0) {
                            // Delete
                            await CounterInLooseDatabase.instance.delete(firstRow.id!);
                            _counterInList.removeWhere((item) => item.id == firstRow.id);
                          } else {
                            // Update
                            CounterInLoose updateCounterIn = CounterInLoose(
                              id: firstRow.id,
                              stock: firstRow.stock,
                              description: firstRow.description,
                              machine: firstRow.machine,
                              shift: firstRow.shift,
                              device: firstRow.device,
                              uom: firstRow.uom,
                              qty: result, // Update Quantity
                              totalQty: (firstRow.totalQty - ((firstRow.totalQty/firstRow.qty) * int.parse(_quantityController.text.trim()))).toInt(),
                              purchasePrice: firstRow.purchasePrice,
                              isPosted: false,
                              shiftDate: firstRow.shiftDate,
                              createdAt: firstRow.createdAt,
                              updatedAt: currentTime
                            );

                            await CounterInLooseDatabase.instance.update(updateCounterIn).then((res) {
                              _counterInList[_counterInList.indexWhere((item) => item.stock == updateCounterIn.stock)] = updateCounterIn;
                              _masterController.text = '';
                              _quantityController.text = '';
                              _remarkController.text = '';
                            }).catchError((err) {
                              Utils.openDialogPanel(context, 'close', 'Oops!', 'Failed to update new StockIn counter.', 'Understand');
                            });
                          }
                          setState(() {
                            _isLoadingDel = false;
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
                    child: _isLoadingDel ? Transform.scale(
                        scale: 0.6,
                        child: const CircularProgressIndicator(
                          strokeWidth: 8.0,
                          valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
                        ),
                      ) :  const Text(
                      'Del.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: _counterInList.isEmpty ? style.Colors.mainDarkGrey : style.Colors.button2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }


    final transaction = Container(
      color: style.Colors.yellowDark,
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _mainSelectors(context),
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
