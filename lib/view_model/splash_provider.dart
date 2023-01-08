import 'package:flukefy/utils/constant.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/response.dart';
import '../model/user.dart';
import '../services/firebase_service.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/introduction/introduction_screen.dart';
import 'authentication_provider.dart';
import 'brands_provider.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      String? userId = await userProvider.getUserIdFromLocal();
      int serverUpdateCode = await getUpdateCode();
      if (serverUpdateCode != updateCode) {
        // If this is not matching update code show update dialog
        showUpdateDialog(context);
      } else {
        if (userId != null) {
          User? user = await FirebaseService.getUserWithDocId(userId);
          if (user != null) {
            userProvider.setUser(user);
            loadFromFirebase(context, userId);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            await Provider.of<AuthenticationProvider>(context, listen: false).logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
        }
      }
    });
  }

  void loadFromFirebase(BuildContext context, String userId) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    Provider.of<BrandsProvider>(context, listen: false).loadBrands();
    Provider.of<CartProvider>(context, listen: false).loadCart(userId);
  }

  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Update is available'),
        content: const Text('Please update to latest version'),
        actions: [
          ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<int> getUpdateCode() async {
    Response response = await FirebaseService.getUpdateCode();
    if (response.isSuccess) {
      return response.value;
    } else {
      Fluttertoast.showToast(
        msg: response.value,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0,
        textColor: Colors.white,
        webPosition: "center",
        backgroundColor: Colors.red,
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
      );
      return -1; // -1 is error code
    }
  }
}
