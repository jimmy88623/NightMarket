import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeProvider with ChangeNotifier {
  final Future<SharedPreferences> pres = SharedPreferences.getInstance();
  Map<String, bool> _likedItems = {};

  Map<String, bool> get likedItems => _likedItems;

  LikeProvider() {
    _loadLikedItems();
  }

  Future<void> _loadLikedItems() async {
    final SharedPreferences prefs = await pres;
    List<String> itemKeys = prefs.getStringList('itemKeys') ?? [];
    Map<String, bool> tempLikedItems = {};
    for (String key in itemKeys) {
      tempLikedItems[key] = prefs.getBool(key) ?? false;
    }
    _likedItems = tempLikedItems;
    notifyListeners();
  }
  Future<void> addItem(String key, bool liked) async {
    final SharedPreferences prefs = await pres;
    _likedItems[key] = liked;
    prefs.setBool(key, liked);
    List<String> itemKeys = prefs.getStringList('itemKeys') ?? [];
    if (!itemKeys.contains(key)) {
      itemKeys.add(key);
    }
    prefs.setStringList('itemKeys', itemKeys);
    notifyListeners();
  }
  Future<void> toggleLikedStatus(String key) async {
    final SharedPreferences prefs = await pres;
    _likedItems[key] = !_likedItems[key]!;
    prefs.setBool(key, _likedItems[key]!);
    notifyListeners();
  }
}
// TODO Implement this library.