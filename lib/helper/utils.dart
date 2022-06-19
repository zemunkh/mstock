import 'dart:async';

import 'package:flutter/material.dart';
import '../styles/theme.dart' as style;

class Utils {

  static bool isOverlapped(int s1, int e1, int s2, int e2) {
    if((s2 > s1 && s2 < e1) || (e2 > s1 && e2 < e1)) {
      return true;
    } else {
      return false;
    }
  }

  static Future openDialogPanel(BuildContext context, String img, String title, String msg, String btnText) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              Image.asset("assets/icons/$img.png", width: 45.0),
              const SizedBox(height: 20.0),
              Text(title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: style.Colors.mainGrey)),
              const SizedBox(height: 20.0),
              Text('$msg.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent, )),
              const SizedBox(height: 30.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                },
              )
            ],
          ),
        );
      }
    );
  }

  static Future openDownloadingPanel(BuildContext context, String img, String title, String msg, String btnText) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              const CircularProgressIndicator(),
              const SizedBox(height: 20.0),
              Text(title, style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, color: style.Colors.mainGrey)),
              const SizedBox(height: 20.0),
              Text('$msg.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: style.Colors.mainAccent, )),
              const SizedBox(height: 30.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(style.Colors.mainAccent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))
                ),
                child: Text(btnText, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white)),
                onPressed: (){
                  Timer(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                },
              )
            ],
          ),
        );
      }
    );
  } 

}