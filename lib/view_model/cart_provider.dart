import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/cart.dart';
import '../model/result.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _carts = [];
  Status _cartsStatus = Status.loading;

  List<Cart> get carts => _carts;

  Status get cartsStatus => _cartsStatus;

  void loadCart(String userId) async {
    FirebaseService.getAllCarts(userId).then((result) {
      _cartsStatus = result.status;
      if (_cartsStatus == Status.success && result.data != null) {
        _carts = result.data!;
      } else {
        _carts = [];
      }
      notifyListeners();
    });
  }

  Future addToCart(Cart newCart) async {
    _carts.add(newCart);
    await FirebaseService.uploadCart(newCart);
    notifyListeners();
  }

  Future removeCart(BuildContext context, Product product) async {
    int cartIndex = _carts.indexWhere((element) => element.productId == product.docId);
    if (cartIndex == -1) {
      Fluttertoast.showToast(msg: 'Error');
    } else {
      Cart cart = _carts[_carts.indexWhere((element) => element.productId == product.docId)];
      _carts.remove(cart);
      showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
      await FirebaseService.removeCart(cart);
      Navigator.pop(context);
      notifyListeners();
    }
  }
}
