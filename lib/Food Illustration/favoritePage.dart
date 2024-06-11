import 'package:flutter/material.dart';
import 'package:nightmarket/Food%20Illustration/FoodDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'like_provider.dart';
class LikedItemsPage extends StatefulWidget {
  @override
  _LikedItemsPageState createState() => _LikedItemsPageState();
}

class _LikedItemsPageState extends State<LikedItemsPage> {
  final Future<SharedPreferences> pres = SharedPreferences.getInstance();
  Map<String, bool> likedItems = {};

  @override
  void initState() {
    super.initState();
    _loadLikedItems();
  }

  // 加载喜欢的项目
  Future<void> _loadLikedItems() async {
    final SharedPreferences prefs = await pres;
    List<String> itemKeys = prefs.getStringList('itemKeys') ?? [];

    Map<String, bool> tempLikedItems = {};
    for (String key in itemKeys) {
      tempLikedItems[key] = prefs.getBool(key) ?? false;
    }

    setState(() {
      likedItems = tempLikedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<LikeProvider>(
          builder: (context, likeProvider, child) {
            List<String> likedItems = likeProvider.likedItems.keys
                .where((key) => likeProvider.likedItems[key] == true)
                .toList();

            return ListView.builder(
              itemCount: likedItems.length,
              itemBuilder: (context, index) {
                String key = likedItems[index];
                Map<String, dynamic>? item = likeProvider.getItem(key);
                print("item: $item");
                String anotherName = item?['another_name'] ?? 'No name available';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          item: likeProvider.getItem(key)!, // 获取项目数据
                          itemKey: key,
                          // language: 'chinese', // 这里填入合适的语言参数
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(key),
                    subtitle: Text(anotherName), // 显示 another_name
                    trailing: IconButton(
                      icon: Icon(Icons.star),
                      onPressed: () => likeProvider.toggleLikedStatus(key),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
