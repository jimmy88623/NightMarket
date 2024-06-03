import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nightmarket/SpeechToPage/SpeechRecognitionPage.dart';


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


  // 載入資料(DLI and DA)
  Future<Map<String, dynamic>> loadData() async {
    String jsonSEARCHString = await rootBundle.loadString(
        'assets/data/SEARCH.json');
    Map<String, dynamic> data = {
      "SEARCH": jsonDecode(jsonSEARCHString),
    };
    return data;
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
                    final data = snapshot.data;

                    // 判斷是否有點擊搜尋
                    List<dynamic> newData = [];
                    if (keyWord != "") {
                      for (int i = 0; i < data!['SEARCH'].length; i++) {
                        if (data['SEARCH'][i]['食物名稱'].contains(keyWord) ||
                            data['SEARCH'][i]['內容物'].contains(keyWord)) {
                          newData.add(data['SEARCH'][i]);
                        }
                      }
                      data!['SEARCH'] = newData;
                    }

                    // 重要 ListView.builder
                    return ListView.builder(
                      itemCount: newData.length,
                      // itemCount: data!["SEARCH"].length,
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
                              item: data!['SEARCH'][index]),
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
          {Key? key, required this.item})
      : super(key: key);


  final Map<String, dynamic> item;  //屬性前方加上 final：代表屬性是由建構式傳入，在類別內無法被修改。

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Expanded(
        child: ListTile(
          title: Text(item['食物名稱']),
          subtitle: Text(item['內容物']),
        ),
      ),
    );
  }

}