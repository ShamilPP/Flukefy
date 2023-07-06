import 'package:flukefy/model/address.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyProvider extends ChangeNotifier {
  int _page = 1;
  Address? _adress;

  int get page => _page;

  Address? get address => _adress;

  void init(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    _adress = Address(name: user.name, phone: user.phone);
    // getMoreDataFromLocalDB --comingSoon
  }

  void setPage(int newPage) async {
    _page = newPage;
    notifyListeners();
  }
}
