import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';

// import '../helper/file_manager.dart';

class StockCheck extends StatefulWidget {
  @override
  StockCheckState createState() => StockCheckState();
}

class StockCheckState extends State<StockCheck> {
  final _masterController = TextEditingController();
  final _productController = TextEditingController();

  final FocusNode _masterNode = FocusNode();
  final FocusNode _productNode = FocusNode();

  // final _formKey = GlobalKey<FormFieldState>();

  bool matched = true;
  bool oneToMany = true;
  var counter = 0;

  // String deviceName;
  // String userName;

  Future _compareData() async {
    final masterCode = _masterController.text;
    final productCode = _productController.text;

    // userName = await FileManager.readProfile('user_name');
    // deviceName = await FileManager.readProfile('device_name');

    print('Comparison: $masterCode : $productCode');

    setState(() {
      if (masterCode == productCode) {
        matched = true;
        counter++;
      } else {
        matched = false;
      }
      // FileManager.saveScanData(masterCode, productCode, counter, matched, DateTime.now(), userName, deviceName);
    });
  }

  Future _enableOneToMany(bool isOn) async {
    setState(() {
      oneToMany = isOn;
      isOn = !isOn;
      _masterController.clear();
      _productController.clear();
      counter = 0;
    });
    print('Switch button value $oneToMany');
  }

  String buffer = '';
  String trueVal = '';

  Future masterListener() async {
    print('Current text: ${_masterController.text}');
    buffer = _masterController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;
      _masterNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _masterController.text = trueVal;
        });
        FocusScope.of(context).requestFocus(_productNode);
      });
    }
  }

  Future productListener() async {
    buffer = _productController.text;
    if (buffer.endsWith(r'$')) {
      buffer = buffer.substring(0, buffer.length - 1);
      trueVal = buffer;

      await Future.delayed(const Duration(milliseconds: 1000), () {
        _productController.text = trueVal;
      }).then((value) {
        _compareData();
        if (oneToMany) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _productController.clear();
          });
        } else {
          _productNode.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
        }
      });
    }
  }

  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

  Future _clearTextController(BuildContext context,
      TextEditingController _controller, FocusNode node) async {
    setState(() {
      _controller.clear();
      if (oneToMany || (_controller == _masterController)) {
        counter = 0;
      }
    });

    FocusScope.of(context).requestFocus(node);
  }

  @override
  void dispose() {
    super.dispose();
    _masterController.dispose();
    _productController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _masterController.addListener(masterListener);
    _productController.addListener(productListener);
  }

  @override
  Widget build(BuildContext context) {
    // To hide keyboards on the restart.
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    Widget _titleWidget(String title) {
      return Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      );
    }

    Widget _scannerInput(String hintext, TextEditingController _controller,
        FocusNode currentNode) {
      return Stack(
        alignment: const Alignment(1.0, 1.0),
        children: <Widget>[
          TextFormField(
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF004B83),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintext,
              hintStyle: const TextStyle(
                color: Color(0xFF004B83),
                fontWeight: FontWeight.w200,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            // autofocus: false,
            controller: _controller,
            focusNode: currentNode,
            onTap: () {
              _focusNode(context, currentNode);
            },
          ),
          ElevatedButton(
            onPressed: () {
              _clearTextController(context, _controller, currentNode);
              if (_controller == _masterController) {
                _productController.clear();
              }
            },
            child: const SizedBox(
              height: 66,
              child: Icon(
                EvaIcons.refresh,
                color: Color(0xFF004B83),
                size: 30,
              ),
            ),
          ),
        ],
      );
    }

    final switchButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.scale(
              scale: 1.5,
              child: Switch(
                value: oneToMany,
                activeColor: Colors.blueAccent,
                onChanged: (isOn) {
                  _enableOneToMany(isOn);
                },
              ),
            ),
            Text('One to Many'),
          ],
        ),
      ],
    );

    final statusBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: matched
              ? const Icon(
                  EvaIcons.checkmarkCircle2Outline,
                  size: 80,
                  color: Colors.green,
                )
              : const Icon(
                  EvaIcons.closeCircleOutline,
                  size: 80,
                  color: Colors.red,
                ),
        ),
        Container(
          child: switchButton,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(width: 1, color: Colors.black),
            ),
          ),
          child: Center(
            child: Text(
              counter.toString(),
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          statusBar,
          _titleWidget('Barcode #1'),
          const SizedBox(
            height: 10,
          ),
          _scannerInput(
            'Master key',
            _masterController,
            _masterNode,
          ),
          _titleWidget('Barcode #2'),
          const SizedBox(
            height: 10,
          ),
          _scannerInput(
            'Product key',
            _productController,
            _productNode,
          ),
        ],
      ),
    );
  }
}
