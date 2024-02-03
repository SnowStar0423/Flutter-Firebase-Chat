import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF8f91f5);
  static const secondary = Color(0xFFe54140);

  static const mainColor = Color(0xFF000000);
  static const darker = Color(0xFF3E4249);
  static const cardColor = Colors.white;
  static const appBgColor = Color(0xFFF7F7F7);
  static const appBarColor = Color(0xFFF7F7F7);
  static const bottomBarColor = Colors.white;
  static const inActiveColor = Colors.grey;
  static const shadowColor = Colors.black87;
  static const textBoxColor = Colors.white;
  static const textColor = Color(0xFF333333);
  static const glassTextColor = Colors.white;
  static const labelColor = Color(0xFF8A8989);
  static const glassLabelColor = Colors.white;
  static const actionColor = Color(0xFFe54140);

  static const yellow = Color(0xFFffcb66);
  static const green = Color(0xFFa2e1a6);
  static const pink = Color(0xFFf5bde8);
  static const purple = Color(0xFFcdacf9);
  static const red = Color(0xFFf77080);
  static const orange = Color(0xFFf5ba92);
  static const sky = Color(0xFFABDEE6);
  static const blue = Color(0xFF509BE4);
  static const white = Colors.white;
  static const grey = Colors.grey;

  static MaterialColor primarySwatch = MaterialColor(
    AppColor.primary.value,
    const <int, Color>{
      50: AppColor.primary,
      100: AppColor.primary,
      200: AppColor.primary,
      300: AppColor.primary,
      400: AppColor.primary,
      500: AppColor.primary,
      600: AppColor.primary,
      700: AppColor.primary,
      800: AppColor.primary,
      900: AppColor.primary,
    },
  );
}
