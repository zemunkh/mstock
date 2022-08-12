import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../helper/file_manager.dart';
import '../helper/utils.dart';
import '../model/pending.dart';
import '../styles/theme.dart' as style;

class PendingList extends StatefulWidget {
  const PendingList({Key? key}) : super(key: key);

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  final _masterController = TextEditingController();
  final FocusNode _masterNode = FocusNode();

  String lineVal = '';
  List<String> _machineList = [];

  String shiftVal = '';
  List<String> _shiftList = [];

  List<Pending> _pendingList = []; 

  Future initSettings() async {
    var shifts = await FileManager.readStringList('shift_list');
    _machineList = await FileManager.readStringList('machine_line');
    if(_machineList.isEmpty) {
      _machineList = ['A1', 'A2'];
      lineVal = 'A1';
    } else {
      lineVal = _machineList[0];
    }

    if(shifts.isEmpty) {
      _shiftList = ['Morning', 'Afternoon', 'Night'];
      shiftVal = 'Morning';
    } else {
      for (var shift in shifts) {
        print('👉 Shift: $shift');
        var dayName = shift.split(',')[0];
        var startTime = shift.split(',')[1];
        var endTime = shift.split(',')[2];
        _shiftList.add(dayName);
      }
    }


    shiftVal = await Utils.getShiftName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {

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

    Widget buildContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        height: 480,
        width: 400,
        child: child,
      );
    }

    Widget _pendingTable(BuildContext context) {
      return buildContainer(
        SingleChildScrollView(
          child: DataTable(
          columnSpacing: 30,
          showCheckboxColumn: false,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Machine:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Shift:',
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
              ),
            ),
            DataColumn(
              label: Text(
                'Pending:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'In:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
          ],
          rows: _pendingList.map((row) => DataRow(
            cells: [
              DataCell(Text(row.machine)),
              DataCell(Text(row.shift)),
              DataCell(Text(row.date)),
              DataCell(Text(row.pending.toString())),
              DataCell(Text(row.stockIn.toString())),
            ]
          )).toList(),
          
          ),
        )
      );
    }

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _filterSelectors(context),
          _pendingTable(context),
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
