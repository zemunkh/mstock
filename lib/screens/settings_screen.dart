import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../widgets/main_drawer.dart';
import '../helper/file_manager.dart';
import '../styles/theme.dart' as Style;

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingScreen({Key? key}) : super(key: key);
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _ipAddressController =  TextEditingController();
  final _portNumController =  TextEditingController();
  final _companyController =  TextEditingController();
  final _locationController =  TextEditingController();
  final _docPrefixController =  TextEditingController();


  final FocusNode _ipNode =  FocusNode();
  final FocusNode _portNode =  FocusNode();
  final FocusNode _compNode =  FocusNode();
  final FocusNode _locNode =  FocusNode();
  final FocusNode _docPrefixNode =  FocusNode();

  bool lockEn = true;



  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

  Future<Null> _clearTextController(BuildContext context, TextEditingController _controller, FocusNode node) async {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _controller.clear();
      });
      FocusScope.of(context).requestFocus(node);
    });
  }

  Future setInitialValue() async {
    _ipAddressController.text = await FileManager.readString('ip_address');
    _portNumController.text = await FileManager.readString('port_number');
    _companyController.text = await FileManager.readString('company_name');
    _locationController.text = await FileManager.readString('location');
    _docPrefixController.text = await FileManager.readString('doc_prefix');
    List<String> parsed = [];
    // Initializing 8 types of description input models
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setInitialValue();
  }

  Future<bool> _backButtonPressed() async {
    final showPop = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Exit the Stock App?"),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
          ElevatedButton(
            child: Text('No'),
            onPressed: () =>  Navigator.pop(context, false),
          ),
        ],
      )
    );
    return showPop ?? false;
  }

  @override
  Widget build(BuildContext context) {

    Widget _mainInput(String header, TextEditingController _mainController, FocusNode _mainNode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              '$header:',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF004B83),
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF004B83),
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: header,
                    hintStyle: const TextStyle(
                      color: Color(0xFF004B83),
                      fontWeight: FontWeight.w200,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.yellowAccent,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(EvaIcons.close,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                      onPressed: () {
                        _clearTextController(context, _mainController, _mainNode);
                      },
                    ),
                  ),
                  autofocus: false,
                  autocorrect: false,
                  controller: _mainController,
                  focusNode: _mainNode,
                  onTap: () {
                    // _clearTextController(context, _mainController, _mainNode);
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }


    Widget _saveButton(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: MaterialButton(
          onPressed: () {
            String ip = _ipAddressController.text.trim();
            String port = _portNumController.text.trim();
            String company = _companyController.text.trim();
            String location = _locationController.text.trim();
            String docPrefix = _docPrefixController.text.trim();
            if(ip != '' && port != '' && validator.ip(ip)) {
              FileManager.saveString('ip_address', ip).then((_){
                FileManager.saveString('port_number', port);
                FileManager.saveString('company_name', company);
                FileManager.saveString('location', location);
                FileManager.saveString('doc_prefix', docPrefix);
              });
              print('Saving now!');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:  Text("✅ Saved successfully!", textAlign: TextAlign.center,),
                duration: Duration(milliseconds: 2000)
              ));
            } else {
              print('Dismissing it now!');
              // Input values are empty
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:  Text(validator.ip(ip) ? "IP address is not okay!" : "Can't be saved!", textAlign: TextAlign.center,),
                duration: const Duration(milliseconds: 3000)
              ));
            }
            // save operation by shared preference
          },
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'QuickSand',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          shape: StadiumBorder(),
          color: Colors.teal[400],
          splashColor: Colors.blue[100],
          height: 50,
          minWidth: 200,
          elevation: 2,
        )
      );
    }

    Widget _descriptionInput(BuildContext context, TextEditingController _controller, FocusNode __focusNode, index) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 25,
          child: TextFormField(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF004B83),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration.collapsed(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Description',
              hintStyle: const TextStyle(
                color: Color(0xFF004B83),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            autofocus: false,
            controller: _controller,
            focusNode: __focusNode,
            onTap: () {
              _focusNode(context, __focusNode);
              // _clearTextController(context, _controller, __focusNode);
            },
          ),
        ),
      );
    }

    Widget buildContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)
        ),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        height: 450,
        width: 400,
        child: child,
      );
    }

    final transaction = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _mainInput('IP address',_ipAddressController, _ipNode),
        _mainInput('Port Num', _portNumController, _portNode),
        _mainInput('Company', _companyController, _compNode),
        _mainInput('Location', _locationController, _locNode),
        _mainInput('Doc Prefix', _docPrefixController, _docPrefixNode),
        const SizedBox(height: 15,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             _saveButton(context),
          ],
        ),

      ],
    );

    return WillPopScope(
      onWillPop: _backButtonPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Style.Colors.mainAppBar,
        ),
        drawer: const MainDrawer(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus( FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              width: 450,
              child: transaction,
            ),
            // child: LayoutBuilder(
            //   builder: (BuildContext context, BoxConstraints constraints) {
            //     if(constraints.maxHeight > constraints.maxWidth) {
            //       return SingleChildScrollView(
            //         child: transaction,
            //       );
            //     } else {
            //       return Center(
            //         child: SizedBox(
            //           width: 450,
            //           child: transaction,
            //         ),
            //       );
            //     }
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
