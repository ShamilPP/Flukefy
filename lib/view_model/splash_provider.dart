import 'package:flukefy/utils/constant.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void init(BuildContext context) async {
    User? user;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = await userProvider.getUserIdFromLocal();
    Response serverUpdateCode = await FirebaseService.getUpdateCode();
    if (userId != null) user = await FirebaseService.getUserWithDocId(userId);

    if (serverUpdateCode.result != updateCode) {
      // If this is not matching update code show update dialog
      if (!serverUpdateCode.isSuccess) showToast(serverUpdateCode.msg!, Colors.red);
      showUpdateDialog(context);
    } else {
      if (user != null) {
        userProvider.setUser(user);
        loadFromFirebase(context, user.id!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        await Provider.of<AuthenticationProvider>(context, listen: false).logout();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
      }
    }
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
}
