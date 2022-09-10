import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../styles/theme.dart' as style;



class ActivationScreen extends StatelessWidget {
  final _activationController = TextEditingController();
  final FocusNode _activationNode = FocusNode();
  var onTapRecognizer;
  // StreamController<ErrorAnimationType> _errorController ;

  Future _activationHandler(BuildContext context, TextEditingController _controller) async {
    String inputText = _controller.text;
    const int adder = 53127429; // has to change
    String currentDate = DateFormat("yyyyMMdd").format(DateTime.now());
    print('Date: $currentDate');
    int activationCode = adder + int.parse(currentDate);
    print('Code: ${activationCode.toString()}');
    if(activationCode.toString() == inputText) {
      _activate().then((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    } else {
      print('Unsuccessful!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _activationInput(String labelText, TextEditingController _controller, FocusNode currentNode) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          alignment: const Alignment(1.0, 1.0),
          children: <Widget>[
            SizedBox(
              width: 440,
              child: PinCodeTextField(
                appContext: context,
                controller: _activationController,
                // errorAnimationController: _errorController,
                keyboardType: TextInputType.number,
                length: 8,
                onChanged: (value) {
                  print(value);

                },
                obscureText: false,
                obscuringCharacter: '*',
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveColor: style.Colors.mainAccent,
                  borderWidth: 3.5,
                ),
              ),
            ),
          ],
        ),
      );
    }


    final logoStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.grey[700],
      fontSize: 36.0,
    );

    final logo = Card(
      elevation: 0,
      color: style.Colors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/icons/box.png'),
          Padding(  
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Production\nStock-In\nSystem',
              style: logoStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
    final button = InkWell(
      splashColor: style.Colors.background,
      onTap: (){
        _activationHandler(context, _activationController);
      },
      child: Ink(
          height: 60.0,
          width: size.width - 60,
          decoration: const BoxDecoration(
            color: Color(0xFF653bbf),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: const Center(
            child: Text('Activate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24.0)),
          )
      ),
    );

    final mainView = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        logo,
        Padding(
          padding: const EdgeInsets.all(10),
          child: _activationInput('Activation input', _activationController, _activationNode),
        ),        
        button,
      ], 
    );  

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Others Page'),
      // ),
      backgroundColor: style.Colors.background,
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: mainView,
        ),
      ),
    );
  }

  _activate() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'my_activation_status';
    prefs.setBool(key, true);
    print('Activated successfully!');
  }
}