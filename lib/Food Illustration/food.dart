import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightmarket/Food%20Illustration/food.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:nightmarket/Food Illustration/Food_Widget.dart';
import 'package:nightmarket/Food Illustration/favoritePage.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}


class _FoodState extends State<Food> {

  late Map<String,dynamic> cn_foodItems;
  late Map<String,dynamic> jp_foodItems;
  bool _isLoading = true;

  Future<void> loadJsonData() async {
    // 加載並讀取 test.json 文件
    String cn_jsonData = await rootBundle.loadString('assets/food_cn.json');
    String jp_jsonData = await rootBundle.loadString('assets/food_jp.json');
    setState(() {
      cn_foodItems = json.decode(cn_jsonData);
      jp_foodItems = json.decode(jp_jsonData);
      _isLoading = false;
    });
  }
  @override
  void initState(){
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(), // 显示加载指示器
      );
    }

    return DefaultTabController(
      length: 4,
      child: MaterialApp(
        debugShowCheckedModeBanner: false ,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon:Text('鹹食')),
                Tab(icon:Text('甜食')),
                Tab(icon:Text('飲料')),
                Tab(icon:Text('最愛')),
              ],
            ),
            title: Text('Night Market Food'),
          ),
          body: TabBarView(
            children: [
              FoodWidget(cn_foodItems: cn_foodItems,jp_foodItems: jp_foodItems,keyword: 'Salty',),
              FoodWidget(cn_foodItems: cn_foodItems,jp_foodItems: jp_foodItems,keyword: 'Sweet',),
              FoodWidget(cn_foodItems: cn_foodItems,jp_foodItems: jp_foodItems,keyword: 'Drink',),
              LikedItemsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
