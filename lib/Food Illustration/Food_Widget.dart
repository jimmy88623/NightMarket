import 'package:flutter/material.dart';
import 'package:nightmarket/Food Illustration/FoodDetail.dart';
class FoodWidget extends StatefulWidget {
  final Map<String, dynamic> cn_foodItems;
  final Map<String, dynamic> jp_foodItems;
  final String keyword;

  const FoodWidget(
      {Key? key,
      required this.keyword,
      required this.cn_foodItems,
      required this.jp_foodItems})
      : super(key: key);

  @override
  State<FoodWidget> createState() => _FoodWidgetState();
}

class _FoodWidgetState extends State<FoodWidget> {
  final SearchController searchController = SearchController();
  late Map<String, dynamic> foodItems;
  late List<String> filteredItems;
  String dropdownValue = "Chinese";
  String searchFood = "";

  @override
  void initState() {
    super.initState();
    foodItems = widget.cn_foodItems; // 初始时默认使用中国食物项目
    _filterItems();
    searchController.addListener(() {
      setState(() {
        searchFood = searchController.text;
      });
    });
  }

  @override
  void didUpdateWidget(FoodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cn_foodItems != widget.cn_foodItems ||
        oldWidget.jp_foodItems != widget.jp_foodItems ||
        oldWidget.keyword != widget.keyword) {
      if (dropdownValue == "Chinese") {
        foodItems = widget.cn_foodItems;
      } else {
        foodItems = widget.jp_foodItems;
      }
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
            DropdownButton(
              value: dropdownValue,
              icon: Icon(Icons.menu),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                  if (dropdownValue == "Chinese") {
                    foodItems = widget.cn_foodItems;
                    _filterItems();
                  } else {
                    foodItems = widget.jp_foodItems;
                    _filterItems();
                  }
                  print("foodItems : $foodItems");
                });
              },
              items: const [
                DropdownMenuItem(
                  child: Text('Chinese'),
                  value: 'Chinese',
                ),
                DropdownMenuItem(
                  child: Text('Japanese'),
                  value: 'Japanese',
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: SearchBar(
                controller: searchController,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                leading: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // 搜索图标按钮
                  },
                ),
                hintText: 'Search...',
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
                print("displayItems : $displayedItems");
                final key = displayedItems[index];
                final item = foodItems[key];
                print(" index : $index  is  ${item}");
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
                                language: dropdownValue,
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
                              : Image.network(
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
