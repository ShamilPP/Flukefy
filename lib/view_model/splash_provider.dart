import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flukefy/utils/constant.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
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
    // For checking internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      String? userId = await userProvider.getUserIdFromLocal();
      Result serverUpdateCode = await FirebaseService.getUpdateCode();
      if (serverUpdateCode.data == updateCode) {
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
      } else {
        if (serverUpdateCode.status == Status.success) {
          // If update code is not matching, show update dialog
          showUpdateDialog(context, 'Update is available', 'Please update to latest version');
        } else {
          // If update code fetching problem, show error in dialog
          showUpdateDialog(context, 'Error', 'Message : ${serverUpdateCode.message!}');
        }
      }
    } else {
      // If not connected network
      // Avoid sudden dialog
      await Future.delayed(const Duration(seconds: 2));
      showUpdateDialog(context, 'Connection problem', 'Please check your internet connection');
    }
  }

  void loadFromFirebase(BuildContext context, String userId) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    Provider.of<BrandsProvider>(context, listen: false).loadBrands();
    Provider.of<CartProvider>(context, listen: false).loadCart(userId);
  }

  void showUpdateDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
              // Reload functions
              init(context);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
