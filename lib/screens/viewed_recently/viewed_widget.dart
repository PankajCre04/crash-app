import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/models/viewed_model.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../../consts/firebase_consts.dart';
import '../../inner_screens/product_details.dart';
import '../../services/global_methods.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    final size = Utils(context: context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedModel = Provider.of<ViewedProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.findById(viewedModel.productId);
    final usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    bool? isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //  GlobalMethods.navigateTo(context: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width * 0.27,
              width: size.width * 0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getCurrentProduct.title,
                  style: const TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: '\$$usedPrice',
                  color: color,
                  textSize: 18,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isInCart
                        ? null
                        : () async {
                            final User? user = authInstance.currentUser;
                            if (user == null) {
                              GlobalMethods.errorDialog(subTitle: 'No user found, please login first', context: context);
                              return;
                            }
                            await GlobalMethods.addToCart(productId: getCurrentProduct.id, quantity: 1, context: context);
                            await cartProvider.fetchCart();
                            //   cartProvider.addProductsToCart(productId: getCurrentProduct.id, quantity: 1);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
