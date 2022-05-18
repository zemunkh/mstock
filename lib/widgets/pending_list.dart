import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../styles/theme.dart' as style;

class PendingList extends StatefulWidget {
  const PendingList({Key? key}) : super(key: key);

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  final _masterController = TextEditingController();
  final FocusNode _masterNode = FocusNode();

  String lineVal = 'E7';
  List<String> lines = [
    'E7',
    'E8',
    'K22',
    'K23',
    'K44',
  ];

  String shiftVal = 'Noon 12-15';

  List<String> shifts = [
    'Noon 12-15',
    'Afternoon 15-18',
    'Evening 18-21',
    'Night 21-24',
    'Midnight 24-03',
    'Dawn 03-06',
    'Morning 06-09',
    'Late Morning 09-12',
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
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.now();

    Widget _header(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                'Pending list: ',
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
              child: Text(''),
            ),
          ],
        ),
      );
    }

    Widget _filterSelectors(BuildContext context) {
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
                    // Initial Value
                    value: lineVal,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: lines.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (Object? value) {
                      setState(() {
                        lineVal = value.toString();
                      });
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
                    value: shiftVal,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: shifts.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (Object? value) {
                      setState(() {
                        shiftVal = value.toString();
                      });
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
        FocusNode currentNode) {
      return Stack(
        alignment: const Alignment(1.0, 1.0),
        children: <Widget>[
          TextFormField(
            style: const TextStyle(
              fontSize: 22,
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
            ),
            // autofocus: false,
            controller: _controller,
            focusNode: currentNode,
            onTap: () {
              _focusNode(context, currentNode);
            },
          ),
          ElevatedButton(
            onPressed: () {
              _clearTextController(context, _controller, currentNode);
              if (_controller == _masterController) {
                _masterController.clear();
              }
            },
            child: const SizedBox(
              height: 66,
              child: Icon(
                EvaIcons.refresh,
                color: Color(0xFF004B83),
                size: 30,
              ),
            ),
          ),
        ],
      );
    }

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(context),
          const Text(
            'Filter',
            style: TextStyle(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          _filterSelectors(context),
          _scannerInput('Scan code', _masterController, _masterNode),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxHeight > constraints.maxWidth) {
            return SingleChildScrollView(
              child: transaction,
            );
          } else {
            return SingleChildScrollView(
              child: transaction,
            );
          }
        },
      ),
    );
  }
}
