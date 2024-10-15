import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/remote/firebase/cart_service.dart';
import 'package:flukefy/utils/utils.dart';
import 'package:flutter/material.dart';

import '../model/cart.dart';
import '../model/result.dart';

class CartProvider extends ChangeNotifier {
  Result<List<Cart>> _carts = Result();

  Result<List<Cart>> get carts => _carts;
  void loadCart(String userId) async {
    _carts.setStatus(ResultStatus.loading);
    notifyListeners();
    try {
      _carts = await CartService.getAllCarts(userId);
      notifyListeners();
    } catch (e) {
      _carts.setStatus(ResultStatus.failed);
      notifyListeners();
    }
  }

  Future addToCart(Cart newCart) async {
    try {
      _carts.data!.add(newCart);
      await CartService.uploadCart(newCart);
      notifyListeners();
    } catch (e) {
      Utils.showToast(e.toString(), Colors.red);
    }
  }

  Future removeCart(BuildContext context, Product product) async {
    try {
      int cartIndex = _carts.data!.indexWhere((element) => element.productId == product.docId);
      if (cartIndex != -1) {
        Cart cart = _carts.data![_carts.data!.indexWhere((element) => element.productId == product.docId)];
        _carts.data!.remove(cart);
        showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
        await CartService.removeCart(cart);
        Navigator.pop(context);
        notifyListeners();
      } else {
        Utils.showToast("Can't found this item", Colors.red);
      }
    } catch (e) {
      Utils.showToast(e.toString(), Colors.red);
    }
  }
}
