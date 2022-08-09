import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/counter_in.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../styles/theme.dart' as style;

class StockIn extends StatefulWidget {
  const StockIn({Key? key}) : super(key: key);

  @override
  State<StockIn> createState() => _StockInState();
}

class _StockInState extends State<StockIn> {
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
  

  String _qneUrl = '';
  String _url = '';
  bool isAddView = true;
  bool _isMatched = false;
  String _supervisorPassword = '';

  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

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

    }
  }

  Future initSettings() async {
    final ip =  await FileManager.readString('counter_ip_address');
    final port =  await FileManager.readString('counter_port_number');
    if(ip != '' && port != '') {
      _url = 'http://$ip:$port';
    } else {
      _url = 'http://localhost:3000';
    }

    final qneIp =  await FileManager.readString('qne_ip_address');
    final qnePort =  await FileManager.readString('qne_port_number');
    if(qneIp != '' && qnePort != '') {
      _qneUrl = 'http://$ip:$port';
    } else {
      _qneUrl = 'https://dev-api.qne.cloud';
    }
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
                  // if(!(hintext.contains('Master') || hintext.contains('Sticker'))) {
                  //   setState(() {
                  //     _isMatched = false;
                  //   });
                  // }
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
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        height: 320,
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

    Widget _header(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Expanded(
              flex: 5,
              child: Text(
                'Stock In: ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text('Date:'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("yyyy/MM/dd HH:mm").format(createdDate),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
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
          const Text(
            '⚙️ Scan stock:           ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: style.Colors.mainGrey,
            ),
          ),
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
                      'Do you want to delete the counter?',
                      'Confirm',
                      () async {
                        print('You called!');

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
