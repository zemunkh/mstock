import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../screens/maintenance.dart';
import '../screens/pending_list.dart';
import 'production.dart';
import '../screens/stock_check.dart';
import '../screens/stock_in.dart';
import '../widgets/main_drawer.dart';
import '../styles/theme.dart' as style;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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


  Widget boxMenuItem(String image, String title) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.all(16),
      decoration: style.Colors.menuBoxDecor,
      child: Stack(
        children: [
          Center(
            child: Image.asset("assets/icons/$image.png", width: 100.0),
          ),
          Container(
            margin: const EdgeInsets.only(top: 130),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: style.Colors.mainAppBar,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Stock Control',
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
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          InkWell(
            splashColor: style.Colors.mainBlue,
            child: boxMenuItem('warehouse', 'Production'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductionScreen()));
              });
            },
          ),
          InkWell(
            splashColor: style.Colors.mainBlue,
            child: boxMenuItem('scale', 'Check code'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StockCheckScreen()));
              });
            },
          ),
          InkWell(
            splashColor: style.Colors.mainBlue,
            child: boxMenuItem('expired', 'Pending'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PendingListScreen()));
              });
            },
          ),
          InkWell(
            splashColor: style.Colors.mainBlue,
            child: boxMenuItem('box', 'Stock In'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StockInScreen()));
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => MaintenanceScreen()));
          });
        },
        icon: Icon(Icons.hail_rounded),
        label: Text("Maintenance"),
      ),
    );
  }
}
