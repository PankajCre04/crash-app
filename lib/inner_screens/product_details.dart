import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/provider/viewed_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/heart_button.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../provider/cart_provider.dart';
import '../provider/wishlist_provider.dart';
import '../services/global_methods.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = "/ProductDetails";
  ProductDetails({Key? key}) : super(key: key);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: "1");

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final detailedProduct = productProvider.findById(productId);
    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    double usedPrice = detailedProduct.isOnSale ? detailedProduct.salePrice : detailedProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productId);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(productId);
    return WillPopScope(
      onWillPop: () async {
        viewedProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.of(context).canPop() ? Navigator.pop(context) : Null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: detailedProduct.imageUrl,
                width: size.width,
                boxFit: BoxFit.scaleDown,
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextWidget(text: detailedProduct.title, color: color, textSize: 24, isTitle: true),
                            ),
                            HeartButton(productId: productId, isInWishlist: isInWishlist),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "\$${usedPrice.toStringAsFixed(2)}",
                              color: Colors.green,
                              textSize: 24,
                              isTitle: true,
                            ),
                            TextWidget(text: detailedProduct.isPiece ? "/Piece" : "/Kg", color: color, textSize: 14, isTitle: false),
                            const SizedBox(width: 10),
                            Visibility(
                              visible: detailedProduct.isOnSale ? true : false,
                              child: Text(
                                "\$${detailedProduct.price.toStringAsFixed(2)}",
                                style: TextStyle(color: color, fontSize: 15, decoration: TextDecoration.lineThrough),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(63, 200, 101, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Free Delivery",
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantityControl(
                            fct: () {
                              if (_quantityTextController.text == "1") {
                                return;
                              } else {
                                setState(() {
                                  _quantityTextController.text = (int.parse(_quantityTextController.text) - 1).toString();
                                });
                              }
                            },
                            color: Colors.red,
                            icon: CupertinoIcons.minus,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _quantityTextController,
                              key: const ValueKey("quantity"),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.green,
                              enabled: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = "1";
                                  } else {}
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          quantityControl(
                              fct: () {
                                setState(() {
                                  _quantityTextController.text = (int.parse(_quantityTextController.text) + 1).toString();
                                });
                              },
                              color: Colors.green,
                              icon: CupertinoIcons.plus),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Total',
                                    color: Colors.red.shade300,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text: '\$${totalPrice.toStringAsFixed(2)}',
                                          color: color,
                                          textSize: 20,
                                          isTitle: true,
                                        ),
                                        TextWidget(
                                          text: '/${_quantityTextController.text}Kg',
                                          color: color,
                                          textSize: 16,
                                          isTitle: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: _isInCart
                                      ? null
                                      : () async {
                                          final User? user = authInstance.currentUser;
                                          if (user == null) {
                                            GlobalMethods.errorDialog(subTitle: 'No user found, please login first', context: context);
                                            return;
                                          }
                                          await GlobalMethods.addToCart(
                                            productId: productId,
                                            quantity: int.parse(_quantityTextController.text),
                                            context: context,
                                          );
                                          await cartProvider.fetchCart();
                                          // cartProvider.addProductsToCart(
                                          //   productId: productId,
                                          //   quantity: int.parse(_quantityTextController.text),
                                          // );
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextWidget(
                                      text: _isInCart ? 'In cart' : "Add to Cart",
                                      color: Colors.white,
                                      textSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // enidning part ---->
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityControl({required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}
