import 'package:flutter/material.dart';
import 'package:food_app/consts/const_data.dart';
import 'package:food_app/models/product_model.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/back_widget.dart';
import 'package:food_app/widgets/feed_item.dart';
import 'package:provider/provider.dart';

import '../widgets/empty_product_widget.dart';
import '../widgets/on_sale.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = "/FeedScreen";
  const FeedScreen({Key? key}) : super(key: key);
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController? _searchController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> searchedProductList = [];

  // @override
  // void initState() {
  //   final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
  //   productsProvider.fetchProducts();
  //   super.initState();
  // }

  @override
  void dispose() {
    _searchController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final Size size = Utils(context: context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackWidget(),
        title: Text(
          "All Products",
          style: TextStyle(color: color),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                      searchedProductList = productsProvider.searchQuery(value);
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
                      hintText: "What's in your mind",
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
                      _searchController!.text.isNotEmpty ? searchedProductList.length : allProducts.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                          value: _searchController!.text.isNotEmpty ? searchedProductList[index] : allProducts[index],
                          child: FeedsWidget(),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
