import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/inner_screens/product_details.dart';
import 'package:food_app/models/product_model.dart';
import 'package:food_app/provider/wishlist_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/heart_button.dart';
import 'package:food_app/widgets/price_widget.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../provider/cart_provider.dart';
import '../services/global_methods.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);
  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final TextEditingController _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetails.routeName, arguments: productModel.id);
            // GlobalMethods.navigateTo(context: context, routeName: ProductDetails.routeName);
          },
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.22,
                width: size.width * 0.22,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        textSize: 16,
                        isTitle: true,
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: HeartButton(
                          productId: productModel.id,
                          isInWishlist: isInWishlist,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: FittedBox(
                        child: PriceWidget(
                          salePrice: productModel.salePrice,
                          price: productModel.price,
                          textPrice: _quantityTextController.text,
                          onSale: productModel.isOnSale,
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                    Flexible(
                        child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: FittedBox(
                            child: TextWidget(
                              text: productModel.isPiece ? "Piece" : "Kg",
                              color: color,
                              textSize: 18,
                              isTitle: true,
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: TextFormField(
                            controller: _quantityTextController,
                            keyboardType: TextInputType.number,
                            key: const ValueKey('10'),
                            maxLines: 1,
                            enabled: true,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: TextStyle(color: color),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isInCart
                      ? null
                      : () async {
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(subTitle: 'No user found, please login first', context: context);
                            return;
                          }
                          await GlobalMethods.addToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context,
                          );
                          await cartProvider.fetchCart();
                          // cartProvider.addProductsToCart(
                          //   productId: productModel.id,
                          //   quantity: int.parse(_quantityTextController.text),
                          // );
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  child: TextWidget(
                    text: isInCart ? 'In cart' : "Add to cart",
                    color: color,
                    textSize: 17,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
