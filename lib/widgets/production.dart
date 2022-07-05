import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
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

  final FocusNode _masterNode = FocusNode();
  final FocusNode _machineLineNode = FocusNode();
  final FocusNode _stickerNode = FocusNode();

  List<bool> activeList = [
    true,
    true,
    true,
    false,
  ];

  var level = 0;
  // activeList = level.toRadixString(2);
  // activeList[0]

  String lineVal = 'E7';
  List<String> lines = [
    'E7',
    'E8',
    'K22',
    'K23',
    'K44',
  ];

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

  @override
  void dispose() {
    super.dispose();
    _masterController.dispose();
    _machineLineController.dispose();
    _stickerController.dispose();
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
                  onPressed: () {},
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: style.Colors.button4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Del'),
                  style: ElevatedButton.styleFrom(
                    primary: style.Colors.button2,
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
        FocusNode currentNode, double currentWidth) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 40,
          width: currentWidth,
          child: TextFormField(
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
                icon: const Icon(Icons.qr_code,
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

    Widget _productionTable(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: DataTable2(
          columnSpacing: 6,
          horizontalMargin: 6,
          minWidth: 340,
          columns: const [
            DataColumn2(
              label: Text('Stocks'),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Qty'),
            ),
            DataColumn(
              label: Text('UOMs'),
            ),
          ],
          rows: List<DataRow>.generate(
              5,
              (index) => DataRow(cells: [
                    DataCell(Text('A' * (10 - index % 10))),
                    DataCell(Text('B' * (10 - (index + 5) % 10))),
                    DataCell(Text('C' * (15 - (index + 5) % 10))),
                  ]))),
      );
    }

    Widget _machineLine(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          const Text(
            'Machine Line: ',
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
                  'A1',
                  _machineLineController,
                  _machineLineNode,
                  120,
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



    Widget _mainScanners(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          const Text(
            'Master: ',
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
                ),
              ),
            ],
          ),
          const Text(
            'Sticker: ',
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
                ),
              ),
            ],
          ),

          SizedBox(
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
          )

        ],
      );
    }

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _machineLine(context),
          SizedBox(height: 32,),
          _mainScanners(context),

          _productionTable(context),
          // _scannerInput('Scan code', _masterController, _masterNode),
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
      // LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     if (constraints.maxHeight > constraints.maxWidth) {
      //       return SingleChildScrollView(
      //         child: transaction,
      //       );
      //     } else {
      //       return SingleChildScrollView(
      //         child: transaction,
      //       );
      //     }
      //   },
      // ),
    );
  }
}
