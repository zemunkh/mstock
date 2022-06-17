import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
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

  final FocusNode _ipNode =  FocusNode();
  final FocusNode _portNode =  FocusNode();
  final FocusNode _compNode =  FocusNode();
  final FocusNode _locNode =  FocusNode();

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the Stock App?"),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
          ElevatedButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      )
    );
    return true;
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
              style: TextStyle(
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
              child: Container(
                height: 40,
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF004B83),
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: header,
                    hintStyle: TextStyle(
                      color: Color(0xFF004B83),
                      fontWeight: FontWeight.w200,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.yellowAccent,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(EvaIcons.close,
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
        padding: const EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: () {
            print('You pressed Save!');
            List<String> _descripts = [];
            String ip = _ipAddressController.text.trim();
            String port = _portNumController.text.trim();
            String company = _companyController.text.trim();
            String location = _locationController.text.trim();
            if(ip != '' && port != '') {
              FileManager.saveString('ip_address', ip).then((_){
                FileManager.saveString('port_number', port);
                FileManager.saveString('company_name', company);
                FileManager.saveString('location', location);
              });
              print('Saving now!');
            }
            else {
              print('Dismissing it now!');
              // Input values are empty
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:  Text("Can't be saved!", textAlign: TextAlign.center,),
                duration: Duration(milliseconds: 2000)
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
              fontSize: 16,
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF004B83),
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration.collapsed(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Description',
              hintStyle: TextStyle(
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
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if(constraints.maxHeight > constraints.maxWidth) {
                  return SingleChildScrollView(
                    child: transaction,
                  );
                } else {
                  return Center(
                    child: Container(
                      width: 450,
                      child: transaction,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
