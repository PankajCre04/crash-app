import 'package:flutter/material.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/feed_item.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/CategoryScreen";
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController? _searchController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> searchedProductList = [];
  @override
  void dispose() {
    _searchController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductsProvider>(context);
    final productByCat = productProvider.findByCaegory(catName);
    final color = Utils(context: context).color;
    final Size size = Utils(context: context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackWidget(),
        title: Text(
          catName,
          style: TextStyle(color: color),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: productByCat.isEmpty
            ? const EmptyProductWidget(
                text: "No Products yet!",
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: kBottomNavigationBarHeight,
                        child: TextField(
                          focusNode: _searchTextFocusNode,
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchedProductList = productProvider.searchQuery(value);
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.greenAccent, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.greenAccent, width: 1),
                              ),
                              hintText: "Search Product",
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController!.clear();
                                  _searchTextFocusNode.unfocus();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                                ),
                              )),
                        ),
                      ),
                    ),
                    _searchController!.text.isNotEmpty && searchedProductList.isEmpty
                        ? const EmptyProductWidget(text: "No Product found")
                        : GridView.count(
                            crossAxisCount: 2,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            childAspectRatio: size.width / (size.height * 0.59),
                            children: List.generate(
                              _searchController!.text.isNotEmpty ? searchedProductList.length : productByCat.length,
                              (index) {
                                return ChangeNotifierProvider.value(
                                  value: _searchController!.text.isNotEmpty ? searchedProductList[index] : productByCat[index],
                                  child: FeedsWidget(),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
