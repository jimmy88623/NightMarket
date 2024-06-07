import 'package:flutter/material.dart';
import 'package:nightmarket/Food%20Illustration/StarClass.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String itemKey;

  const FoodDetailPage({Key? key, required this.item, required this.itemKey})
      : super(key: key);

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}
class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    // 使用 Provider 來提供狀態
    return ChangeNotifierProvider(
      create: (_) => FavoriteClass(),
      child: Consumer<FavoriteClass>(
        builder: (context, FavoriteClass, _) {
          return Theme(
            data: Provider.of<ThemeProvider>(context).themeData,
            child: Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        children: [
                          widget.item['img_url'].isNotEmpty
                              ? ClipOval(
                            child: Image.network(
                              widget.item['img_url'],
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            ),
                          )
                              : SizedBox(width: 100, height: 100),
                          // 若无图像则使用固定大小的 SizedBox
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.itemKey,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.item['another_name'],
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          Expanded(
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    FavoriteClass.toggleStar(); // 點擊時切換星星狀態
                                    print("widget.itemkey is ${widget.itemKey}");
                                    if(FavoriteClass.starstate()){

                                    }
                                  },
                                  icon: FavoriteClass.isStared
                                      ? Icon(Icons.star)
                                      : Icon(Icons.star_border),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.record_voice_over)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Introduction:',
                            style: TextStyle(fontSize: 25),
                          )),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        widget.item['introduce'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                      if (widget.item['remind'].isNotEmpty)
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
                                          Text(widget.item['remind'].join(',')),
                                          const SizedBox(height: 10),
                                          Image.network(widget.item['img_url']), //
                                          const SizedBox(height: 10),
                                          Text(widget.item['key_word'].join(',')),
                                          const SizedBox(height: 10),
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
                                widget.item['remind'].join(','),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// class _FoodDetailPageState extends State<FoodDetailPage> {
//   bool isStared = false;
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Provider.of<ThemeProvider>(context).themeData,
//       child: Scaffold(
//         appBar: AppBar(
//             // title: Text(item['cn']),
//             ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.01,
//                 ),
//                 Row(
//                   children: [
//                     widget.item['img_url'].isNotEmpty
//                         ? ClipOval(
//                             child: Image.network(
//                               widget.item['img_url'],
//                               fit: BoxFit.contain,
//                               width: 100,
//                               height: 100,
//                             ),
//                           )
//                         : SizedBox(width: 100, height: 100),
//                     // 若无图像则使用固定大小的 SizedBox
//                     SizedBox(width: MediaQuery.of(context).size.width * 0.1),
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             widget.itemKey,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             widget.item['another_name'],
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: MediaQuery.of(context).size.width * 0.1),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isStared = !isStared;
//                                   if(isStared){
//
//                                   }
//                                 });
//                               },
//                             icon: isStared ? Icon(Icons.star) : Icon(Icons.star_outline),
//
//                           ),
//                           IconButton(
//                               onPressed: () {},
//                               icon: Icon(Icons.record_voice_over)),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//                 const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Introduction:',
//                       style: TextStyle(fontSize: 25),
//                     )),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                 Text(
//                   widget.item['introduce'],
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.2),
//                 if (widget.item['remind'].isNotEmpty)
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Icon(Icons.warning_amber),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(widget.item['remind'].join(',')),
//                                     const SizedBox(height: 10),
//                                     Image.network(widget.item['img_url']), //
//                                     const SizedBox(height: 10),
//                                     Text(widget.item['key_word'].join(',')),
//                                     const SizedBox(height: 10),
//                                     // 替换为你想要添加的内容
//                                   ],
//                                 ),
//                                 actions: [
//                                   Center(
//                                     child: IconButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       icon: const Text('Close'),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.warning_amber),
//                       ),
//                       Expanded(
//                         child: Text(
//                           widget.item['remind'].join(','),
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                       ),
//                     ],
//                   ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
