import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../screens/home.dart';
import '../screens/pending_list.dart';
import '../screens/production_in.dart';
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
              color: style.Colors.mainYellow,
              child: Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.grey[700],
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
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                });
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
                'Stock Check',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StockCheckScreen()));
                });
              },
            ),      

            ListTile(
              leading: const Icon(
                EvaIcons.downloadOutline,
                size: 26,
                color: style.Colors.mainGrey,
              ),
              title: const Text(
                'Production In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductionInScreen()));
                });
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
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PendingListScreen()));
                });
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
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StockInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
