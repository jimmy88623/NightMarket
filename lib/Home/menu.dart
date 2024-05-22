import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nightmarket/Home/home.dart';
import 'package:nightmarket/Home/set.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Home(),
    Center(child: Text('成員頁面')),
  ];

  void _menuTapHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歡迎來到Ya市家族~~'),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              padding: EdgeInsets.zero,
              child: Image(
                  image: AssetImage('assets/hokaido.jpg'), fit: BoxFit.cover),
            ),
            ListTile(
              title: const Text('首頁'),
              onTap: () {
                _menuTapHandler(0);
              },
            ),
            ListTile(
              title: const Text('設定'),
              onTap: () {
                _menuTapHandler(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
