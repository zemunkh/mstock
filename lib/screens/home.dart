import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:mstock/screens/maintenance.dart';
import '../screens/pending_list.dart';
import '../screens/production_in.dart';
import '../screens/stock_check.dart';
import '../screens/stock_in.dart';
import '../widgets/main_drawer.dart';
import '../styles/theme.dart' as style;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({ Key? key }) : super(key: key);

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

  Future _backButtonPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit the Stock App?"),
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
              onPressed: () {

              },
            )
          ],
        ),
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StockCheckScreen()));
                  });
                }, 
                child: const Text(
                  'Stock Check',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: style.Colors.button1,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductionInScreen()));
                  });
                }, 
                child: const Text(
                  'Production In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                primary: style.Colors.button2,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PendingListScreen()));
                  });
                }, 
                child: const Text(
                  'Pending List',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                primary: style.Colors.button3,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StockInScreen()));
                  });
                }, 
                child: const Text(
                  'Stock In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ), 
                ),
                style: ElevatedButton.styleFrom(
                primary: style.Colors.button4,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MaintenanceScreen()));
          });
        },
        icon: Icon(Icons.settings),
        label: Text("Maintenance"),
      ),
    );
  }
}