import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorPalette {
  static const red = Colors.red;
  static const scaffoldColor = Color(0xFFFBFBFB);
  static const white = Color(0xFFF7F8FC);
  static const gray = MaterialColor(0xFFF2F2F2, {
    100: Color(0xFFD3D3D3),
    200: Color(0xFFC3C3C3),
    300: Color(0xFF6E6E6E),
    400: Color(0xFF494949),
    500: Color(0xFF656565),
    600: Color(0xFF555555),
    700: Color(0xFF929292),
    800: Color(0xFF808080),
    900: Color(0xFFD4D4D4),
  });
  static const green = MaterialColor(
    0xff43A95D,
    {
      100: Color(0xffDDE8E0),
      200: Color(0xffD9EEDF),
      300: Color(0xFFEEF7F0),
      500: Color(0xff43A95D),
      800: Color(0xff2D713E),
    },
  );
  static const blue = MaterialColor(
    0xff056B9C,
    {500: Color(0xff056B9C), 600: Color(0xFF0680BB), 800: Color(0xff04557D)},
  );
  static const yellow = MaterialColor(0xFFEDC24D, {
    // 300: Color(0xFFFFCF2B),
    500: Color(0xFFEDC24D),
  });
  static const black = Color(0xFF363740);
  static const black2 = Color(0xFF252525);
  static const pNoteBgColor = Color(0xFFF0F8F2);
  static const pNoteBodyTxtColor = Color(0xFF808080);
}

class LightMode {
  LightMode();
}

class DarkMode {
  DarkMode();
}
