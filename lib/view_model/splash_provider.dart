import 'package:flukefy/utils/constant.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/result.dart';
import '../model/user.dart';
import '../services/firebase_service.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/introduction/introduction_screen.dart';
import 'auth_provider.dart';
import 'brands_provider.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = await userProvider.getUserIdFromLocal();
    Result serverUpdateCode = await FirebaseService.getUpdateCode();

    if (serverUpdateCode.data != updateCode) {
      // If this is not matching update code show update dialog
      if (serverUpdateCode.status != Status.success) showToast(serverUpdateCode.message!, Colors.red);
      showUpdateDialog(context);
    } else {
      Result<User>? userResult;
      if (userId != null) userResult = await FirebaseService.getUserWithDocId(userId);
      if (userResult != null && userResult.status == Status.success && userResult.data != null) {
        // Set user in user provider
        userProvider.setUser(userResult.data!);
        // Update last seen in firebase
        FirebaseService.updateUserLastLogged(userResult.data!.docId!);
        // Load products, carts and brands
        loadFromFirebase(context, userResult.data!.docId!);
        // Go to home screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        await Provider.of<AuthProvider>(context, listen: false).logout();
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
