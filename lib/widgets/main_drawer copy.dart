import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../screens/home.dart';
import '../screens/pending_list.dart';
import '../screens/production_in.dart';
import '../screens/stock_check.dart';
import '../screens/stock_in.dart';



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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: const Color(0xFFFEF08A),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.grey[700],
                ),
              ),
            ),
            buildListTile(
              'Home', 
              EvaIcons.home,
              () {
                Navigator.pop(context);
                // WidgetsBinding.instance!.addPostFrameCallback((_) {
                //   Navigator.pushNamed(context, HomeScreen.routeName);
                // });
              }
            ),

            const Divider(height: 15.0,color: Colors.black87,),
            
            const SizedBox(height:  10),

            buildListTile(
              'Pending List', 
              EvaIcons.carOutline,
              () {
                // Navigator.pushNamed(context, PendingListScreen.routeName);
              }
            ),          

            buildListTile(
              'Production In', 
              EvaIcons.settings2Outline,
              () {
                // Navigator.pushNamed(context, ProductionInScreen.routeName);
              }
            ),

            const Divider(height: 15.0,color: Colors.black87,),

            buildListTile(
              'Stock Check', 
              EvaIcons.syncOutline,
              () {
                // Navigator.pushNamed(context, StockCheckScreen.routeName);
              }  
            ),
            const Divider(height: 15.0,color: Colors.black87,),

            buildListTile(
              'Stock In', 
              EvaIcons.syncOutline,
              () {
                // Navigator.pushNamed(context, StockInScreen.routeName);
              }  
            )
          ],
        ),
      ),
    );
  }
}
