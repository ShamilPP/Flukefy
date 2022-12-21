import 'package:flukefy/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/cart.dart';
import '../model/enums/status.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _carts = [];
  Status _cartsStatus = Status.loading;

  List<Cart> get carts => _carts;

  Status get cartsStatus => _cartsStatus;

  Future addToCart(Cart newCart) async {
    _carts.add(newCart);
    await FirebaseService.uploadCart(newCart);
    notifyListeners();
  }

  void loadCart(String userId) async {
    FirebaseService.getCarts(userId).then((result) {
      _carts = result;
      _cartsStatus = Status.success;
      notifyListeners();
    });
  }
}
