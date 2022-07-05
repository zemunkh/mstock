import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/maintenance.dart';
import './screens/home.dart';
import './screens/stock_check.dart';
import './screens/production_in.dart';
import './screens/pending_list.dart';
import './screens/stock_in.dart';
import './screens/activation_screen.dart';


bool activated = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    activated = await _read();
    runApp(const MyApp());
  } catch(error) {
    print('Activation Status error: $error');
  }
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
        // '/': (ctx) => activated ? const HomeScreen() : ActivationScreen(),
        '/': (ctx) => const ProductionInScreen(),
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

_read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'my_activation_status';
  final status = prefs.getBool(key) ?? false;
  print('Activation Status: $status');
  // activated = status;
  return status;
}