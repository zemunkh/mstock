import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../../widgets/main_drawer.dart';
import '../../helper/file_manager.dart';
import '../../styles/theme.dart' as style;

class StockInParams extends StatefulWidget {
  const StockInParams({Key? key}) : super(key: key);
  @override
  StockInParamsState createState() => StockInParamsState();
}

class StockInParamsState extends State<StockInParams> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _deviceController =  TextEditingController();
  final _qneIpAddressController =  TextEditingController();
  final _qnePortNumController =  TextEditingController();
  final _cipAddressController =  TextEditingController();
  final _cPortNumController =  TextEditingController();
  final _companyController =  TextEditingController();
  final _locationController =  TextEditingController();
  final _docPrefixController =  TextEditingController();

  final FocusNode _deviceNode =  FocusNode();
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

  Future _clearTextController(BuildContext context, TextEditingController _controller, FocusNode node) async {
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
    _deviceController.text = await FileManager.readString('device_name');
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
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
        child: SizedBox(
          height: 32,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  '$header:',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: style.Colors.mainGrey,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: TextFormField(
                  // key: _passwordFormKey,
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
                  controller: _mainController,
                  focusNode: _mainNode,
                ),
              ),
            ],
          ),
        ),
      );
    }


    Widget _saveButton(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: () {
            String device = _deviceController.text.trim();
            String qneIp = _qneIpAddressController.text.trim();
            String qnePort = _qnePortNumController.text.trim();
            String cip = _cipAddressController.text.trim();
            String cPort = _cPortNumController.text.trim();
            String company = _companyController.text.trim();
            String location = _locationController.text.trim();
            String docPrefix = _docPrefixController.text.trim();

            FileManager.saveString('counter_ip_address', cip).then((_){
              FileManager.saveString('counter_port_number', cPort);
              FileManager.saveString('device_name', device);
              FileManager.saveString('company_name', company);
              FileManager.saveString('location', location);
              FileManager.saveString('doc_prefix', docPrefix);
              FileManager.saveString('qne_ip_address', qneIp);
              FileManager.saveString('qne_port_number', qnePort);
            });

            if(qneIp != '' && qnePort != '') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:  Text("✅ Saved successfully!", textAlign: TextAlign.center,),
                duration: Duration(milliseconds: 2000)
              ));
            } else {
              // Input values are empty
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:  Text(!validator.ip(qneIp) ? "QNE IP address is not okay!" : "Can't be saved!", textAlign: TextAlign.center,),
                duration: const Duration(milliseconds: 3000)
              ));         
            }

            if(cip != '' && cPort != '' && validator.ip(cip)) {
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
            
            // save operation by shared preference
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                EvaIcons.saveOutline,
                size: 28,
                color: style.Colors.background,
              ),
              Text(
                'Save',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: style.Colors.button3,
            minimumSize: const Size.fromHeight(32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
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
        _mainInput('Device Name', _deviceController, _deviceNode),
        _mainInput('QNE IP',_qneIpAddressController, _qneIpNode),
        _mainInput('QNE Port', _qnePortNumController, _qnePortNode),
        const Divider(height: 15.0,color: Colors.black87,),
        _mainInput('Counter IP',_cipAddressController, _cipNode),
        _mainInput('Counter Port', _cPortNumController, _cPortNode),
        const Divider(height: 15.0,color: Colors.black87,),
        // _mainInput('Company', _companyController, _compNode),
        _mainInput('QnE Location Code', _locationController, _locNode),
        _mainInput('Stock INs Doc Prefix', _docPrefixController, _docPrefixNode),
        const SizedBox(height: 15,),


        _saveButton(context),

      ],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: SingleChildScrollView(
          child: transaction,
        ),
      ),
    );
  }
}
