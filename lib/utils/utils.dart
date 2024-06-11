import 'package:flukefy/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

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

  static void showErrorDialog(BuildContext context, {required String title, required String message, VoidCallback? onRetryPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsPadding: EdgeInsets.only(right: 15, bottom: 15),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor, foregroundColor: AppColors.secondaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
              if (onRetryPressed != null) onRetryPressed();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  static List<Product> getBrandProducts(String brandId, List<Product> allProducts) {
    List<Product> brandProducts = [];
    for (var product in allProducts) {
      if (product.brandId == brandId) {
        brandProducts.add(product);
      }
    }
    return brandProducts;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    bool result1 =
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(this);
    bool result2 = false;
    if (length > 10) {
      result2 = substring(length - 10) == '@gmail.com';
    }
    return result1 && result2;
  }
}