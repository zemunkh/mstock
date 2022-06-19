import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../helper/utils.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;

class SupervisorPassword extends StatefulWidget {
  const SupervisorPassword({ Key? key }) : super(key: key);

  @override
  State<SupervisorPassword> createState() => _SupervisorPasswordState();
}

class _SupervisorPasswordState extends State<SupervisorPassword> {
  final _passwordController = TextEditingController(text: '1234');
  final FocusNode _passwordNode = FocusNode();
  static final _passwordFormKey = GlobalKey<FormFieldState>();

  Future initSettings() async {
    _passwordController.text = await FileManager.readString('supervisor_password');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
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
                  color: style.Colors.mainGrey,
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
                  FocusScope.of(context).unfocus();
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
                    if(_passwordController.text.length > 5) {
                      FileManager.saveString('supervisor_password', _passwordController.text.trim());
                      Utils.openDialogPanel(context, 'accept', 'Done!', 'Value is successfully saved!', 'Okay');
                    } else {
                      Utils.openDialogPanel(context, 'close', 'Oops!', 'Password must be more than 6 characters', 'Try again');
                      print('Must be more than 6 characters');
                    }
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

  @override
  Widget build(BuildContext context) {
    return _supervisorPasswordInput(context);
  }
}