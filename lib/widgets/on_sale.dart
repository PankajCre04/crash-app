import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/inner_screens/product_details.dart';
import 'package:food_app/models/product_model.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/heart_button.dart';
import 'package:food_app/widgets/price_widget.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../provider/wishlist_provider.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final themeState = Utils(context: context).getTheme;
    final size = Utils(context: context).getScreenSize;
    final color = Utils(context: context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Material(
      color: Theme.of(context).cardColor.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetails.routeName, arguments: productModel.id);
          // GlobalMethods.navigateTo(context: context, routeName: ProductDetails.routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FancyShimmerImage(
                    imageUrl: productModel.imageUrl,
                    height: size.width * 0.22,
                    width: size.width * 0.22,
                    boxFit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Column(
                    children: [
                      TextWidget(
                        text: productModel.isPiece ? "1Piece" : "1Kg",
                        color: color,
                        textSize: 21,
                        isTitle: true,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final User? user = authInstance.currentUser;
                              if (user == null) {
                                GlobalMethods.errorDialog(subTitle: 'No user found, please login first', context: context);
                                return;
                              }
                              await GlobalMethods.addToCart(productId: productModel.id, quantity: 1, context: context);
                              await cartProvider.fetchCart();
                              // cartProvider.addProductsToCart(
                              //   productId: productModel.id,
                              //   quantity: 1,
                              // );
                            },
                            child: Icon(
                              _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                              size: 22,
                              color: color,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          HeartButton(productId: productModel.id, isInWishlist: isInWishlist),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              PriceWidget(
                salePrice: productModel.salePrice,
                price: productModel.price,
                textPrice: '1',
                onSale: productModel.isOnSale,
              ),
              const SizedBox(height: 5),
              TextWidget(text: productModel.title, color: color, textSize: 16, isTitle: true),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
