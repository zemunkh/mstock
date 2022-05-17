import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../widgets/main_drawer.dart';
import '../styles/theme.dart' as style;

class ProductionInScreen extends StatefulWidget {
  static const routeName = '/production-in';
  const ProductionInScreen({ Key? key }) : super(key: key);

  @override
  State<ProductionInScreen> createState() => _ProductionInScreenState();
}

class _ProductionInScreenState extends State<ProductionInScreen> {
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
              EvaIcons.menu2Outline,
            ),
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: const Text(
            'Production in',
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
        child: Center(
          child: Text('Production In')
        ),
      ),
    );
  }
}