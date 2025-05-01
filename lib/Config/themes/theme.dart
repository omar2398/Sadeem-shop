import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF5775CD),
    useMaterial3: true,
    fontFamily: 'Lora',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Lora'),
      displayMedium: TextStyle(fontFamily: 'Lora'),
      displaySmall: TextStyle(fontFamily: 'Lora'),
      headlineLarge: TextStyle(fontFamily: 'Lora'),
      headlineMedium: TextStyle(fontFamily: 'Lora'),
      headlineSmall: TextStyle(fontFamily: 'Lora'),
      titleLarge: TextStyle(fontFamily: 'Lora'),
      titleMedium: TextStyle(fontFamily: 'Lora'),
      titleSmall: TextStyle(fontFamily: 'Lora'),
      bodyLarge: TextStyle(fontFamily: 'Lora'),
      bodyMedium: TextStyle(fontFamily: 'Lora'),
      bodySmall: TextStyle(fontFamily: 'Lora'),
      labelLarge: TextStyle(fontFamily: 'Lora'),
      labelMedium: TextStyle(fontFamily: 'Lora'),
      labelSmall: TextStyle(fontFamily: 'Lora'),
    ),
  );

  static ThemeData darkTheme = ThemeData(
      //@Todo: Add dark theme
      );
}
