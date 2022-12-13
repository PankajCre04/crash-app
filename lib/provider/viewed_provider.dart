import 'package:flutter/material.dart';
import 'package:food_app/models/viewed_model.dart';

class ViewedProductProvider with ChangeNotifier {
  Map<String, ViewedProductModel> _viewedProdtItemsList = {};
  Map<String, ViewedProductModel> get viewedProdtItemsList {
    return _viewedProdtItemsList;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdtItemsList.putIfAbsent(
      productId,
      () => ViewedProductModel(id: DateTime.now().toString(), productId: productId),
    );
    notifyListeners();
  }

  void clearHistory() {
    _viewedProdtItemsList.clear();
    notifyListeners();
  }
}
