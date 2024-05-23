import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade400,
    primary: Colors.white,
    secondary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black,fontSize: 25),
    iconTheme: IconThemeData(color: Colors.black),
  ),
);


ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.black,
    secondary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white,fontSize: 25),
    // toolbarHeight: 80,
    // titleSpacing: 20,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
