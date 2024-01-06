import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // for Color
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  // for Text
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color greyText = Color.fromARGB(255, 121, 125, 126);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color.fromARGB(255, 246, 250, 253);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Pretendard';

  static ThemeData myAppTheme = ThemeData(
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith((state) {
          if (state.contains(MaterialState.selected)) {
            return const TextStyle(
                color: Color.fromRGBO(80, 195, 134, 1),
                fontWeight: FontWeight.w400);
          }
          return const TextStyle(color: darkText, fontWeight: FontWeight.w400);
        }),
      ),
      fontFamily: fontName);

  static const TextTheme textTheme = TextTheme(
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyMedium: bodyMedium,
      bodyLarge: bodyLarge,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelSmall: labelSmall);

  static const TextStyle whiteHeadline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 0.27,
    color: white,
  );

  static const TextStyle whiteTitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.27,
    color: white,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 0.27,
    color: darkText,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 22,
    letterSpacing: 0.24,
    height: 1.3,
    color: darkerText,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 0.22,
    color: darkerText,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.20,
    color: darkText,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 0.22,
    color: darkText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0,
    color: greyText,
  );
}
