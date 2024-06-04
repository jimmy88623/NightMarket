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
        body: SingleChildScrollView(
          child: Padding(
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Column(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.star)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.record_voice_over)),
                      ],
                    )
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Icon(Icons.warning_amber),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(item['jn_remind'].join(',')),
                                    const SizedBox(height: 10),
                                    Text(item['cn_remind'].join(',')) ,
                                    const SizedBox(height: 10),
                                    Image.network(item['img_url']),//
                                    const SizedBox(height: 10),
                                    Text(item['cn_key_word'].join(',')),
                                    const SizedBox(height: 10),
                                    Text(item['jn_key_word'].join(','))
                                    // 替换为你想要添加的内容
                                  ],
                                ),
                                actions: [
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Text('Close'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.warning_amber),
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
      ),
    );
  }
}
