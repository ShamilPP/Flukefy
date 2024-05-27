import 'package:flukefy/model/product.dart';
import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/utils/app_default.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../model/brand.dart';
import '../model/result.dart';

class ProductsProvider extends ChangeNotifier {
  Result<List<Product>> _products = Result();

  Result<List<Product>> get products => _products;

  Result<List<Product>> _brandProducts = Result();

  Result<List<Product>> get brandProducts => _brandProducts;

  Result<List<Product>> _similarProducts = Result();

  Result<List<Product>> get similarProducts => _similarProducts;

  Future loadProducts() async {
    _products.setStatus(ResultStatus.loading);
    notifyListeners();
    try {
      _products = await FirebaseService.getAllProducts();
      notifyListeners();
    } catch (e) {
      _products.setStatus(ResultStatus.failed);
      notifyListeners();
    }
  }

  void loadBrandProducts(Brand selectedBrand) {
    _brandProducts.setStatus(ResultStatus.loading);
    notifyListeners();
    try {
      if (products.status == ResultStatus.success) {
        // If selected "New" to show new products
        if (selectedBrand == AppDefault.defaultNewBrand) {
          _brandProducts.data = _products.data!;
          _brandProducts.data!.sort((a, b) => b.createdTime.compareTo(a.createdTime));
          _brandProducts.setStatus(ResultStatus.success);
        } else {
          var list = Helper.getBrandProducts(selectedBrand.docId!, products.data!);
          if (list.isNotEmpty) {
            _brandProducts.data = list;
            _brandProducts.setStatus(ResultStatus.success);
          } else {
            _brandProducts.setMessage('No products that you selected Brand');
            _brandProducts.setStatus(ResultStatus.failed);
          }
        }
      } else {
        _brandProducts.setMessage('Products fetching failed');
        _brandProducts.setStatus(ResultStatus.failed);
      }
      notifyListeners();
    } catch (e) {
      _brandProducts.setMessage(e.toString());
      _brandProducts.setStatus(ResultStatus.failed);
      notifyListeners();
    }
  }

  void loadSimilarProducts(Product product) {
    _similarProducts.setStatus(ResultStatus.loading);
    notifyListeners();
    try {
      List<Product> list = Helper.getBrandProducts(product.brandId, products.data!);
      list.remove(product);
      if (list.isNotEmpty) {
        _similarProducts.data = list;
        _similarProducts.setStatus(ResultStatus.success);
      } else {
        _similarProducts.setMessage('No products');
        _similarProducts.setStatus(ResultStatus.failed);
      }
      notifyListeners();
    } catch (e) {
      _similarProducts.setMessage(e.toString());
      _similarProducts.setStatus(ResultStatus.failed);
      notifyListeners();
    }
  }
}
