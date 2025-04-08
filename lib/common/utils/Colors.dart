import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 210, 10, 10);
  static const Color secondaryColor = Color(0xFF18375D);
  //primaryswatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFD20A0A, // Base color (converted from Color.fromARGB(255, 210, 10, 10))
    <int, Color>{
      50: Color(0xFFFFE5E5), // Lightest shade
      100: Color(0xFFFCCCCC),
      200: Color(0xFFF99999),
      300: Color(0xFFF66666),
      400: Color(0xFFF33333),
      500: Color(0xFFD20A0A), // Main color (same as base)
      600: Color(0xFFB20808),
      700: Color(0xFF920606),
      800: Color(0xFF720404),
      900: Color(0xFF520303), // Darkest shade
    },
  );
}
