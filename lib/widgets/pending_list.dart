import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '../database/counter_in_db.dart';
import '../helper/counter_api.dart';
import '../helper/stock_counter_api.dart';
import '../helper/file_manager.dart';
import '../helper/utils.dart';
import '../model/pending.dart';
import '../model/counter.dart';
import '../styles/theme.dart' as style;

class PendingList extends StatefulWidget {
  const PendingList({Key? key}) : super(key: key);

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  final _masterController = TextEditingController();
  final FocusNode _masterNode = FocusNode();
  static final _machineKey = GlobalKey<FormFieldState>();
  static final _shiftKey = GlobalKey<FormFieldState>();

  String lineVal = '';
  List<String> _machineList = [];
  String _url = '';
  bool _isLoading = false;
  String shiftVal = '';
  bool _isEmptyValue = true;
  List<String> _shiftList = [];
  List<Pending> _pendingList = [];
  List<Pending> _pendingListView = [];

  Future initPendingTable() async {
    final currentTime = DateTime.now();
    // Same day logic and Pending table
    setState(() {
      _isLoading = true;
    });
    // Category Priorities
    // 1. Created Date
    // 2. Machine Line
    // 3. Shift name
    for (var m in _machineList) {
      var dateList = [];
      print('Machine 👉 : $m');
      await CounterApi.readCountersWithMachine(_url, m).then((list) async {
        for (var item in list) {
          var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
          final index = dateList.indexWhere((d) => d == tempDate);
          final diff = currentTime.difference(item.shiftDate);
          if(diff.inHours > 23) {
            if(item.qty > 0) {
              if (index >= 0) {
                print('Already there!');
              } else {
                dateList.add(tempDate);
              }
            } else {
              await CounterApi.delete(item.id.toString(), _url);
            }
          } else {
            if (index >= 0) {
              print('Already there!');
            } else {
              dateList.add(tempDate);
            }
          }
        }

        for (var d in dateList) {
          var shiftList = [];
          for (var item in list) {
            var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
            if( d == tempDate) {
              final index = shiftList.indexWhere((s) => s == item.shift);
              if (index >= 0) {
                print('Already there shift!');
              } else {
                shiftList.add(item.shift);
              }
            }
          }

          for (var s in shiftList) {
            List<Counter> tempCounters = [];
            var total = 0;
            var stockInTotal = 0;
            for (var item in list) {
              var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
              if( d == tempDate && s == item.shift) {
                tempCounters.add(item);
                total = total + item.qty;
              }
            }

            for (var el in tempCounters) {
              stockInTotal = 0;
              final result = await StockCounterApi.readStockCountersByCodeAndMachine(el.stockCode, el.machine, _url);

              result.when((err) async {
                if('$err'.contains('404')) {
                  print('Not found! Or $err');
                }
              }, (c) async {
                print('👉 Got it! ${el.stockCode}');
                for (var item in c) {
                  var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
                  if( d == tempDate) {
                    print('👉 item qty: ${item.qty}');
                    stockInTotal = stockInTotal + item.qty;
                  }
                }
              });
            }

            if(tempCounters.isNotEmpty) {
              Pending newPending = Pending(
                machine: tempCounters[0].machine,
                shift: tempCounters[0].shift,
                date: DateFormat('dd/MM/yyyy').format(tempCounters[0].shiftDate),
                pending: total,
                stockIn: stockInTotal
              );
              _pendingList.add(newPending);
            }
          }
        }
        _pendingListView = _pendingList;
        _isLoading = false;
      }).catchError((err) async {
        _isLoading = false;
        print('Error 👉 $err');
        // Utils.openDialogPanel(context, 'close', 'Oops!', 'Not available on the Table', 'Try again');
        print('Counters with 👉 $m Machine code is not found!');
      });
    }
    setState(() {});
  }

  Future initSettings() async {
    var shifts = await FileManager.readStringList('shift_list');
    _machineList = await FileManager.readStringList('machine_line');
    final ip =  await FileManager.readString('counter_ip_address');
    final port =  await FileManager.readString('counter_port_number');

    if(ip != '' && port != '') {
      _url = 'http://$ip:$port';
    } else {
      _url = 'http://localhost:3000';
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

    if(!_isEmptyValue) {
      initPendingTable();
    }

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
              flex: 4,
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
                      _pendingListView = _pendingList.where((el) => el.machine == lineVal).toList();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
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
                      _pendingListView = _pendingList.where((el) => el.machine == lineVal).toList();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pendingListView = _pendingList;
                      });
                    },
                    child: const Icon(
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
        margin: const EdgeInsets.only(right: 2, left: 2, top: 5, bottom: 5),
        padding: const EdgeInsets.only(right: 2, left: 2, top: 5, bottom: 5),
        height: 480,
        width: 440,
        child: child,
      );
    }

    Widget _pendingTable(BuildContext context) {
      return buildContainer(
        SingleChildScrollView(
          child: DataTable(
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Machine:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
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
              label: Expanded(
                child: Text(
                  'Date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: style.Colors.mainGrey,
                  ),
                  textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
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
          rows: _pendingListView.map((row) => DataRow(
            cells: [
              DataCell(
                Text(
                  row.machine,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.shift,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: style.Colors.button2,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    row.pending.toString(),
                  ),
                )
              ),
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
          _isLoading ? const Center(
            child: CircularProgressIndicator(
                strokeWidth: 8.0,
                valueColor : AlwaysStoppedAnimation(style.Colors.mainBlue),
              ),
            ) : _pendingTable(context),
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
