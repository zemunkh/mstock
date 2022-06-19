import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;


class ShiftForm extends StatefulWidget {
  const ShiftForm({ Key? key }) : super(key: key);

  @override
  State<ShiftForm> createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
  List<String> _shiftList = [];
  static final _shiftFormKey = GlobalKey<FormFieldState>();
  final _shiftController = TextEditingController(text: 'Night');
  final FocusNode _shiftNode = FocusNode();

  DateTime startTimeSelected = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 0);
  DateTime endTimeSelected =   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 4, 0);
  DateFormat timeFormat = DateFormat("yyyy-MM-dd HH:mm");


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

  Future initSettings() async {
    _shiftList = await FileManager.readStringList('shift_list');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {

    Widget buildContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        height: 120,
        width: 400,
        child: child,
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
                    FocusScope.of(context).unfocus();
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
                          Utils.openDialogPanel(context, 'close', 'Oops!', 'Interval time must be more than 1 hour.', 'Try again');
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
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Shift start or ending time is already in there', 'Try again');
                                return;
                              }

                              if(dayName.contains(_shiftController.text.trim())) {
                                Utils.openDialogPanel(context, 'close', 'Oops!', 'Shift name is already in there', 'Try again');
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
                              Utils.openDialogPanel(context, 'close', 'Oops!', 'Shift interval is overlapped', 'Try again');
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


    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

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
  }
}