import 'package:flukefy/model/order_address.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyProvider extends ChangeNotifier {
  int _page = 1;
  OrderAddress? _address;

  int get page => _page;

  OrderAddress? get address => _address;

  loadAddress(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) _address = OrderAddress(name: user.name, phone: user.phone);
    // getMoreDataFromLocalDB --comingSoon
  }

  void setPage(int newPage) async {
    _page = newPage;
    notifyListeners();
  }

  void setAddress(OrderAddress newAddress) async {
    _address = newAddress;
  }
}
