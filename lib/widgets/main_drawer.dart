import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:path/path.dart';
import '../screens/home.dart';
import '../screens/pending_list.dart';
import '../screens/production.dart';
import '../screens/stock_check.dart';
import '../screens/stock_in.dart';
import '../styles/theme.dart' as style;



class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);
  Widget buildListTile(String title, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tabHandler(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              color: style.Colors.mainAppBar,
              child: Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.grey[200],
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                EvaIcons.home,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('RouteName: 👉 ${route.settings.name}');
                  if (route.settings.name == HomeScreen.routeName) {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                const settings = RouteSettings(
                  name: HomeScreen.routeName
                );
                print('Route: 👉 $isNewRouteSameAsCurrent');
                if(!isNewRouteSameAsCurrent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(settings: settings, builder:  (_) => HomeScreen()));
                  });
                }
              },
            ),  

            const Divider(height: 15.0,color: Colors.black87,),

            ListTile(
              leading: const Icon(
                EvaIcons.checkmarkCircle,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Check Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('RouteName: 👉 ${route.settings.name}');
                  if (route.settings.name == StockCheckScreen.routeName) {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                print('Route: 👉 $isNewRouteSameAsCurrent');
                const settings = RouteSettings(
                  name: StockCheckScreen.routeName
                );
                if(!isNewRouteSameAsCurrent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(settings: settings, builder: (_) => StockCheckScreen()));
                  });                  
                }
              },
            ),      

            ListTile(
              leading: const Icon(
                EvaIcons.downloadOutline,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Production',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('RouteName: 👉 ${route.settings.name}');
                  if (route.settings.name == ProductionScreen.routeName) {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                const settings = RouteSettings(
                  name: ProductionScreen.routeName
                );
                if(!isNewRouteSameAsCurrent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(settings: settings, builder:  (_) => ProductionScreen()));
                  });
                }
              },
            ),

            ListTile(
              leading: const Icon(
                EvaIcons.clockOutline,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Pending List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('RouteName: 👉 ${route.settings.name}');
                  if (route.settings.name == PendingListScreen.routeName) {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                const settings = RouteSettings(
                  name: PendingListScreen.routeName
                );
                if(!isNewRouteSameAsCurrent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(settings: settings, builder:  (_) => PendingListScreen()));
                  });
                }
              },
            ), 

            ListTile(
              leading: const Icon(
                EvaIcons.cubeOutline,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Stock In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('RouteName: 👉 ${route.settings.name}');
                  if (route.settings.name == StockInScreen.routeName) {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                const settings = RouteSettings(
                  name: StockInScreen.routeName
                );
                if(!isNewRouteSameAsCurrent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(settings: settings, builder:  (_) => StockInScreen()));
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}