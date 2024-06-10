import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nightmarket/SpeechToTextPage/SpeechRecognitionPage.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});



  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyWord = "";
  List<String> favoriteDrugNames = [];
  List<String> indications = [];
  List<String> favoriteDrugPicsURL = [];
  final TextEditingController _controller = TextEditingController();



  Future<Map<String, dynamic>> loadData() async {
    String jsonfood_cnString = await rootBundle.loadString(
        'assets/data/food_cn.json');
    Map<String, dynamic> data = json.decode(jsonfood_cnString);
    // Map<String, dynamic> data = {
    //   "food_cn": jsonDecode(jsonfood_cnString),
    // };
    var food_cn_nameList = data.keys.toList();
    print(food_cn_nameList);
    print(data);
    return data;
  }

  @override
  void initState(){
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            Padding(
              padding: const EdgeInsets.only(top:20, left:16, right:16),
              child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      enabledBorder: OutlineInputBorder(                              //還沒點擊時外框顏色
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Colors.indigo,
                              width:3
                          )
                      ),
                      focusedBorder:  OutlineInputBorder(                             //點擊時外框顏色
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
                            IconButton(
                                onPressed: () async{
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SpeechRecognitionPage(),
                                    ),
                                  );
                                  if (result != null){
                                    setState(() {
                                      keyWord = result;
                                      _controller.text = "$result";
                                    });
                                  }
                                }, // 刷新
                                color: Colors.deepOrange,
                                icon: Icon(Icons.mic)),
                            IconButton(
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

            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;

                    Map<String, dynamic> food_cn_data = {};

                    data.forEach((key, value) {
                      food_cn_data = value;
                    });
                    var food_cn_nameList = data.keys.toList();

                    // 判斷是否有點擊搜尋
                    List newKey = [];
                    Map<String, dynamic> newData = {};
                    if (keyWord != "") {
                      for (int i = 0; i < food_cn_nameList.length; i++) {
                        if (food_cn_nameList[i].contains(keyWord)) {
                          var newMap = data[food_cn_nameList[i]];
                          newKey.add(food_cn_nameList[i]);
                          newData.addAll(newMap);
                        }
                      }
                      newData.addAll(data);
                      // data['food_cn'] = newData;
                    }

                    // 重要 ListView.builder
                    return ListView.builder(
                      itemCount: newKey.length,

                      itemBuilder: (BuildContext context, int index) {
                        // 重要 手勢感測元件
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
                          // 重要 在App上要顯示的內容
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



class CardWidget extends StatelessWidget {
  const CardWidget(          //const來修飾建構式，若帶入的引數相同，在建立類別實例時，這些類別實例會被指向在同一個記憶體位置上。
          {Key? key, required this.newKey, required this.newData})
      : super(key: key);

  final String newKey;
  final dynamic newData;  //屬性前方加上 final：代表屬性是由建構式傳入，在類別內無法被修改。

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