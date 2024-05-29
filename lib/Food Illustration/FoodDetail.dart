import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  final dynamic item;

  const FoodDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String allReminders = item['cn_remind'].join('、');

    return Theme(
      data: Provider.of<ThemeProvider>(context).themeData,
      child: Scaffold(
        appBar: AppBar(
            // title: Text(item['cn']),
            ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      item['img_url'],
                      fit: BoxFit.contain,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Text(
                    item['cn'],
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '介紹:',
                    style: TextStyle(fontSize: 25),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                item['cn_introduce'],
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              if (item['cn_remind'] != null && item['cn_remind'].isNotEmpty)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.dangerous),
                    ),
                    Expanded(
                      child: Text(
                       allReminders,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: const Text('Close'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
