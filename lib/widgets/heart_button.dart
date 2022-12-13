import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:food_app/provider/product_provider.dart';
import 'pac\kage:food_app/provider/wishlist_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:provider/provider.dart';

class HeartButton extends StatelessWidget {
  HeartButton({Key? key, required this.productId, this.isInWishlist = false}) : super(key: key);
  final String productId;
  final bool? isInWishlist;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findById(productId);
    return GestureDetector(
      onTap: () async {
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(subTitle: 'No user found, please login first', context: context);
            return;
          }
          if (isInWishlist == false && isInWishlist != null) {
            GlobalMethods.addToWishlist(productId: productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
              wishlistId: wishlistProvider.getWishlistItems[getCurrentProduct.id]!.id,
              productId: productId,
            );
          }
          await wishlistProvider.fetchWishlist();
        } catch (error) {
        } finally {}
      },
      child: Icon(
        isInWishlist != null && isInWishlist == true ? IconlyBold.heart : IconlyLight.heart,
        size: 22,
        color: isInWishlist != null && isInWishlist == true ? Colors.red : color,
      ),
    );
  }
}
