import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:nightmarket/Food Illustration/FoodDetail.dart';
import 'package:nightmarket/Food%20Illustration/like_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FoodWidget extends StatefulWidget {
  // final Map<String, dynamic> cn_foodItems;
  final Map<String, dynamic> jp_foodItems;
  final String keyword;
  const FoodWidget(
      {Key? key, required this.keyword, required this.jp_foodItems})
      : super(key: key);

  @override
  State<FoodWidget> createState() => _FoodWidgetState();
}

class _FoodWidgetState extends State<FoodWidget> {
  final SearchController searchController = SearchController();
  late Map<String, dynamic> foodItems;
  late List<String> filteredItems;
  String searchFood = "";
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  @override
  void initState() {
    super.initState();
    final likeProvider = Provider.of<LikeProvider>(context, listen: false);
    foodItems = widget.jp_foodItems;
    foodItems.forEach((key, value) {
      likeProvider.addItem(key, value);
    });
    _filterItems();
    searchController.addListener(() {
      setState(() {
        searchFood = searchController.text;
      });
    });
    _speech = stt.SpeechToText();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              print("錄音文字辨識為: $_text");
              searchController.text = _text;
              _isListening = false;  // 在结果回调中更改状态
            });
            _speech.stop();  // 识别完成后停止监听
          },
          localeId: 'ja_JP',
        );
      } else {
        setState(() => _isListening = false);
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void didUpdateWidget(FoodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.jp_foodItems != widget.jp_foodItems ||
        oldWidget.keyword != widget.keyword) {
      _filterItems();
    }
  }

  void _filterItems() {
    filteredItems = foodItems.keys
        .where((key) => foodItems[key]['category'] == widget.keyword)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayedItems = searchFood.isNotEmpty
        ? filteredItems
            .where(
                (key) => key.toLowerCase().contains(searchFood.toLowerCase()))
            .toList()
        : filteredItems;

    return GestureDetector(
      onTap: () {
        // 当点击空白处时，收起键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: SearchBar(
                controller: searchController,
                // padding: const WidgetStatePropertyAll<EdgeInsets>(
                //     EdgeInsets.symmetric(horizontal: 16.0)),
                leading: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // 搜索图标按钮
                  },
                ),
                trailing: [
                  IconButton(
                    onPressed: _listen,
                    icon: Icon(_isListening? Icons.mic :Icons.mic_none),
                  )
                ],
                hintText: '今日は何を食べようかな〜',
                hintStyle: WidgetStateProperty.all(TextStyle(color: Colors.blueGrey)),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 每行显示四个项目
                crossAxisSpacing: 15.0, // 行间距
                mainAxisSpacing: 15.0, // 列间距
              ),
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                // print("displayItems : $displayedItems");
                final key = displayedItems[index];
                final item = foodItems[key];
                // print(" index : $index  is  ${item}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailPage(
                                item: item,
                                itemKey: key,
                              ),
                            ),
                          );
                        },
                        child: ClipOval(
                          child: item['img_url'].isEmpty
                              ? Image.asset(
                                  'assets/hokaido.jpg',
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                )
                              : Image.asset(
                                  item['img_url'],
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
