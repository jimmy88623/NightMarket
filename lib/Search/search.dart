import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nightmarket/SpeechToTextPage/SpeechRecognitionPage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});



  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyWord = "";
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';


  Future<Map<String, dynamic>> loadData() async {                             //loaddata 目前是使用中文json，這裡可以改成日文json
    String jsonfood_jpString = await rootBundle.loadString(
        'assets/data/food_jp.json');
    Map<String, dynamic> data = json.decode(jsonfood_jpString);
    // Map<String, dynamic> data = {
    //   "food_cn": jsonDecode(jsonfood_cnString),
    // };
    var food_jp_nameList = data.keys.toList();
    print(food_jp_nameList);
    print(data);
    return data;
  }

  @override
  void initState(){                                                           //initState
    super.initState();
    loadData();
    _speech = stt.SpeechToText();
  }

  void _listen() async{                                                       //語音辨識日文的function
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) =>
              setState(() {
                _text = val.recognizedWords;
                _controller.text = "$_text";
              }),
          localeId: 'ja_JP',      //設置語言為日文
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    }else{
      setState(() => _isListening = false);
      setState(() {
              keyWord = _text;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(                                                       //appbar
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
          title: Center(
            child: const Text(
              'NIGHT MARKET FOOD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: Container(
              color: Colors.indigo,
              height: 3,
            ),
          ),
        ),
        // 重要 FutureBuilder
        body: Column(
          children: [
            Padding(                                                          //搜索框設定
              padding: const EdgeInsets.only(top:20, left:16, right:16),
              child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      enabledBorder: OutlineInputBorder(                              //還沒點擊時搜索框顏色
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Colors.indigo,
                              width:3
                          )
                      ),
                      focusedBorder:  OutlineInputBorder(                             //點擊時搜索框顏色
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Colors.indigo,
                              width:3
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                            color: Colors.indigo,
                            width:3
                          )
                      ),
                      suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(                                                        //mic icon
                                onPressed: _listen,
                                //   if (result != null){
                                //     setState(() {
                                //       keyWord = result;
                                //       _controller.text = "$result";
                                //     });
                                //   }
                                // }, // 刷新
                                color: Colors.deepOrange,
                                icon: Icon(_isListening? Icons.mic :Icons.mic_none)),
                            IconButton(                                                       //search icon
                                onPressed: () {
                                  setState(() {
                                    // 刷新
                                  });
                                },
                                color: Colors.deepOrange,
                                icon: Icon(Icons.search)),
                          ],
                        )
                    ),
                    controller: _controller,
                    onChanged: (value) {
                      keyWord = value;
                      print("Keyword"+keyWord);
                    }, //onChanged,只要輸入內容有改變就會觸發
                  ),
              ),
            ),

            Expanded(                                                           //搜尋功能，也可以搜['key_word']
              child: FutureBuilder<Map<String, dynamic>>(
                future: loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;

                    Map<String, dynamic> food_jp_data = {};

                    data.forEach((key, value) {
                      food_jp_data = value;
                    });
                    var food_jp_nameList = data.keys.toList();

                    // 判斷是否有點擊搜尋
                    List<String> newKey = [];
                    Map<String, dynamic> newData = {};
                    if (keyWord != "") {
                      for (int i = 0; i < food_jp_nameList.length; i++) {
                        var foodName = food_jp_nameList[i];
                        if (foodName.contains(keyWord) ||
                            data['$foodName']['key_word'].contains(keyWord)){
                          print(data['$foodName']['key_word']);
                          var newMap = data['$foodName'];
                          newKey.add(foodName);
                          newData.addAll(newMap);
                        }
                      }
                      food_jp_nameList = newKey;
                      // data['food_cn'] = newData;
                    }


                    return ListView.builder(                                //搜尋框下方，要改成圖鑑
                      itemCount: newKey.length,

                      itemBuilder: (BuildContext context, int index) {

                        return GestureDetector(
                          onTap: () {},
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           IntroductionPage(
                          //             item: data['SEARCH'][index],
                          //           ),
                          //     ),
                          //   );
                          // },

                          child: CardWidget(
                              newKey: newKey[index],
                              newData: data[newKey[index]]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],

        ));
  }
}

                                                                          //下面可以刪掉

class CardWidget extends StatelessWidget {
  const CardWidget(
          {Key? key, required this.newKey, required this.newData})
      : super(key: key);

  final String newKey;
  final dynamic newData;

  @override
  Widget build(BuildContext context) {
    // var search_data = {};
    //
    // item!['food_cn'].forEach((key, value) {
    //   search_data.addAll(value);
    // });
    // var search_data_nameList = newData.keys.toList();
    return Card(
      child: Expanded(
        child: ListTile(
          title: Text('$newKey'),
          subtitle: Text('tt'),
        ),
      ),
    );
  }

}