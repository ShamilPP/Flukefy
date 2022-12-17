import 'package:flukefy/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brands_provider.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    Provider.of<BrandsProvider>(context, listen: false).loadBrands();
  }

  Future<bool> userIsLoggedIn() async {
    String? docId = await LocalService.getUser();
    return docId != null;
  }
}
