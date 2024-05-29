import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,

  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStateProperty.all(Colors.white) ,
  ),
  colorScheme: ColorScheme.light(
    // surface: Colors.grey.shade400,
    primary: Colors.white,
    // secondary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black,fontSize: 25),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey.shade200,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.black,
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.grey),
    trackColor: WidgetStateProperty.all(Colors.white),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.lightBlueAccent,
    unselectedLabelColor: Colors.black,
    dividerColor: Colors.transparent,
    indicator: BoxDecoration(
      border:Border(
        bottom: BorderSide(
          color: Colors.lightBlueAccent,
          width: 4,
        )
      ),
    ),
  ),
);

// ------------------------------------------------------------------------------------------------------
ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,

  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStateProperty.all(Colors.white) ,
    hintStyle: WidgetStateProperty.all(TextStyle(color: Colors.black)),
    surfaceTintColor: WidgetStateProperty.all(Colors.red),
    textStyle: WidgetStateProperty.all(TextStyle(color: Colors.black)),
  ),

  colorScheme: ColorScheme.dark(
    // surface: Colors.grey.shade600,
    primary: Colors.black,
    // secondary: Colors.white,
  ),


  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white,fontSize: 25),
    // toolbarHeight: 80,
    // titleSpacing: 20,
    iconTheme: IconThemeData(color: Colors.white),
  ),


  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.white,
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.grey),
    trackColor: WidgetStateProperty.all(Colors.white),
  ),

  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
    dividerColor: Colors.transparent,
    indicator: BoxDecoration(
      border:Border(
          bottom: BorderSide(
            color: Colors.lightBlue,
            width: 4,
          )
      ),
    ),
  ),
);
