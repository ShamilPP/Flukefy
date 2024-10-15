import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flukefy/services/remote/firebase/user_service.dart';
import 'package:flukefy/utils/app_default.dart';
import 'package:flukefy/utils/app_details.dart';
import 'package:flukefy/view/widgets/dialog/custom_dialog.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/result.dart';
import '../model/user.dart';
import '../services/remote/firebase/update_service.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/introduction/introduction_screen.dart';
import 'auth_provider.dart';
import 'brands_provider.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) async {
    try {
      // For checking internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        String? userId = await userProvider.getUserIdFromLocal();
        Result serverUpdateCode = await UpdateService.getUpdateCode();
        // This is checking for any new updates that are available
        if (serverUpdateCode.data == AppDetails.updateCode) {
          Result<User>? userResult;
          if (userId != null) userResult = await UserService.getUserWithDocId(userId);
          if (userResult != null && userResult.status == ResultStatus.success && userResult.data != null) {
            DateTime currentTime = DateTime.now();
            // Set user in user provider
            userProvider.setUser(userResult.data!);
            // Update last seen in firebase
            UserService.updateUserLastLogged(userResult.data!.docId!, currentTime);
            // Load products, carts and brands
            loadFromFirebase(context, userResult.data!.docId!);
            // Go to home screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            await Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
          }
        } else {
          if (serverUpdateCode.status == ResultStatus.success) {
            // If update code is not matching, show update dialog
            showDialog(
                context: context,
                builder: (_) => CustomDialog(
                  title: 'Update is available',
                  content: Text('Please update to latest version'),
                  buttonText: 'Retry',
                  onButtonPressed: () {
                    // Reload functions
                    init(context);
                  },
                ));
          } else {
            // If update code fetching problem, show error in dialog
            showDialog(
                context: context,
                builder: (_) => CustomDialog(
                  title: 'Operation Failed',
                  content: Text('An error occurred : ${serverUpdateCode.message!}'),
                  buttonText: 'Retry',
                  onButtonPressed: () {
                    // Reload functions
                    init(context);
                  },
                ));
          }
        }
      } else {
        // If not connected network
        // Avoid sudden dialog
        await Future.delayed(const Duration(seconds: 2));
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                  title: 'Connection problem',
                  content: Text('Please check your internet connection'),
                  buttonText: 'Retry',
                  onButtonPressed: () {
                    // Reload functions
                    init(context);
                  },
                ));
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => CustomDialog(
            title: 'Operation Failed',
            content: Text('An error occurred : $e'),
            buttonText: 'Retry',
            onButtonPressed: () {
              // Reload functions
              init(context);
            },
          ));
    }
  }

  void loadFromFirebase(BuildContext context, String userId) async {
    var productProvider = Provider.of<ProductsProvider>(context, listen: false);
    productProvider.loadProducts().then((value) {
      productProvider.loadBrandProducts(AppDefault.defaultNewBrand);
    });

    Provider.of<BrandsProvider>(context, listen: false).loadBrands();
    Provider.of<CartProvider>(context, listen: false).loadCart(userId);
  }
}
