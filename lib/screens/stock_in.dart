import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../widgets/stock_in.dart';
import '../widgets/main_drawer.dart';
import '../styles/theme.dart' as style;

class StockInScreen extends StatefulWidget {
  static const routeName = '/stock-in';
  const StockInScreen({Key? key}) : super(key: key);

  @override
  State<StockInScreen> createState() => _StockInScreenState();
}

class _StockInScreenState extends State<StockInScreen> {
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
            'Stock in',
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
              onPressed: () {},
            )
          ],
        ),
      ),
      drawer: const MainDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: StockIn(),
      ),
    );
  }
}
