import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/services/local_service.dart';
import 'package:flukefy/view/screens/login/phone_number_screen.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../model/result.dart';
import '../model/user.dart';
import '../services/auth_service.dart';

enum AuthType { guest, manually, google, facebook }

class AuthProvider extends ChangeNotifier {
  Future<Result<bool>> login(String email, String password) async {
    try {
      // Login account using firebase
      var result = await AuthService.signWithEmail(email, password);
      if (result.status == ResultStatus.success && result.data != null) {
        // The user docID is required to save the user in the shared preferences
        var user = await FirebaseService.getUserWithUID(result.data!);
        if (user.status == ResultStatus.success && user.data != null) {
          // Save user in SharedPreferences
          LocalService.saveUser(user.data!.docId!);
          return Result.success(true);
        } else {
          return Result.error(user.message!);
        }
      } else {
        return Result.error(result.message!);
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> createAccount(User user, String password) async {
    try {
      // Check Phone number is already exists
      bool numberAlreadyExists = await FirebaseService.isPhoneNumberRegistered(user.phone!);
      if (!numberAlreadyExists) {
        // Create account in firebase authentication
        var createAccountResult = await AuthService.createAccount(user, password);
        // If firebase authentication succeed then create user in firestore
        if (createAccountResult.status == ResultStatus.success) {
          // Set account created time and last logged time
          createAccountResult.data!.createdTime = DateTime.now();
          createAccountResult.data!.lastLogged = DateTime.now();
          // Create document in firebase user collection
          var uploadUserResult = await FirebaseService.uploadUser(createAccountResult.data!);
          if (uploadUserResult.status == ResultStatus.success) {
            // Save user in SharedPreferences
            LocalService.saveUser(uploadUserResult.data!.docId!);
            return Result.success(true);
          } else {
            return Result.error(uploadUserResult.message);
          }
        } else {
          return Result.error(createAccountResult.message);
        }
      } else {
        return Result.error('Phone number already exists');
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  void signInWithGoogle(BuildContext context) async {
    // Show loading dialog
    showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
    try {
      Result<User> userResult = await AuthService.signInWithGoogle();
      // Dismiss loading dialog
      Navigator.pop(context);

      if (userResult.status == ResultStatus.success && userResult.data != null) {
        User user = userResult.data!;
        // When logging into Google, the user provides a UID
        // If the UID exists in the users collection documents
        var userWithUidResult = await FirebaseService.getUserWithUID(user.uid!);
        // Null is returned if the document is not available
        // That means phone number not registered
        // Then go to Add phone number screen
        if (userWithUidResult.data == null) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PhoneNumberScreen(user: user)), (route) => false);
        } else {
          // Documents is exists, which means phone number is already exists
          // Then save user docId to shared preference
          LocalService.saveUser(userWithUidResult.data!.docId!);
          // Then Go to Splash screen
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
        }
      } else {
        // Login Failed
        Helper.showToast(userResult.message!, Colors.red);
      }
    } catch (e) {
      Helper.showToast(e.toString(), Colors.red);
    }
  }

  void signInWithFacebook(BuildContext context) async {
    // user = await AuthService.signInWithFacebook();
    Helper.showToast('Facebook service currently unavailable', Colors.red);
  }

  void signInWitGuest(BuildContext context) async {
    // user = await AuthService.signInWithFacebook();
    Helper.showToast('Guest account unavailable', Colors.red);
  }

  // Upload to Firebase after checking the phone number
  // When using a Google account to log in, the phone number does not get. It asks the user for their phone number and upload it to Firebase
  Future<bool> addPhoneNumberToGoogle(BuildContext context, User user) async {
    try {
      // Check Phone number is already registered
      bool isNumberAlreadyExists = await FirebaseService.isPhoneNumberRegistered(user.phone!);
      if (!isNumberAlreadyExists) {
        // Set account created time and last logged time
        user.createdTime = DateTime.now();
        user.lastLogged = DateTime.now();
        // Upload user to firebase
        var result = await FirebaseService.uploadUser(user);
        if (result.status == ResultStatus.success) {
          // Save SharedPreferences
          LocalService.saveUser(result.data!.docId!);
          return true;
        } else {
          // Show error
          Helper.showToast(result.message!, Colors.red);
          return false;
        }
      } else {
        Helper.showToast('Phone number already registered', Colors.red);
        return false;
      }
    } catch (e) {
      Helper.showToast(e.toString(), Colors.red);
      return false;
    }
  }

  // Logout
  Future<bool> logout() async {
    await AuthService.logout();
    await LocalService.removeUser();
    return true;
  }
}
