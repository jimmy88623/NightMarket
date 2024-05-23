import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme.dart';


// class ThemeProvider with ChangeNotifier {
//   bool _isDarkMode = false;
//   bool get isDarkMode => _isDarkMode;
//
//   void toggleTheme(bool isDarkMode){
//     _isDarkMode = isDarkMode;
//     notifyListeners();
//   }
// }
class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightmode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightmode) {
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}
