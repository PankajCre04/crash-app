import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orderList = [];
  List<OrderModel> get getOrders {
    return _orderList;
  }

  Future<void> fetchOrders() async {
    await FirebaseFirestore.instance.collection('orders').get().then((QuerySnapshot ordersSnapshot) {
      _orderList = [];
      ordersSnapshot.docs.forEach((element) {
        _orderList.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ));
      });
    });
    notifyListeners();
  }
}
