import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/brand.dart';
import '../model/enums/status.dart';

class BrandsProvider extends ChangeNotifier {
  Brand _selectedBrand = Brand(docId: 'All', name: 'All');
  List<Brand> _brands = [];
  Status _brandStatus = Status.loading;
  List<Product> _selectedBrandProducts = [];

  Brand get selectedBrand => _selectedBrand;

  List<Brand> get brands => _brands;

  Status get brandStatus => _brandStatus;

  List<Product> get selectedBrandProducts => _selectedBrandProducts;

  void loadBrands() {
    FirebaseService.getAllBrands().then((result) {
      _brands = result;
      _brandStatus = Status.success;
      notifyListeners();
    });
  }

  void setBrand(BuildContext context, Brand brand) {
    _selectedBrand = brand;
    loadSelectedBrandProducts(context);
    notifyListeners();
  }

  void loadSelectedBrandProducts(BuildContext context) {
    _selectedBrandProducts = [];
    var allProducts = Provider.of<ProductsProvider>(context, listen: false).products;
    if (_selectedBrand.docId == 'All') {
      _selectedBrandProducts = allProducts.toList()..shuffle();
    } else {
      for (var product in allProducts) {
        if (product.brandId == _selectedBrand.docId) {
          _selectedBrandProducts.add(product);
        }
      }
    }
    if (_selectedBrandProducts.isEmpty) {
      Fluttertoast.showToast(msg: 'This brand is currently unavailable', backgroundColor: Colors.red);
      setBrand(context, Brand(docId: 'All', name: 'All'));
    }
  }
}
