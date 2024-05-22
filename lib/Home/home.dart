import 'package:flutter/material.dart';

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
late List<Widget> _pages;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _pages = List.generate(imagePaths.length,
        (index) => ImagePlaceholder(imagePath: imagePaths[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 32.0),
              height: MediaQuery.of(context).size.width * 0.2,
              color: Colors.red,
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
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                  child: PageView.builder(
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;

  const ImagePlaceholder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
    );
  }
}
