import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'like_provider.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String itemKey;
  final String language;

  // final Map<String, dynamic> cn_item;

  const FoodDetailPage({
    Key? key,
    required this.item,
    required this.itemKey,
    required this.language,
  }) : super(key: key);

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final Future<SharedPreferences> pres = SharedPreferences.getInstance();
  bool isLiked = false;
  //
  // @override
  // void initState(){
  //   super.initState();
  //   _loadLikedStatus();
  // }
  // Future<void> _loadLikedStatus() async {
  //   final SharedPreferences prefs = await pres;
  //   setState(() {
  //     isLiked = prefs.getBool(widget.itemKey) ?? false;
  //   });
  // }
  //
  // Future<void> _toggleLikedStatus() async {
  //   final SharedPreferences prefs = await pres;
  //   setState(() {
  //     isLiked = !isLiked;
  //   });
  //   prefs.setBool(widget.itemKey, isLiked);
  //
  //   List<String> itemKeys = prefs.getStringList('itemKeys') ?? [];
  //   if (!itemKeys.contains(widget.itemKey)) {
  //     itemKeys.add(widget.itemKey);
  //   }
  //   prefs.setStringList('itemKeys', itemKeys);
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final likeProvider = Provider.of<LikeProvider>(context, listen: false);
      // 检查是否已经存在于 Provider 中，如果不存在则添加默认值
      if (!likeProvider.likedItems.containsKey(widget.itemKey)) {
        likeProvider.addItem(widget.itemKey, false); // 初始化为未喜欢
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print("傳進來的食物有:${widget.itemKey}");
    // 使用 Provider 來提供狀態
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
                          Consumer<LikeProvider>(
                            builder: (context, likeProvider, child) {
                              bool isLiked = likeProvider.likedItems[widget.itemKey] ?? false;
                              return IconButton(
                                onPressed: () => likeProvider.toggleLikedStatus(widget.itemKey),
                                icon: Icon(isLiked ? Icons.star : Icons.star_border),
                              );
                            },
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
                                    Image.network(widget.item['img_url']),
                                    const SizedBox(height: 10),
                                    Text(widget.item['key_word'].join(',')),
                                    if (widget.language == "Japanese")
                                      Text('不要' +
                                          widget.item['remind'].join(','))
                                    else
                                      Text('不要' +
                                          widget.item['remind'].join(',')),
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
  }
}



