import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../screens/home.dart';
import '../widgets/main_drawer.dart';
import '../widgets/maintenance.dart';
import '../styles/theme.dart' as style;


class MaintenanceScreen extends StatefulWidget {
  static const routeName = '/maintenance';
  const MaintenanceScreen({ Key? key }) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // MaintenanceScreen({Key? key}) : super(key: key);

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
    return WillPopScope(
      onWillPop: _backButtonPressed,
      child: Scaffold(
        backgroundColor: style.Colors.background,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            backgroundColor: style.Colors.mainDarkGrey,
            leading: IconButton(
              icon: const Icon(
                EvaIcons.arrowBack,
              ),
              color: Colors.white,
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                });
              },
            ),
            title: const Text(
              'Maintenance',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  EvaIcons.infoOutline,
                ),
                color: Colors.white,
                onPressed: () {
    
                },
              )
            ],
          ),
        ),
        drawer: const MainDrawer(),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Maintenance()
        ),
      ),
    );
  }
}