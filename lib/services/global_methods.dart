import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static navigateTo({required BuildContext context, required String routeName}) {
    Navigator.pushNamed(context, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subTitle,
    required Function func,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/warning-sign.png",
                  height: 22,
                  width: 22,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title)
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    func();
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subTitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/warning-sign.png",
                  height: 22,
                  width: 22,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Error Occured')
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Ok")),
            ],
          );
        });
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update(
        {
          'userCart': FieldValue.arrayUnion(
            [
              {
                'cartId': cartId,
                'productId': productId,
                'quantity': quantity,
              }
            ],
          ),
        },
      );
      await Fluttertoast.showToast(
        msg: "Item has been added to your cart",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (error) {
      errorDialog(subTitle: error.toString(), context: context);
    }
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update(
        {
          'userWish': FieldValue.arrayUnion(
            [
              {
                'wishlistId': wishlistId,
                'productId': productId,
              }
            ],
          ),
        },
      );
      await Fluttertoast.showToast(
        msg: "Item has been added to your wishlist",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (error) {
      errorDialog(subTitle: error.toString(), context: context);
    }
  }
}
