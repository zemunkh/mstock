import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;

class MachineList extends StatefulWidget {
  const MachineList({ Key? key }) : super(key: key);

  @override
  State<MachineList> createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
  final _machineController = TextEditingController(text: 'A1');
  List<String> _machineList = [];
  final FocusNode _machineNode = FocusNode();
  static final _machineFormKey = GlobalKey<FormFieldState>();

  Future initSettings() async {
    _machineList = await FileManager.readStringList('machine_line');
    setState(() {});
  }

  @override
  void initState() {
    initSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                child: SizedBox(
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
                      FocusScope.of(context).unfocus();
                    },
                    onTap: () => _machineController.clear(),
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
                              _machineController.text = '';
                            });
                            FileManager.saveList('machine_line', _machineList);
                          } else {
                            Utils.openDialogPanel(context, 'close', 'Oops!', 'Value is already in there', 'Try again');
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

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ]
      )
    );
  }
}