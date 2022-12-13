import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_app/provider/wishlist_provider.dart';
import 'package:food_app/screens/cart/cart_widget.dart';
import 'package:food_app/screens/wishlist/wishlist_widget.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/back_widget.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_provider.dart';
import '../../services/global_methods.dart';
import '../../widgets/empty_screen.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final Size size = Utils(context: context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList = wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/wishlist.png',
            title: 'Your Wishlist Is Empty',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a wish',
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leading: const BackWidget(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(text: "Wishlist (${wishlistItemsList.length})", color: color, textSize: 20, isTitle: true),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                        title: "Empty your Wishlist",
                        subTitle: "Are you sure?",
                        func: () async {
                          await wishlistProvider.clearOnlineWishlist();
                          wishlistProvider.clearWishlist();
                        },
                        context: context,
                      );
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    )),
              ],
            ),
            body: MasonryGridView.count(
                itemCount: wishlistItemsList.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChangeNotifierProvider.value(
                      value: wishlistItemsList[index],
                      child: WishlistWidget(),
                    ),
                  );
                }),
          );
  }
}
