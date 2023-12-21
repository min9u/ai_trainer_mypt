import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color dark_grey = Color.fromARGB(255, 24, 29, 36);
  static const Color black = Colors.black;
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    // headline5: headline,
    // headline6: title,
    // subtitle2: subtitle,
    // bodyText2: body2,
    // bodyText1: body1,
    // caption: caption,
  );

  static const display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: black,
  );
}