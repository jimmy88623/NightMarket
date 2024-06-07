import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedItemsPage extends StatefulWidget {
  @override
  _LikedItemsPageState createState() => _LikedItemsPageState();
}

class _LikedItemsPageState extends State<LikedItemsPage> {
  late List<Map<String, dynamic>> _likedItems;

  @override
  void initState() {
    super.initState();
    _loadLikedItems();
  }

  // 加载喜欢的项目
  Future<void> _loadLikedItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> allItems = [
      // 替换为你获取所有项目的逻辑
      {"itemKey": "Item 1", "isLiked": prefs.getBool("Item 1") ?? false},
      {"itemKey": "Item 2", "isLiked": prefs.getBool("Item 2") ?? false},
      // 添加更多项目
    ];

    setState(() {
      _likedItems = allItems.where((item) => item['isLiked']).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Items'),
      ),
      body: ListView.builder(
        itemCount: _likedItems.length,
        itemBuilder: (context, index) {
          final item = _likedItems[index];
          return ListTile(
            title: Text(item['itemKey']),
            // 添加更多项目信息
          );
        },
      ),
    );
  }
}
