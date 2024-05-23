import 'package:flutter/material.dart';
import 'package:nightmarket/Food Illustration/food.dart';
import 'package:nightmarket/Home/menu.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:nightmarket/Camera/camera.dart';

class ButtonbarPage extends StatefulWidget {
  const ButtonbarPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonbarPageState();
}

class _ButtonbarPageState extends State<ButtonbarPage> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    Menu(),
    Food(),
    Camera(),
    Placeholder(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Provider.of<ThemeProvider>(context).themeData.colorScheme.secondary,
          selectedItemColor: Colors.blue,
          currentIndex: _currentPageIndex,
          onTap: (currentPageIndex) {
            print("現在所在頁面 : $currentPageIndex");
            _onPageChanged(currentPageIndex);
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Provider.of<ThemeProvider>(context).themeData.primaryColor,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Food Illustration',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentPageIndex,
          children: _pages,
        ),
      ),
    );
  }
}
