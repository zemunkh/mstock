import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
import '../helper/utils.dart';
import '../helper/file_manager.dart';
import '../styles/theme.dart' as style;

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  final _delayController = TextEditingController(text: '15');
  final _machineController = TextEditingController(text: 'A1');
  final _shiftController = TextEditingController(text: 'Night');
  final _passwordController = TextEditingController(text: '1234');

  List<String> _machineList = [];
  List<String> _shiftList = [];
  final FocusNode _delayNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _machineNode = FocusNode();
  final FocusNode _shiftNode = FocusNode();


  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

  final _delayFormKey = GlobalKey<FormFieldState>();
  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _machineFormKey = GlobalKey<FormFieldState>();
  final _shiftFormKey = GlobalKey<FormFieldState>();

  DateTime startTimeSelected = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 0);
  DateTime endTimeSelected =   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 4, 0);
  DateFormat timeFormat = DateFormat("yyyy-MM-dd HH:mm");

  String statusText = 'Completed!';
  String lastUpdateTime = '16/06/2022 06:04 PM';

  void _openTimePickerSheet(BuildContext context, bool isStartTime, DateTime date) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        initialDateTime: date,
        sheetTitle: 'Select time',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Select',
        saveButtonColor: style.Colors.mainBlue,
        hourTitleStyle: const TextStyle(
          fontSize: 18,
          color: style.Colors.mainGrey,
          fontWeight: FontWeight.bold,
        ),
        minuteTitleStyle: const TextStyle(
          fontSize: 18,
          color: style.Colors.mainGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if(isStartTime) {
          startTimeSelected = result;
        } else {
          endTimeSelected = result;
        }
      });
    }
  }


  Future _openDialogPanel(BuildContext context, String img, String title, String msg, String btnText) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              Image.asset("assets/icons/$img.png", width: 45.0),
              const SizedBox(height: 20.0),
              Text(title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: style.Colors.mainGrey)),
              const SizedBox(height: 20.0),
              Text('$msg.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent, )),
              const SizedBox(height: 30.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
    );
  }

  Future initSettings() async {
    _delayController.text = await FileManager.readString('scan_delay');
    _passwordController.text = await FileManager.readString('supervisor_password');
    _machineList = await FileManager.readStringList('machine_line');
    _shiftList = await FileManager.readStringList('shift_list');
    print('Shift: $_shiftList');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    Widget _minuteInput(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: SizedBox(
          height: 32,
          child: Row(
            children: <Widget>[
              const Expanded(
                flex: 4,
                child: Text(
                  'Production Scan delay: ',
                  textAlign: TextAlign.left,
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
                    fontSize: 20,
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
                    _delayNode.unfocus();
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      if(int.parse(_delayController.text) > 60) {
                        setState(() {
                          _delayController.text = '15';
                        });
                        _openDialogPanel(context, 'close', 'Oops!', 'Value is not in range', 'Try again');
                      } else {
                        // Save it to the scan_delay on shared_preference
                        FileManager.saveString('scan_delay', _delayController.text.trim());
                        _openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
                      }
                    },
                    child: const Icon(
                      EvaIcons.saveOutline,
                      size: 28,
                      color: style.Colors.background,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: style.Colors.button3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget _supervisorPasswordInput(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: SizedBox(
          height: 32,
          child: Row(
            children: <Widget>[
              const Expanded(
                flex: 3,
                child: Text(
                  'Supervisor Password: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: TextFormField(
                  key: _passwordFormKey,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF004B83),
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  focusNode: _passwordNode,
                  onEditingComplete: () {
                     print('Done: ${_passwordController.text}');
                     if(_passwordController.text.length > 5) {
                      print('Okay cool');
                     } else {
                      _openDialogPanel(context, 'close', 'Oops!', 'Password must be more than 6 characters', 'Try again');
                      print('Must be more than 6 characters');
                     }
                     _passwordNode.unfocus();
                  }
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      // Save it to the supervisor_password on shared_preference
                      FileManager.saveString('supervisor_password', _passwordController.text.trim());
                      _openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
                      _passwordNode.unfocus();
                    },
                    child: const Icon(
                      EvaIcons.saveOutline,
                      size: 28,
                      color: style.Colors.background,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: style.Colors.button3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }


    Widget buildUpdateField(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    'Import StockCode & UOM:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: style.Colors.mainGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
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
                        child: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          primary: style.Colors.button4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: style.Colors.button4,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(''),
                ),
                const Expanded(
                  flex: 2,
                  child: Text('Last Update: '),
                ),
                Expanded(
                  flex: 5,
                  child: Text(lastUpdateTime,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: style.Colors.button4,
                    ),
                  ),
                ), 
              ],
            )
          ],
        ),
      );
    }

    Widget buildMachineForm(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: SizedBox(
          height: 32,
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
                child: Container(
                  height: 36,
                  child: TextFormField(
                    key: _machineFormKey,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
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
                            FileManager.saveList('machine_line', _machineList);
                          } else {
                            _openDialogPanel(context, 'close', 'Oops!', 'Value is already in there', 'Try again');
                          }
                        }
                        _machineNode.unfocus();
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
              child: ElevatedButton(
                onPressed: () => _openTimePickerSheet(context, true, startTimeSelected),
                child: Text(
                  DateFormat.Hm().format(startTimeSelected),
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
                textAlign: TextAlign.center,
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
                onPressed: () => _openTimePickerSheet(context, false, endTimeSelected),
                child: Text(
                DateFormat.Hm().format(endTimeSelected),
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
        child: SizedBox(
          height: 32,
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
                    fontSize: 20,
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
                        bool isOverlapped = false;
                        var selectedStartMin = (startTimeSelected.hour * 60) + startTimeSelected.minute;
                        var selectedEndMin = (endTimeSelected.hour * 60) + endTimeSelected.minute;
                        if((selectedEndMin - selectedStartMin).abs() < 60) {
                          _openDialogPanel(context, 'close', 'Oops!', 'Interval time must be more than 1 hour.', 'Try again');
                          return;
                        }

                        if(_shiftController.text.isNotEmpty) {
                          if(!_shiftList.contains(_shiftController.text.trim())) {
                            // ======== Check Time Range Overlaps for previously saved values =====
                            // Extract Shift Name and check its repetition
                            for (var shift in _shiftList) {
                              var dayName = shift.split(',')[0];
                              var startTime = shift.split(',')[1];
                              var endTime = shift.split(',')[2];
                              var startMin = int.parse(startTime.split(':')[0])*60 + int.parse(startTime.split(':')[1]);
                              var endMin = int.parse(endTime.split(':')[0])*60 + int.parse(endTime.split(':')[1]);

                              if(startMin == selectedStartMin || endMin == selectedEndMin) {
                                _openDialogPanel(context, 'close', 'Oops!', 'Shift start or ending time is already in there', 'Try again');
                                return;
                              }

                              if(dayName.contains(_shiftController.text.trim())) {
                                _openDialogPanel(context, 'close', 'Oops!', 'Shift name is already in there', 'Try again');
                                return;
                              }

                              print('Start min: $startMin, End min: $endMin');

                              if(startMin > endMin) {
                                // Elapsed preset intervals
                                print('Elapsed interval');
                                if(selectedStartMin > selectedEndMin) {
                                  // It is obvious that two intervals both elapses the day.
                                  isOverlapped = isOverlapped || true;
                                  print('Overlap is sure!');
                                } else {
                                  isOverlapped = isOverlapped || Utils.isOverlapped(startMin, 1440, selectedStartMin, selectedEndMin);
                                  isOverlapped = isOverlapped || Utils.isOverlapped(0, endMin, selectedStartMin, selectedEndMin);
                                  print('Overlap #1: $isOverlapped');
                                }
                              } else {
                                if(selectedStartMin > selectedEndMin) {
                                  isOverlapped = isOverlapped || Utils.isOverlapped(startMin, endMin, selectedStartMin, 1440);
                                  isOverlapped = isOverlapped || Utils.isOverlapped(startMin, endMin, 0, selectedEndMin);
                                  print('Overlap #2: $isOverlapped');
                                } else {
                                  isOverlapped = isOverlapped || Utils.isOverlapped(startMin, endMin, selectedStartMin, selectedEndMin);
                                  print('Overlap #3: $isOverlapped');
                                }
                              }
                            }

                            // If there is no overlap, save it on memory
                            if(!isOverlapped) {
                              setState(() {
                                _shiftList.insert(0, '${_shiftController.text.trim()}, ${DateFormat.Hm().format(startTimeSelected)}, ${DateFormat.Hm().format(endTimeSelected)}');
                              });
                            } else {
                              _openDialogPanel(context, 'close', 'Oops!', 'Shift interval is overlapped', 'Try again');
                              return;
                            }
                            FileManager.saveList('shift_list', _shiftList);
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
        height: 120,
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
                    height: 32,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Text(_machineList[index],
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
                                _machineList.removeAt(index);
                              });
                              FileManager.saveList('machine_line', _machineList);
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
                separatorBuilder: (BuildContext context, _) => const Divider( color: Colors.black87,),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 32,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Text('${_shiftList[index].split(',')[0]}    ${_shiftList[index].split(',')[1]} -${_shiftList[index].split(',')[2]}',
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
                              size: 16,
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

          const Divider(
            height: 20.0,
            color: Colors.black87,
          ),

          _supervisorPasswordInput(context),

          const Divider(
            height: 20.0,
            color: Colors.black87,
          ),

          buildUpdateField(context),

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
