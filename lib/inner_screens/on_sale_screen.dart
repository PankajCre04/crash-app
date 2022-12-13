import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/back_widget.dart';
import 'package:food_app/widgets/on_sale.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../widgets/empty_product_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> saleProducts = productsProvider.getSaleProducts;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackWidget(),
        title: Text(
          "Products on sale",
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: saleProducts.isEmpty
            ? const EmptyProductWidget(
                text: "No products on sale yet!, \n Stay tuned",
              )
            : GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * 0.45),
                children: List.generate(saleProducts.length, (index) {
                  return ChangeNotifierProvider.value(
                    value: saleProducts[index],
                    child: OnSaleWidget(),
                  );
                }),
              ),
      ),
    );
  }
}
