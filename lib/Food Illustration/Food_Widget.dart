import 'package:flutter/material.dart';
import 'package:nightmarket/Food Illustration/FoodDetail.dart';

class FoodWidget extends StatefulWidget {
  final Map<String,dynamic> foodItems;
  final String keyword;

  const FoodWidget({Key? key, required this.foodItems, required this.keyword})
      : super(key: key);

  @override
  State<FoodWidget> createState() => _FoodWidgetState();
}

class _FoodWidgetState extends State<FoodWidget> {
  SearchController searchController = SearchController();
  late List<String> filteredItemsKeys;
  String searchFood = "";
  @override
  void initState() {
    super.initState();
    _filterItems();
  }

  @override
  void didUpdateWidget(FoodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foodItems != widget.foodItems ||
        oldWidget.keyword != widget.keyword) {
      _filterItems();
    }
  }

  void _filterItems() {
    filteredItemsKeys = widget.foodItems.keys
        .where((key) => widget.foodItems[key]['category'] == widget.keyword)
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 當點擊空白處時，收起鍵盤
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        setState(() {
          searchFood = searchController.text;
          print("searchFood : $searchFood");
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 15),
                child: SearchBar(
                  controller: searchController,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  // onTap: () {
                  //   searchController.openView();
                  // },
                  leading: IconButton(
                    // 搜索圖標按鈕
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // searchController.openView();
                    },
                  ),
                  hintText: 'Search...',
                )),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 每行顯示四個項目
                crossAxisSpacing: 15.0, // 行間距
                mainAxisSpacing: 15.0, // 列間距
              ),
              itemCount: searchFood.isNotEmpty
                  ? filteredItemsKeys.where((key) => widget.foodItems[key]['cn']
                  .toString()
                  .toLowerCase()
                  .contains(searchFood.toLowerCase()))
                  .length
                  : filteredItemsKeys.length,
              itemBuilder: (context, index) {
                final filteredKeys = filteredItemsKeys.where((key) =>
                    widget.foodItems[key]['cn']
                        .toString()
                        .toLowerCase()
                        .contains(searchFood.toLowerCase())).toList();
                final key = filteredKeys[index];
                final item = widget.foodItems[key];
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
                              builder: (context) => FoodDetailPage(item: item),
                            ),
                          );
                        },
                        child: ClipOval(
                          child: item['img_url'].isEmpty
                              ? Image.asset(
                            'assets/hokaido.jpg',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                          )
                              : Image.network(
                            item['img_url'],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
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
