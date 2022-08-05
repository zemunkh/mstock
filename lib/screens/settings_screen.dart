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

  final _qneIpAddressController =  TextEditingController();
  final _qnePortNumController =  TextEditingController();
  final _cipAddressController =  TextEditingController();
  final _cPortNumController =  TextEditingController();
  final _companyController =  TextEditingController();
  final _locationController =  TextEditingController();
  final _docPrefixController =  TextEditingController();

  final FocusNode _qneIpNode =  FocusNode();
  final FocusNode _qnePortNode =  FocusNode();
  final FocusNode _cipNode =  FocusNode();
  final FocusNode _cPortNode =  FocusNode();

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
    _qneIpAddressController.text = await FileManager.readString('qne_ip_address');
    _qnePortNumController.text = await FileManager.readString('qne_port_number');
    _cipAddressController.text = await FileManager.readString('counter_ip_address');
    _cPortNumController.text = await FileManager.readString('counter_port_number');
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
            String qneIp = _qneIpAddressController.text.trim();
            String qnePort = _qnePortNumController.text.trim();
            String cip = _cipAddressController.text.trim();
            String cPort = _cPortNumController.text.trim();
            String company = _companyController.text.trim();
            String location = _locationController.text.trim();
            String docPrefix = _docPrefixController.text.trim();
            if(qneIp != '' && qnePort != '' && validator.ip(qneIp)) {
              FileManager.saveString('qne_ip_address', qneIp).then((_){
                FileManager.saveString('qne_port_number', qnePort);
              });
              if(cip != '' && cPort != '' && validator.ip(cip)) {
                FileManager.saveString('counter_ip_address', cip).then((_){
                  FileManager.saveString('counter_port_number', cPort);
                  FileManager.saveString('company_name', company);
                  FileManager.saveString('location', location);
                  FileManager.saveString('doc_prefix', docPrefix);
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:  Text("✅ Saved successfully!", textAlign: TextAlign.center,),
                  duration: Duration(milliseconds: 2000)
                ));
              } else {
                // Input values are empty
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:  Text(validator.ip(qneIp) ? "Counter IP address is not okay!" : "Can't be saved!", textAlign: TextAlign.center,),
                  duration: const Duration(milliseconds: 3000)
                ));
              }
            } else {
              // Input values are empty
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:  Text(validator.ip(qneIp) ? "QNE IP address is not okay!" : "Can't be saved!", textAlign: TextAlign.center,),
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
        height: 580,
        width: 400,
        child: child,
      );
    }

    final transaction = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 15,),
        _mainInput('QNE IP',_qneIpAddressController, _qneIpNode),
        _mainInput('QNE Port', _qnePortNumController, _qnePortNode),
        const Divider(height: 15.0,color: Colors.black87,),
        _mainInput('Counter IP',_cipAddressController, _cipNode),
        _mainInput('Counter Port', _cPortNumController, _cPortNode),
        const Divider(height: 15.0,color: Colors.black87,),
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
            child: SingleChildScrollView(
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
