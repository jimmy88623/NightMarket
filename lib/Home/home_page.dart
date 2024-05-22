import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  const HomePage({Key? key}):super(key: key);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    // String title = "Home";
    Widget currentPage = const HomePage();

    menuTapHandler(int index) {
      setState(() {
        switch (index) {
          case 0:
            {
              // title = "Home";
              currentPage = HomePage();
            }
            break;
          case 1:
            {
              // title = "Members";
              currentPage = HomePage();
            }
            break;
        }

        // hide menu
        Navigator.pop(context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('Welcome to Ya市 family~~'),
      ),
      body: currentPage,
      drawer:  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              padding: EdgeInsets.zero,
              child: Image(
                  image: AssetImage('assets/hokaido.jpg'), fit: BoxFit.cover),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                menuTapHandler(0);
              },
            ),
            ListTile(
              title: const Text('設定'),
              onTap: () {
                menuTapHandler(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}