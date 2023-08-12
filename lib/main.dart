import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/maintenance.dart';
import './screens/home.dart';
import './screens/stock_check.dart';
import 'screens/production.dart';
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
        '/': (ctx) => activated ? const HomeScreen() : ActivationScreen(),
        // '/': (ctx) => const HomeScreen(),
        StockCheckScreen.routeName: (ctx) => const StockCheckScreen(),
        StockInScreen.routeName: (ctx) => const StockInScreen(),
        ProductionScreen.routeName: (ctx) => const ProductionScreen(),
        PendingListScreen.routeName: (ctx) => const PendingListScreen(),
        MaintenanceScreen.routeName: (ctx) => const MaintenanceScreen(),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          settings: const RouteSettings(name: HomeScreen.routeName), builder: (ctx) => const HomeScreen(),
        );
      },
    );
  }
}

_read() async {
  final prefs = await SharedPreferences.getInstance();
  const key = 'my_activation_status';
  final status = prefs.getBool(key) ?? false;
  print('Activation Status: $status');
  // activated = status;
  return status;
}