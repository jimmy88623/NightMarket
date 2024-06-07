import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nightmarket/Food Illustration/StarClass.dart'; // 导入 FavoriteClass

class favoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteClass = Provider.of<FavoriteClass>(context); // 获取 FavoriteClass 实例
    final favoriteItems = favoriteClass.favoriteItem; // 获取最爱项列表

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Items'),
      ),
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return ListTile(
            title: Text(item.name),
          );
        },
      ),
    );
  }
}
