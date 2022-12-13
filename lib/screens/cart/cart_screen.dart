import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:food_app/provider/orders_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/screens/cart/cart_widget.dart';
import 'package:food_app/widgets/empty_screen.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../provider/cart_provider.dart';
import '../../services/global_methods.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final Size size = Utils(context: context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    // final orderProvider = Provider.of<OrdersProvider>(context);
    final cartItemList = cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/cart.png',
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: "Shop Now",
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(text: "Cart (${cartItemList.length})", color: color, textSize: 20, isTitle: true),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                        title: "Empty your cart",
                        subTitle: "Are you sure?",
                        func: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearCart();
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
            body: Column(
              children: [
                _checkOut(context: context, size: size, color: color),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: cartItemList[index],
                          child: CartWidget(
                            quantity: cartItemList[index].quantity,
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }

  Widget _checkOut({required BuildContext context, required Size size, required Color color}) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context, listen: false);
    double total = 0.0;

    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProduct = productProvider.findById(value.productId);
      total += (getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price) * value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(7),
              child: InkWell(
                onTap: () async {
                  try {
                    User? user = authInstance.currentUser;
                    final orderId = Uuid().v4();
                    final productProvider = Provider.of<ProductsProvider>(context, listen: false);

                    cartProvider.getCartItems.forEach((key, value) async {
                      try {
                        final getCurrentProduct = productProvider.findById(value.productId);
                        await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
                          'orderId': orderId,
                          'userId': user!.uid,
                          'productId': value.productId,
                          'price': (getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price) * value.quantity,
                          'totalPrice': total,
                          'quantity': value.quantity,
                          'imageUrl': getCurrentProduct.imageUrl,
                          'userName': user.displayName,
                          'orderDate': Timestamp.now(),
                        });
                        await cartProvider.clearOnlineCart();
                        cartProvider.clearCart();
                        await Fluttertoast.showToast(
                          msg: "Your order has been placed",
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } catch (error) {
                        GlobalMethods.errorDialog(subTitle: error.toString(), context: context);
                      } finally {}
                    });
                  } catch (error) {
                    GlobalMethods.errorDialog(subTitle: error.toString(), context: context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(text: "Order Now", color: Colors.white, textSize: 16),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(text: 'Total \$${total.toStringAsFixed(2)}', color: color, textSize: 17, isTitle: true),
            ),
          ],
        ),
      ),
    );
  }
}
