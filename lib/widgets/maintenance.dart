import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../styles/theme.dart' as style;

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  final _delayController = TextEditingController(text: '15');
  final _machineController = TextEditingController(text: '4');
  final _shiftController = TextEditingController(text: 'Night');

  final List<String> _machineList = [];
  final List<String> _shiftList = [];
  final FocusNode _delayNode = FocusNode();
  final FocusNode _machineNode = FocusNode();
  final FocusNode _shiftNode = FocusNode();


  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

  final _delayFormKey = GlobalKey<FormFieldState>();
  final _machineFormKey = GlobalKey<FormFieldState>();
  final _shiftFormKey = GlobalKey<FormFieldState>();

  TimeRange result = TimeRange(
    startTime: const TimeOfDay(hour: 12, minute: 0),
    endTime: const TimeOfDay(hour: 18, minute: 0)
  );

  @override
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.now();
    Widget _minuteInput(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          children: <Widget>[
            const Expanded(
              flex: 6,
              child: Text(
                'Production Scan delay: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                key: _delayFormKey,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF004B83),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _delayController,
                focusNode: _delayNode,
                onEditingComplete: () {
                   print('Done: ${_delayController.text}');
                   if(int.parse(_delayController.text) > 60) {
                    setState(() {
                      _delayController.text = '15';
                    });
                   }
                }
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildMachineForm(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Text(
                'Machine:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                key: _machineFormKey,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF004B83),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.text,
                controller: _machineController,
                focusNode: _machineNode,
                onEditingComplete: () {
                   print('Done: ${_machineController.text}');
                   _machineNode.unfocus();
                }
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(_machineController.text.isNotEmpty) {
                        if(!_machineList.contains(_machineController.text.trim())) {
                          setState(() {
                            _machineList.insert(0, _machineController.text.trim());
                          });
                        }
                      }
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      primary: style.Colors.button4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _machineController.text = '';
                        _machineNode.unfocus();
                      });
                    },
                    child: const Icon(
                      EvaIcons.close,
                      size: 32,
                      color: style.Colors.button2,
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

    Widget buildTimeRangePicker(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(
              flex: 2,
              child: Text(
                'From',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: () async {
                  result = await showTimeRangePicker(
                    context: context,
                  );
                  setState(() {});
                  print("result " + result.toString());
                },
                child: Text(
                  '${result.startTime.hour.toString()}:${result.startTime.minute < 10 ?  '0' + result.startTime.minute.toString() : result.startTime.minute.toString()}',
                  style: const TextStyle(
                    color: style.Colors.mainAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: style.Colors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'To:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () async {
                  result = await showTimeRangePicker(
                    context: context,
                  );
                  setState(() {});
                  print("result " + result.toString());
                },
                child: Text(
                  '${result.endTime.hour.toString()}:${result.endTime.minute < 10 ?  '0' + result.endTime.minute.toString() : result.endTime.minute.toString()}',
                  style: const TextStyle(
                    color: style.Colors.mainAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: style.Colors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            )
          ]
        ),
      );
    }

    Widget buildShiftForm(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Text(
                'Shift:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: style.Colors.mainGrey,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                key: _shiftFormKey,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF004B83),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.text,
                controller: _shiftController,
                focusNode: _shiftNode,
                onEditingComplete: () {
                   print('Done: ${_shiftController.text}');
                   _shiftNode.unfocus();
                }
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(_shiftController.text.isNotEmpty) {
                        if(!_shiftList.contains(_shiftController.text.trim())) {
                          setState(() {
                            _shiftList.insert(0, 
                            '${_shiftController.text.trim()}, ${result.startTime.hour.toString()}:${result.startTime.minute < 10 ?  '0' + result.startTime.minute.toString() : result.endTime.minute.toString()} - ${result.endTime.hour.toString()}:${result.endTime.minute < 10 ?  '0' 
                            + result.endTime.minute.toString() : result.endTime.minute.toString()}');
                          });
                        }
                      }
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      primary: style.Colors.button4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _shiftController.text = '';
                        _shiftNode.unfocus();
                      });
                    },
                    child: const Icon(
                      EvaIcons.close,
                      size: 32,
                      color: style.Colors.button2,
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
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        height: 150,
        width: 400,
        child: child,
      );
    }

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _minuteInput(context),
          const Divider(
            height: 20.0,
            color: Colors.black87,
          ),

          buildMachineForm(context),

          buildContainer(
            Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _machineList.length,
                separatorBuilder: (BuildContext context, _) => Divider( color: Colors.black87,),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Text('${_machineList[index]}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _machineList.removeAt(index);
                              });
                            },
                            child: const Icon(
                              EvaIcons.trash,
                              size: 20,
                              color: style.Colors.button2,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: style.Colors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          buildShiftForm(context),

          buildTimeRangePicker(context),

          buildContainer(
            Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _shiftList.length,
                separatorBuilder: (BuildContext context, _) => Divider( color: Colors.black87,),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Text('${_shiftList[index]}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _shiftList.removeAt(index);
                              });
                            },
                            child: const Icon(
                              EvaIcons.trash,
                              size: 20,
                              color: style.Colors.button2,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: style.Colors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

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
            return Center(
              child: SingleChildScrollView(
                child: transaction,
              ),
            );
          }
        },
      ),
    );
  }
}
