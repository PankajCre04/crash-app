import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/consts/firebase_consts.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // void addProductsToCart({required String productId, required int quantity}) {
  //   _cartItems.putIfAbsent(
  //     productId,
  //     () => CartModel(id: DateTime.now().toString(), productId: productId, quantity: quantity),
  //   );
  //   notifyListeners();
  // }

  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final length = userDoc.get('userCart').length;
    for (int i = 0; i < length; i++) {
      _cartItems.putIfAbsent(
        userDoc.get('userCart')[i]['productId'],
        () => CartModel(
          id: userDoc.get('userCart')[i]['cartId'],
          productId: userDoc.get('userCart')[i]['productId'],
          quantity: userDoc.get('userCart')[i]['quantity'],
        ),
      );
    }
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(id: value.id, productId: productId, quantity: value.quantity - 1),
    );
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(id: value.id, productId: productId, quantity: value.quantity + 1),
    );
    notifyListeners();
  }

  Future<void> removeOneItem({required String cartId, required String productId, required int quantity}) async {
    final User? user = authInstance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
      {
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ]),
      },
    );
    _cartItems.remove(productId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    final User? user = authInstance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'userCart': [],
    });
    _cartItems.clear();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
