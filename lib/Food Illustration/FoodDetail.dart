import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'like_provider.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String itemKey;
  final String language;

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
  late Future<void> _likeProviderFuture;

  @override
  void initState() {
    super.initState();
    _likeProviderFuture = _initializeLikeProvider();
  }

  Future<void> _initializeLikeProvider() async {
    final likeProvider = Provider.of<LikeProvider>(context, listen: false);
    if (!likeProvider.likedItems.containsKey(widget.itemKey)) {
      await likeProvider.addItem(widget.itemKey, false, widget.item); // 初始化为未喜欢，并传入item数据
    }
  }

  @override
  Widget build(BuildContext context) {
    print("傳進來的食物有:${widget.itemKey}");
    return Theme(
      data: Provider.of<ThemeProvider>(context).themeData,
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<void>(
          future: _likeProviderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return _buildContent();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
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
                          onPressed: () {
                          },
                          icon: Icon(Icons.volume_down)),
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
                  const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.warning_amber,color: Colors.orangeAccent,),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.item['remind'].map<Widget>((remindItem) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Icon(Icons.warning_amber,color: Colors.orangeAccent,),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(remindItem),
                                      const SizedBox(height: 10),
                                      Image.network(widget.item['img_url']),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("不要"+remindItem),
                                          IconButton(
                                            onPressed: (){},
                                            icon: const Icon(Icons.volume_down),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
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
                          child: Text(
                            remindItem+' ',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
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

