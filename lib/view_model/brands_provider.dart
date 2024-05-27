import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/utils/app_default.dart';
import 'package:flutter/material.dart';

import '../model/brand.dart';
import '../model/result.dart';

class BrandsProvider extends ChangeNotifier {
  Brand _selectedBrand = AppDefault.defaultNewBrand;
  List<Brand> _brands = [];
  ResultStatus _brandsStatus = ResultStatus.loading;

  Brand get selectedBrand => _selectedBrand;

  List<Brand> get brands => _brands;

  ResultStatus get brandsStatus => _brandsStatus;

  void loadBrands() {
    FirebaseService.getAllBrands().then((result) {
      _brandsStatus = result.status;
      if (_brandsStatus == ResultStatus.success && result.data != null) {
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
}
