import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Food extends StatefulWidget{
  const Food({super.key});

  @override
  State<StatefulWidget> createState() => _FoodState();

}

class _FoodState extends State<Food>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).themeData.colorScheme.primary,
      appBar: AppBar(title:const Text('夜市小吃圖鑑'),),
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: 4,
            itemBuilder: (ctx, i) {
              return Card(
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://tech.pelmorex.com/wp-content/uploads/2020/10/flutter.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          // Text(
                          //   'Title',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Row(
                            children: [
                              Text(
                                'Subtitle',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 5,
              // mainAxisExtent: 264,
            ),
          ),
        ],
      ),
    );
  }
}