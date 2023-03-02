import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/enums/status.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  Status _productsStatus = Status.loading;

  List<Product> get products => _products;

  Status get productsStatus => _productsStatus;

  void loadProducts() {
    FirebaseService.getAllProducts().then((result) {
      _products = result;
      _productsStatus = Status.completed;
      notifyListeners();
    });
  }

  void errorToast() {
    Fluttertoast.showToast(msg: 'Something went wrong', backgroundColor: Colors.red);
  }
}
