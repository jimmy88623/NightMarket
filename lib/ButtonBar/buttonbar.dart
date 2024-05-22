import 'package:flutter/material.dart';
import 'package:nightmarket/Home/menu.dart';


class ButtonbarPage extends StatefulWidget {
  const ButtonbarPage({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        currentIndex: _currentPageIndex,
        onTap: (currentPageIndex) {
          print("現在所在頁面 : $currentPageIndex");
          _onPageChanged(currentPageIndex);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Food Illustration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
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
    );
  }

  Future<List<Widget>> _buildScreen() async {

    return [
      Menu(),
      Placeholder(),
      Placeholder(),
      Placeholder()
    ];
  }
}
