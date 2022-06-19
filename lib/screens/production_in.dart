import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../widgets/main_drawer.dart';
import '../widgets/production.dart';
import '../styles/theme.dart' as style;

class ProductionInScreen extends StatefulWidget {
  static const routeName = '/production-in';
  const ProductionInScreen({Key? key}) : super(key: key);

  @override
  State<ProductionInScreen> createState() => _ProductionInScreenState();
}

class _ProductionInScreenState extends State<ProductionInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                onPressed: () {},
              )
            ],
          ),
        ),
        drawer: const MainDrawer(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Production(),
        ),
      ),
    );
  }
}
