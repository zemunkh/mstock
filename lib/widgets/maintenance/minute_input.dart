import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;


class MinuteInput extends StatefulWidget {
  const MinuteInput({ Key? key }) : super(key: key);

  @override
  State<MinuteInput> createState() => _MinuteInputState();
}

class _MinuteInputState extends State<MinuteInput> {
  final _delayController = TextEditingController(text: '15');
  final FocusNode _delayNode = FocusNode();
  final _delayFormKey = GlobalKey<FormFieldState>();

  Future initSettings() async {
    _delayController.text = await FileManager.readString('scan_delay');
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
                        Utils.openDialogPanel(context, 'close', 'Oops!', 'Value is not in range', 'Try again');
                      } else {
                        // Save it to the scan_delay on shared_preference
                        FileManager.saveString('scan_delay', _delayController.text.trim());
                        Utils.openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
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

    return _minuteInput(context);
  }
}