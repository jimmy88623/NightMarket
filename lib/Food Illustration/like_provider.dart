import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeProvider with ChangeNotifier {
  final Future<SharedPreferences> pres = SharedPreferences.getInstance();
  Map<String, bool> _likedItems = {};
  Map<String, Map<String, dynamic>> _items = {};

  Map<String, bool> get likedItems => _likedItems;
  Map<String, Map<String, dynamic>> get items => _items;

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

  Future<void> addItem(String key, Map<String, dynamic> item) async {

    final SharedPreferences prefs = await pres;
    // _likedItems[key] = liked;
    _items[key] = item;

    // 序列化并保存 item 数据
    String itemJson = jsonEncode(item);
    prefs.setString('${key}_item', itemJson);

    // prefs.setBool(key, liked);
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

  Map<String, dynamic>? getItem(String key) {
    return _items[key];
  }
  Future<void> clearLikedItems() async {
    final SharedPreferences prefs = await pres;

    // 清空 _likedItems 字典
    _likedItems.clear();

    // 从 SharedPreferences 中删除所有与喜欢项目相关的键
    List<String> itemKeys = prefs.getStringList('itemKeys') ?? [];
    for (String key in itemKeys) {
      prefs.remove(key); // 删除 liked 值
      prefs.remove('${key}_item'); // 删除 item 数据
    }

    // 清空 _items 字典
    _items.clear();

    // 清空 itemKeys
    prefs.remove('itemKeys');

    // 通知监听器
    notifyListeners();
  }

}
