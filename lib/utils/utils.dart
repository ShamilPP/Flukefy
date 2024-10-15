import 'package:flukefy/model/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utils {
  static void showToast(String text, Color? backgroundColor) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      textColor: Colors.white,
      webPosition: "center",
      backgroundColor: backgroundColor,
    );
  }

  /// Retrieves a list of products that belong to a specific brand.
  ///
  /// This method filters all the products based on the provided [brandId]
  /// and returns a list of products that match the given brand.
  ///
  /// Parameters:
  /// - [brandId]: The ID of the brand to filter the products by.
  /// - [allProducts]: The list of all products to filter from.
  ///
  /// Returns:
  /// - A list of products that belong to the specified brand.
  static List<Product> getBrandProducts(String brandId, List<Product> allProducts) {
    // Initialize an empty list to store the products of the specified brand
    List<Product> brandProducts = [];

    // Iterate through all the products
    for (var product in allProducts) {
      // Check if the product's brandId matches the provided brandId
      if (product.brandId == brandId) {
        // Add the product to the brandProducts list
        brandProducts.add(product);
      }
    }

    // Return the list of products that belong to the specified brand
    return brandProducts;
  }
}
