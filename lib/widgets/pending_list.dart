import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '../database/counter_in_db.dart';
import '../helper/counter_api.dart';
import '../helper/stock_counter_api.dart';
import '../helper/file_manager.dart';
import '../helper/utils.dart';
import '../model/pending.dart';
import '../model/counter.dart';
import '../model/stockCounter.dart';
import '../styles/theme.dart' as style;

class PendingList extends StatefulWidget {
  const PendingList({Key? key}) : super(key: key);

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
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
  List<StockCounter> _counterInList = [];

  int _currentSortColumn = 0;
  bool _isAscending = true;

  Future _reloadStockIns() async {
    final result = await StockCounterApi.readStockCountersNotPosted(_url);
    result.when(
      (e) {
        print('Empty list: $e');
      },
      (res) {
        setState(() {
          _counterInList = res;
        });
      }
    );    
  }

  Future initPendingTable() async {
    final currentTime = DateTime.now();
    // Same day logic and Pending table
    setState(() {
      _isLoading = true;
      _pendingList = [];
    });
    // Category Priorities
    // 1. Created Date
    // 2. Machine Line
    // 3. Shift name
    for (var m in _machineList) {
      List<String> dateList = [];
      print('Machine 👉 : $m');
      await CounterApi.readCountersWithMachine(_url, m).then((list) async {

        for (var item in list) {
          var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
          final index = dateList.indexWhere((el) => el == tempDate);
          final diff = currentTime.difference(item.shiftDate);
          if(diff.inHours > 23) {
            // print(' 👉 🅿️ Temp day qty = 0: ${item.shift}');
            if(item.qty > 0) {
              if (index >= 0) {
                // print('Already there!');
              } else {
                dateList.add(tempDate);
              }
            } else {
               // Not posted StockIns with Counters with 0 qty
              var idIndex = _counterInList.indexWhere((el) => el.counterId == item.id);
              // var shiftIndex = _counterInList.indexWhere((el) => el.shift == item.shift);
              if(idIndex < 0) {
              // if(shiftIndex < 0) {
                // Not found in the NOT POSTED stockINs counter
                await CounterApi.delete(item.id.toString(), 'pending', _url);
              } else {
                if (index >= 0) {
                  print('Already there!');
                } else {
                  dateList.add(tempDate);
                }
              }
            }
          } else {
            if (index >= 0) {
              print('Already there!');
            } else {
              dateList.add(tempDate);
              // print('🅿️ Temp day: $tempDate : ${item.stockCode} : ${item.shiftDate}');
            }
          }
        }

        // print('DateList:👉 ${dateList}');

        for (var d in dateList) {
          var shiftListTemp = [];
          for (var item in list) {
            var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
            if( d == tempDate) {
              final index = shiftListTemp.indexWhere((s) => s == item.shift);
              if (index >= 0) {
                print('Already there shift!');
              } else {
                shiftListTemp.add(item.shift);
              }
            }
          }
          // print('🚨 Machine: $m | 👉 Shifts: ${shiftListTemp} | $d');

          List<Counter> tempCounters = [];

          for (var s in shiftListTemp) {
            var stockInTotal = 0;
            var total = 0;
            for (var item in list) {
              var shiftTempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
              if(item.shift == s && shiftTempDate == d) {
                var indexItem = tempCounters.indexWhere((el) => el.id == item.id);
                if(indexItem > -1) {
                  // if(item.qty > 0) {
                  total = total + item.qty;
                  // }
                } else {
                  tempCounters.add(item);
                  total = total + item.qty;
                  // print('🚨 Machine: $m | Shift: $s | Qty = ${item.qty} 🚨');
                }
              }
            }

            List<String> tempStockCodes = [];

            for (var el in tempCounters) {
              var index = tempStockCodes.indexWhere((element) => element == el.stockCode);
              if(index < 0) {
                tempStockCodes.add(el.stockCode);
              }
            }

            for (var sc in tempStockCodes) {
              final result = await StockCounterApi.readStockCountersByCodeAndMachine(sc, m, _url);

              result.when((err) {
                if('$err'.contains('404')) {
                  print('Not found! Or $err');
                }
              }, (list) {
                for (var item in list) {
                  var tempDate = DateFormat('dd/MM/yyyy').format(item.shiftDate);
                  if( d == tempDate && item.shift == s) {
                    stockInTotal = stockInTotal + item.qty;
                    // print('🚀 Stock item qty: ${item.qty} : ${item.stock} | Total : $stockInTotal | ${item.shift} | ${item.shiftDate}');
                  }
                }
              });
            }

            if(tempCounters.isNotEmpty) {
              Pending newPending = Pending(
                machine: m,
                shift: s,
                date: d,
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
        // print('Counters with 👉 $m Machine code is not found!');
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
    // print('👉 $shifts');
    if(shifts.isEmpty) {
      _shiftList = ['Morning', 'Afternoon', 'Night'];
      shiftVal = 'Morning';
    } else {
      _isEmptyValue = _isEmptyValue && false;
      for (var shift in shifts) {
        // print('👉 Shift: $shift');
        var dayName = shift.split(',')[0];
        // var startTime = shift.split(',')[1];
        // var endTime = shift.split(',')[2];
        _shiftList.add(dayName);
      }
      shiftVal = await Utils.getShiftName();
    }

    _reloadStockIns();
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
                      _pendingListView = _pendingList.where((el) => el.shift == shiftVal).toList();
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
                      initPendingTable();
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
          sortColumnIndex: _currentSortColumn,
          sortAscending: _isAscending,
          columns: <DataColumn>[
            DataColumn(
              label: const Expanded(
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
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemB.date.compareTo(itemA.date));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemA.date.compareTo(itemB.date));
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                'Machine:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: style.Colors.mainGrey,
                ),
              ),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemB.machine.compareTo(itemA.machine));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemA.machine.compareTo(itemB.machine));
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                'Shift:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemB.shift.compareTo(itemA.shift));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemA.shift.compareTo(itemB.shift));
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                'Pending:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
                textAlign: TextAlign.center,
              ),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemB.pending.compareTo(itemA.pending));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemA.pending.compareTo(itemB.pending));
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                'In:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: style.Colors.mainGrey,
                ),
              ),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemB.stockIn.compareTo(itemA.stockIn));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    _pendingListView.sort((itemA, itemB) =>
                        itemA.stockIn.compareTo(itemB.stockIn));
                  }
                });
              },
            ),
          ],
          rows: _pendingListView.map((row) => DataRow(
            cells: [
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
