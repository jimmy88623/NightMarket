import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nightmarket/Home/home.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

final List<String> imagePaths = [
  "assets/nightmarket1.jpg",
  "assets/nightmarket2.jpg",
  "assets/nightmarket3.jpg"
];

final List<String> captions = ["test 1 ","test 2 ","test 3 "];
late List<Widget> _pages;

int _activePage = 0;

final PageController _pageController = PageController(initialPage: 0);

Timer? _timer;

class _HomeState extends State<Home> {
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.page == imagePaths.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void _goToPreviousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      _pageController.animateToPage(_pages.length - 1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void _goToNextPage() {
    if (_pageController.page! < _pages.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = List.generate(imagePaths.length, (index) => ImageWithCaption(imagePath: imagePaths[index], caption: captions[index]));
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 32.0),
                height: MediaQuery.of(context).size.width * 0.2,
                child: const Row(
                  children: [
                    Icon(
                      Icons.record_voice_over,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      '最新消息',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.95,
                    height: MediaQuery.of(context).size.height / 3,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imagePaths.length,
                      onPageChanged: (value) {
                        setState(() {
                          _activePage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _pages[index];
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          _pages.length,
                              (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                _pageController.animateToPage(index,
                                    duration: Duration(microseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.transparent,
                                // backgroundColor: _activePage == index
                                //     ? Colors.yellow
                                //     : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: _goToPreviousPage,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: _goToNextPage,
                    ),
                  ),
                ],
              ),
              // Column(
              //   children: itemList.map((item) {
              //     return Card(
              //       margin:
              //           const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              //       elevation: 5,
              //       child: ListTile(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         title: Text(item),
              //         tileColor: Colors.orangeAccent,
              //         onTap: () {},
              //         leading: const Icon(Icons.star_border_outlined),
              //         trailing: const Icon(Icons.menu),
              //       ),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageWithCaption extends StatelessWidget {
  final String imagePath;
  final String caption;

  const ImageWithCaption({required this.imagePath, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
        Image.asset(
        imagePath,
        fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text(
                  caption,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
    );
  }
}

