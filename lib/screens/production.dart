import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../../helper/utils.dart';
import '../widgets/main_drawer.dart';
import '../widgets/production.dart';
import '../styles/theme.dart' as style;

class ProductionScreen extends StatefulWidget {
  static const routeName = '/production';
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _shiftList = [];
  String shiftValue = '';

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

  Future initSettings() async {
    shiftValue = await Utils.getShiftName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.now();

    return WillPopScope(
      onWillPop: _backButtonPressed,
      child: Scaffold(
        backgroundColor: style.Colors.background,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            backgroundColor: style.Colors.mainAppBar,
            leading: IconButton(
              icon: const Icon(
                EvaIcons.menu2Outline,
              ),
              color: Colors.white,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            title: const Text(
              'Production',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("yyyy/MM/dd HH:mm").format(createdDate),
                        style: const TextStyle(
                          color: style.Colors.mainRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: style.Colors.mainDarkGrey,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Text(shiftValue),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        drawer: const MainDrawer(),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Production(),
        ),
      ),
    );
  }
}
