import 'package:flutter/material.dart';
import './screens/maintenance.dart';
import './screens/home.dart';
import './screens/stock_check.dart';
import './screens/production_in.dart';
import './screens/pending_list.dart';
import './screens/stock_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (ctx) => const HomeScreen(),
        StockCheckScreen.routeName: (ctx) => const StockCheckScreen(),
        ProductionInScreen.routeName: (ctx) => const ProductionInScreen(),
        PendingListScreen.routeName: (ctx) => const PendingListScreen(),
        StockInScreen.routeName: (ctx) => const StockInScreen(),
        MaintenanceScreen.routeName: (ctx) => const MaintenanceScreen(),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        );
      },
    );
  }
}
