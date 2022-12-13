import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/consts/const_data.dart';
import 'package:food_app/inner_screens/on_sale_screen.dart';
import 'package:food_app/provider/dark_theme_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/feed_item.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../inner_screens/feeds_screen.dart';
import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../widgets/on_sale.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Utils(context: context).getTheme;
    Size size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    List<ProductModel> productOnSale = productsProvider.getSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: size.height * 0.30,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(ConstData.offerImages[index]);
                  },
                  autoplay: true,
                  itemCount: ConstData.offerImages.length,
                  pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(color: Colors.white, activeColor: Colors.red),
                  ),
                  //  control: SwiperControl(),
                )),
            TextButton(
              onPressed: () {
                GlobalMethods.navigateTo(context: context, routeName: OnSaleScreen.routeName);
              },
              child: const Text(
                "View all",
                style: TextStyle(fontSize: 17),
                maxLines: 1,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: "ON SALE",
                        color: Colors.red,
                        textSize: 21,
                        isTitle: true,
                      ),
                      const Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.21,
                    child: ListView.builder(
                        itemCount: productOnSale.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, right: 18.0),
                            child: ChangeNotifierProvider.value(
                              value: productOnSale[index],
                              child: OnSaleWidget(),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(text: "Products", color: color, textSize: 18, isTitle: true),
                  // const Spacer(),
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(context: context, routeName: FeedScreen.routeName);
                    },
                    child: const Text("Browse all", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              //crossAxisSpacing: 10,
              // mainAxisSpacing: 5,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.55),
              children: List.generate(allProducts.length, (index) {
                return ChangeNotifierProvider.value(
                  value: allProducts[index],
                  child: FeedsWidget(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
