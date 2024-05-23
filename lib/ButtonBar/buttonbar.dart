import 'package:flutter/material.dart';
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

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Provider.of<ThemeProvider>(context).themeData.colorScheme.secondary,
          selectedItemColor: Colors.blue,
          currentIndex: _currentPageIndex,
          onTap: (currentPageIndex) {
            print("現在所在頁面 : $currentPageIndex");
            _onPageChanged(currentPageIndex);
          },
          items:  [
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
        body: FutureBuilder<List<Widget>>(
          future: _buildScreen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return snapshot.data![_currentPageIndex];
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> _buildScreen() async {

    return [
      // Placeholder(),
      Menu(),
      Placeholder(),
      Camera(),
      Placeholder()
    ];
  }
}
