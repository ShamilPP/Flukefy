import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/brand.dart';
import '../model/result.dart';

class BrandsProvider extends ChangeNotifier {
  Brand _selectedBrand = Brand(docId: 'All', name: 'All');
  List<Brand> _brands = [];
  Status _brandsStatus = Status.loading;

  Brand get selectedBrand => _selectedBrand;

  List<Brand> get brands => _brands;

  Status get brandsStatus => _brandsStatus;

  void loadBrands() {
    FirebaseService.getAllBrands().then((result) {
      _brandsStatus = result.status;
      if (_brandsStatus == Status.success && result.data != null) {
        _brands = result.data!;
      } else {
        _brands = [];
      }
      notifyListeners();
    });
  }

  void setBrand(Brand brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  List<Product> getBrandProducts(String brandId, List<Product> allProducts) {
    List<Product> brandProducts = [];
    for (var product in allProducts) {
      if (product.brandId == brandId) {
        brandProducts.add(product);
      }
    }
    if (brandProducts.isEmpty) {
      brandProducts = allProducts.toList()..shuffle();
    }
    return brandProducts;
  }
}
