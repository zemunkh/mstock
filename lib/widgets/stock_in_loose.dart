import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/counterIn.dart';
import '../model/uoms.dart';
import '../model/stockIn.dart';
import '../database/counter_in_db.dart';
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


  final FocusNode _masterNode = FocusNode();
  final FocusNode _quantityNode = FocusNode();

  static final _masterFormKey = GlobalKey<FormFieldState>();
  static final _quantityFormKey = GlobalKey<FormFieldState>();
  static final _machineKey = GlobalKey<FormFieldState>();
  static final _shiftKey = GlobalKey<FormFieldState>();


  List<CounterIn> _counterInList = [];
  List<CounterIn> _counterInListView = [];
  
  bool _isLoading = false;

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

  String lineVal = '';
  List<String> _machineList = [];
  List<String> _shiftList = [];
  String shiftVal = '';
  bool _isEmptyValue = true;

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

      await StockDatabase.instance.readStockByCode(trueVal).then((val) async {
        await StockApi.readFullStock(_dbCode, val.stockId, '$_qneUrl/api/Stocks').then((res) async {
          print('Res: ✅  ${res.stockId} rate = ${res.uoMs[0]!.rate}');
          
          List<Uom> activeUoms = [];
          for (var u in res.uoMs) {
            if(u!.isActive) {
              activeUoms.add(u);
            }
          }
          activeUoms.sort((a, b) => a.rate.compareTo(b.rate));
          Uom bigger = activeUoms.last;

          setState(() {
            _baseUom = bigger.uomCode;
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
  }

  Future initSettings() async {
    var shifts = await FileManager.readStringList('shift_list');
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
    print('👉 $shifts');
    if(shifts.isEmpty) {
      _shiftList = ['Morning', 'Afternoon', 'Night'];
      shiftVal = 'Morning';
    } else {
      _isEmptyValue = _isEmptyValue && false;
      for (var shift in shifts) {
        print('👉 Shift: $shift');
        var dayName = shift.split(',')[0];
        var startTime = shift.split(',')[1];
        var endTime = shift.split(',')[2];
        _shiftList.add(dayName);
      }
      shiftVal = await Utils.getShiftName();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
    // _deletePostedStockIns();
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

    Widget _mainSelectors(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
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
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Text(
                    'Shift: ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: style.Colors.mainGrey,
                    ),
                  ),
                  DropdownButton(
                    // Initial Value
                    key: _shiftKey,
                    value: shiftVal,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: _shiftList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (Object? value) {
                      shiftVal = value.toString();
                      setState(() {});
                    },
                  ),
                ],
              ),
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
              suffixIcon: IconButton(
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
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(top: 12, bottom: 5),
        padding: const EdgeInsets.all(5),
        height: 400,
        width: 440,
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
          rows: _counterInListView.map((row) => DataRow(
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
                    setState(() {
                      isPosting = true;
                    });
                    DateTime currentTime = DateTime.now();
                    DateTime shiftConvertedTime = await Utils.getShiftConvertedTime(currentTime);

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
            '⚙️ Quantity: ',
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
                  120,
                  _quantityFormKey
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
              Expanded(
                flex: 7,
                child: _qtyInput(context),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isLoading == true) { return; }

                      setState(() {
                        _isLoading = true;
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
                      primary: style.Colors.button4,
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
