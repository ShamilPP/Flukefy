import 'package:flukefy/services/remote/firebase/brand_service.dart';
import 'package:flukefy/utils/app_default.dart';
import 'package:flutter/material.dart';

import '../model/brand.dart';
import '../model/result.dart';

class BrandsProvider extends ChangeNotifier {
  Result<List<Brand>> _brands = Result();

  Result<List<Brand>> get brands => _brands;

  Brand _selectedBrand = AppDefault.defaultNewBrand;

  Brand get selectedBrand => _selectedBrand;

  void loadBrands() async {
    _brands.setStatus(ResultStatus.loading);
    notifyListeners();
    try {
      _brands = await BrandService.getAllBrands();
      notifyListeners();
    } catch (e) {
      _brands.setStatus(ResultStatus.failed);
      notifyListeners();
    }
  }

  void setSelectedBrand(Brand brand) {
    _selectedBrand = brand;
    notifyListeners();
  }
}
