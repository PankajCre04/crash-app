import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/inner_screens/product_details.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/heart_button.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../models/wishlist_model.dart';
import '../../provider/wishlist_provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    final size = Utils(context: context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct = productProvider.findById(wishlistModel.productId);
    final usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName, arguments: wishlistModel.productId);
      },
      child: Container(
        height: size.height * 0.20,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          border: Border.all(color: color, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 8.0),
                width: size.width * 0.23,
                height: size.width * 0.25,
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.imageUrl,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(IconlyLight.bag2),
                        ),
                        HeartButton(productId: getCurrentProduct.id, isInWishlist: isInWishlist),
                      ],
                    ),
                  ),
                  TextWidget(
                    text: getCurrentProduct.title,
                    color: color,
                    textSize: 20,
                    maxLines: 2,
                    isTitle: true,
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: "\$${usedPrice}",
                    color: color,
                    textSize: 16,
                    maxLines: 1,
                    isTitle: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
