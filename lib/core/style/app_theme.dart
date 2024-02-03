import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/style/app_color.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: 'khmer-battambang',
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    primarySwatch: AppColor.primarySwatch,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.primary,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
      ),
      iconTheme: IconThemeData(color: AppColor.white),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        color: AppColor.darker,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        color: AppColor.darker,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        color: AppColor.darker,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        color: AppColor.darker,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      displayLarge: TextStyle(
        fontSize: 40,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppColor.labelColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColor.labelColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColor.textColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColor.darker,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColor.darker,
      ),
    ),
    scaffoldBackgroundColor: AppColor.appBgColor,
    cardColor: Colors.white,
    shadowColor: AppColor.shadowColor,
    dividerColor: Colors.grey.shade400,
    iconTheme: const IconThemeData(color: AppColor.darker),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.bottomBarColor,
    ),
  );

  /// NAME         SIZE  WEIGHT  SPACING
  /// headline1    96.0  light   -1.5
  /// headline2    60.0  light   -0.5
  /// headline3    48.0  regular  0.0
  /// headline4    34.0  regular  0.25
  /// headline5    24.0  regular  0.0
  /// headline6    20.0  medium   0.15
  /// subtitle1    16.0  regular  0.15
  /// subtitle2    14.0  medium   0.1
  /// body1        16.0  regular  0.5   (bodyText1)
  /// body2        14.0  regular  0.25  (bodyText2)
  /// button       14.0  medium   1.25
  /// caption      12.0  regular  0.4
  /// overline     10.0  regular  1.5
  ///
  static final darkTheme = ThemeData(
    fontFamily: 'khmer-battambang',
    brightness: Brightness.dark,
    primaryColor: AppColor.primary,
    primarySwatch: AppColor.primarySwatch,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1e1e1e),
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      shadowColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      displayLarge: TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.grey,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFF1e1e1e),
    shadowColor: Colors.grey,
    cardColor: const Color(0xFF333333),
    dividerColor: Colors.white30,
    iconTheme: const IconThemeData(color: Colors.white),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF333333),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: Colors.white),
      ),
    ),
  );
}
