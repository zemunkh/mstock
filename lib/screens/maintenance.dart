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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.background,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          elevation: 2.0,
          backgroundColor: const Color(0xFF0EA5E9),
          leading: IconButton(
            icon: const Icon(
              EvaIcons.arrowBack,
            ),
            color: Colors.white,
            onPressed: () {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    );
  }
}