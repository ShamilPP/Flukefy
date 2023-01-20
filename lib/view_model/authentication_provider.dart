import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/services/local_service.dart';
import 'package:flukefy/utils/extensions/extension.dart';
import 'package:flukefy/view/screens/login/phone_number_screen.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../model/enums/Authentication_type.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  Future<bool> login(String email, String password) async {
    // Verify that the user entered valid values
    if (!email.isValidEmail()) {
      showToast('Invalid email', Colors.red);
      return false;
    } else if (password == '') {
      showToast('Invalid password', Colors.red);
      return false;
    }

    // Login account using firebase
    Response result = await AuthenticationService.signWithEmail(email, password);
    if (result.isSuccess) {
      showToast('Logged in', Colors.green);
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    } else {
      showToast(result.value, Colors.red);
    }
    return result.isSuccess;
  }

  Future<bool> createAccount(String name, String phoneNumber, String email, String password, String confirmPassword) async {
    // Verify that the user entered valid values
    if (name == '') {
      showToast('Invalid name', Colors.red);
      return false;
    } else if (phoneNumber == '') {
      showToast('Invalid phone number', Colors.red);
      return false;
    } else if (!email.isValidEmail()) {
      showToast('Invalid email', Colors.red);
      return false;
    } else if (password == '') {
      showToast('Invalid password', Colors.red);
      return false;
    } else if (password != confirmPassword) {
      showToast('Confirm password incorrect', Colors.red);
      return false;
    } else if (int.tryParse(phoneNumber) == null || phoneNumber.length != 10) {
      showToast('Entered mobile number is invalid', Colors.red);
      return false;
    }

    // Check Phone number is already exists
    bool numberAlreadyExists = await FirebaseService.checkIfNumberAlreadyExists(int.parse(phoneNumber));
    if (numberAlreadyExists) {
      showToast('Phone number already exists', Colors.red);
      return false;
    }

    // and finally create account using firebase
    User user = User(name: name, phoneNumber: int.parse(phoneNumber), email: email);
    Response result = await AuthenticationService.createAccount(user, password);
    if (result.isSuccess) {
      showToast('Logged in', Colors.green);
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    } else {
      showToast(result.value, Colors.red);
    }
    return result.isSuccess;
  }

  void signInWithPlatforms(BuildContext context, AuthenticationType type) async {
    User? user;
    if (type == AuthenticationType.google) {
      // Show loading dialog
      showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
      user = await AuthenticationService.signInWithGoogle();
      // Dismiss loading dialog
      Navigator.pop(context);
      var userIsExists = await FirebaseService.getUserWithDocId(user!.id!);
      // ask user for phone number if not current in firebase
      if (userIsExists == null) {
        showToast('Phone number is unavailable', Colors.red);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => PhoneNumberScreen(user: user!)),
          (route) => false,
        );
      } else {
        // Save SharedPreferences
        LocalService.saveUser(user.id!);
        // Show Toast
        showToast('Logged in', Colors.green);
        // Go to Splash screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      }
    } else if (type == AuthenticationType.facebook) {
      // user = await AuthenticationService.signInWithFacebook();
      showToast('Facebook service currently unavailable', Colors.red);
    } else if (type == AuthenticationType.guest) {
      // user = await AuthenticationService.signInWithFacebook();
      showToast('Guest account unavailable', Colors.red);
    }
  }

  // Upload to Firebase after checking the phone number
  // When using a Google account to log in, the phone number does not get. It asks the user for their phone number and upload it to Firebase
  Future<bool> addPhoneNumberToGoogle(BuildContext context, User user) async {
    // Check Phone number is already exists
    bool numberAlreadyExists = await FirebaseService.checkIfNumberAlreadyExists(user.phoneNumber);
    if (numberAlreadyExists) {
      showToast('Phone number already exists', Colors.red);
      return false;
    }

    // Upload user to firebase
    Response result = await FirebaseService.uploadUser(user);
    if (result.isSuccess) {
      showToast('Logged in', Colors.green);
      // Save SharedPreferences
      LocalService.saveUser(result.value);
    } else {
      showToast(result.value, Colors.red);
    }
    return result.isSuccess;
  }

  // Logout
  Future<bool> logout() {
    return LocalService.removeUser();
  }
}
