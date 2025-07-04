import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: Colors.white
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: Colors.black
  );
}