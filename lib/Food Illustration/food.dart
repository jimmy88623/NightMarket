import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightmarket/Food%20Illustration/food.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:nightmarket/Food Illustration/Food_Widget.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}


class _FoodState extends State<Food> {

  late Map<String,dynamic> foodItems;
  bool _isLoading = true;

  Future<void> loadJsonData() async {
    // 加載並讀取 test.json 文件
    String jsonData = await rootBundle.loadString('assets/test.json');

    setState(() {
      foodItems = json.decode(jsonData);
      _isLoading = false;
      print("foodItems:$foodItems");
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
              FoodWidget(foodItems: foodItems,keyword: '鹹食',),
              FoodWidget(foodItems: foodItems,keyword: '甜食',),
              FoodWidget(foodItems: foodItems,keyword: '飲料',),
              Container(
                child:const Icon(Icons.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
