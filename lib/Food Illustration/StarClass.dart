import 'package:flutter/material.dart';

class FavoriteClass extends ChangeNotifier {
  bool _isStared = false;
  bool get isStared => _isStared;

  List<FavoriteItem> _favoriteItem = [];
  List<FavoriteItem> get favoriteItem => _favoriteItem;

  void addToFav(FavoriteItem item){
    _favoriteItem.add(item);
    print("已將 ${item.name} 加入最愛!");
    notifyListeners();
  }
  void toggleStar() {
    _isStared = !_isStared;
    notifyListeners(); // 通知訂閱者狀態已改變
  }

  bool starstate(){
    return _isStared;
  }
}

class FavoriteItem{
  final String name;
  FavoriteItem({required this.name});
}