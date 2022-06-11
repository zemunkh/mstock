import 'dart:ui';

import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color mainColor = Color(0xFFFF2D55);
  static const Color background = Color(0xFFFFFEE5);
  static const Color mainYellow = Color(0xFFFEF08A);
  static const Color mainBlue = Color(0xFF0EA5E9);
  static const Color mainGrey = Color(0xFF5670A1);
  static const Color mainDarkGrey = Color(0xff7c94b6);
  static const Color mainAppBar = Color(0xFF164CA2);

  static const Color button1 = Color(0xFFfcbe2b);
  static const Color button2 = Color(0xFFad3d5b);
  static const Color button3 = Color(0xFF4487FC);
  static const Color button4 = Color(0xFF439e86);

  static const BoxDecoration menuBoxDecor = BoxDecoration(
    color: Color(0xFFFFFFF5),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10)
    ),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 208, 216, 228),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}
