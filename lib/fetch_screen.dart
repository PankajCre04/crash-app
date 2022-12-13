import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/consts/const_data.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/provider/wishlist_provider.dart';
import 'package:food_app/screens/bottom_bar_screen.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);
  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = ConstData.authImagesPaths;
  @override
  void initState() {
    images.shuffle();
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final User? user = authInstance.currentUser;
    Future.delayed(const Duration(microseconds: 5), () async {
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearCart();
        wishlistProvider.clearWishlist();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return const BottomBarScreen();
        }),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
