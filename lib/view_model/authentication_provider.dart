import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/services/local_service.dart';
import 'package:flukefy/view/screens/home/home_screen.dart';
import 'package:flukefy/view/screens/login/phone_number_screen.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/enums/Authentication_type.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    Response result = await AuthenticationService.loginAccount(username, password);
    showToast(result.value, result.isSuccess);
    if (result.isSuccess) {
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    }
    return result.isSuccess;
  }

  Future<bool> createAccount(String name, String phoneNumber, String username, String password, String confirmPassword) async {
    Response result =
        await AuthenticationService.createAccount(name, phoneNumber, username.toLowerCase(), password, confirmPassword);
    showToast(result.value, result.isSuccess);
    if (result.isSuccess) {
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    }
    return result.isSuccess;
  }

  void signInWithPlatforms(BuildContext context, AuthenticationType type) async {
    User? user;
    if (type == AuthenticationType.google) {
      showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
      user = await AuthenticationService.signInWithGoogle();
      //Dismiss loading dialog
      Navigator.pop(context);
      var userIsExists = await FirebaseService.getUserWithDocId(user!.id!);
      if (userIsExists != null) {
        // Save SharedPreferences
        LocalService.saveUser(user.id!);

        showToast('Logged in', true);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
      } else {
        showToast('Phone number is unavailable', false);
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => PhoneNumberScreen(user: user!)), (route) => false);
      }
    } else if (type == AuthenticationType.facebook) {
      // user = await AuthenticationService.signInWithFacebook();
      showToast('Facebook service currently unavailable', false);
    } else if (type == AuthenticationType.guest) {
      // user = await AuthenticationService.signInWithFacebook();
      showToast('Guest account unavailable', false);
    }
  }

  Future<bool> addPhoneNumberToGoogle(BuildContext context, User user) async {
    Response result = await FirebaseService.uploadUser(user);
    showToast(result.value, result.isSuccess);
    if (result.isSuccess) {
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    }
    return result.isSuccess;
  }

  void showToast(String text, bool isSuccess) {
    Fluttertoast.showToast(
      msg: isSuccess ? 'Logged in' : text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      textColor: Colors.white,
      webPosition: "center",
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      webBgColor: isSuccess ? "linear-gradient(to right, #4CAF50, #4CAF50)" : "linear-gradient(to right, #F44336, #F44336)",
    );
  }
}
