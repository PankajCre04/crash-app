import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/inner_screens/product_details.dart';
import 'package:food_app/models/cart_model.dart';
import 'package:food_app/models/product_model.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/heart_button.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.quantity}) : super(key: key);
  final int quantity;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final TextEditingController _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final Size size = Utils(context: context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findById(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final usedPrice = getCurrProduct.isOnSale ? getCurrProduct.salePrice : getCurrProduct.price;
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName, arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.imageUrl,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(text: getCurrProduct.title.toString(), color: color, textSize: 17),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: size.width * 0.3,
                        child: Row(
                          children: [
                            _quantityController(
                                func: () {
                                  if (_quantityTextController.text == "1") {
                                    return;
                                  } else {
                                    cartProvider.reduceQuantityByOne(cartModel.productId);
                                    setState(() {
                                      _quantityTextController.text = (int.parse(_quantityTextController.text) - 1).toString();
                                    });
                                  }
                                },
                                icon: CupertinoIcons.minus,
                                color: Colors.red),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _quantityTextController,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(),
                                )),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _quantityTextController.text = '1';
                                    } else {
                                      return;
                                    }
                                  });
                                },
                              ),
                            ),
                            _quantityController(
                                func: () {
                                  cartProvider.increaseQuantityByOne(cartModel.productId);
                                  setState(() {
                                    _quantityTextController.text = (int.parse(_quantityTextController.text) + 1).toString();
                                  });
                                },
                                icon: CupertinoIcons.plus,
                                color: Colors.green),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await cartProvider.removeOneItem(
                              cartId: cartModel.id,
                              productId: cartModel.productId,
                              quantity: cartModel.quantity,
                            );
                          },
                          child: const Icon(
                            CupertinoIcons.cart_badge_minus,
                            color: Colors.red,
                            size: 27,
                          ),
                        ),
                        const SizedBox(height: 5),
                        HeartButton(productId: getCurrProduct.id, isInWishlist: isInWishlist),
                        const SizedBox(height: 5),
                        TextWidget(
                          text: "\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}",
                          color: color,
                          textSize: 17,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({required Function func, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: InkWell(
              onTap: () {
                func();
              },
              borderRadius: BorderRadius.circular(10),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
