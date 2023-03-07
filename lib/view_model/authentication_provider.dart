import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/services/local_service.dart';
import 'package:flukefy/view/screens/login/phone_number_screen.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../model/response.dart';
import '../model/user.dart';
import '../services/authentication_service.dart';

enum AuthType { guest, manually, google, facebook }

class AuthenticationProvider extends ChangeNotifier {
  Future<Response<bool>> login(String email, String password) async {
    // Verify that the user entered valid values
    if (!email.isValidEmail()) {
      return Response.error('Invalid email');
    } else if (password == '') {
      return Response.error('Invalid password');
    }

    // Login account using firebase
    var result = await AuthenticationService.signWithEmail(email, password);
    if (result.status == Status.completed && result.data != null) {
      // The user docID is required to save the user in the shared preferences
      var user = await FirebaseService.getUserWithUID(result.data!);
      if (user.status == Status.completed && user.data != null) {
        // Save user in SharedPreferences
        LocalService.saveUser(user.data!.docId!);
        return Response.completed(true);
      } else {
        return Response.error(result.message!);
      }
    } else {
      return Response.error(result.message!);
    }
  }

  Future<Response<bool>> createAccount(String name, String phone, String email, String password, String confirmPassword) async {
    // Verify that the user entered valid values
    if (name == '') {
      return Response.error('Invalid name');
    } else if ((int.tryParse(phone) == null || phone.length != 10)) {
      return Response.error('Invalid phone number');
    } else if (!email.isValidEmail()) {
      return Response.error('Invalid email');
    } else if (password == '') {
      return Response.error('Invalid password');
    } else if (password != confirmPassword) {
      return Response.error('Confirm password incorrect');
    }

    // Check Phone number is already exists
    bool numberAlreadyExists = await FirebaseService.checkIfNumberAlreadyExists(int.parse(phone));
    if (numberAlreadyExists) {
      return Response.error('Phone number already exists');
    }

    // and finally create account using firebase
    User user = User(name: name, phone: int.parse(phone), email: email);
    // Create account in firebase authentication
    var createAccountResult = await AuthenticationService.createAccount(user, password);
    if (createAccountResult.status == Status.completed) {
      // Create document in firebase user collection
      var uploadUserResult = await FirebaseService.uploadUser(createAccountResult.data!);
      if (uploadUserResult.status == Status.completed) {
        // Save user in SharedPreferences
        LocalService.saveUser(uploadUserResult.data!.docId!);
        return Response.completed(true);
      } else {
        return Response.error(uploadUserResult.message);
      }
    } else {
      return Response.error(createAccountResult.message);
    }
  }

  void signInWithGoogle(BuildContext context) async {
    // Show loading dialog
    showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
    Response<User> userResponse = await AuthenticationService.signInWithGoogle();
    // Dismiss loading dialog
    Navigator.pop(context);

    if (userResponse.status == Status.completed && userResponse.data != null) {
      User user = userResponse.data!;
      // When logging into Google, the user provides a UID
      // If the UID exists in the users collection documents
      var userWithUidResponse = await FirebaseService.getUserWithUID(user.uid!);
      // Null is returned if the document is not available
      // That means phone number not registered
      // Then go to Add phone number screen
      if (userWithUidResponse.data == null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PhoneNumberScreen(user: user)), (route) => false);
      } else {
        // Documents is exists, which means phone number is already exists
        // Then save user docId to shared preference
        LocalService.saveUser(userWithUidResponse.data!.docId!);
        // Then Go to Splash screen
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
      }
    } else {
      // Login Failed
      showToast('Something went wrong', Colors.red);
    }
  }

  void signInWithFacebook(BuildContext context) async {
    // user = await AuthenticationService.signInWithFacebook();
    showToast('Facebook service currently unavailable', Colors.red);
  }

  void signInWitGuest(BuildContext context) async {
    // user = await AuthenticationService.signInWithFacebook();
    showToast('Guest account unavailable', Colors.red);
  }

  // Upload to Firebase after checking the phone number
  // When using a Google account to log in, the phone number does not get. It asks the user for their phone number and upload it to Firebase
  Future<bool> addPhoneNumberToGoogle(BuildContext context, User user) async {
    // Check Phone number is already registered
    bool numberAlreadyExists = await FirebaseService.checkIfNumberAlreadyExists(user.phone);
    if (numberAlreadyExists) {
      showToast('Phone number already registered', Colors.red);
      return false;
    } else {
      // This number not registered, Then upload to firebase
      // Upload user to firebase
      var result = await FirebaseService.uploadUser(user);
      if (result.status == Status.completed) {
        // Save SharedPreferences
        LocalService.saveUser(result.data!.docId!);
        return true;
      } else {
        // Show error
        showToast(result.message!, Colors.red);
        return false;
      }
    }
  }

  // Logout
  Future<bool> logout() async {
    await AuthenticationService.logout();
    await LocalService.removeUser();
    return true;
  }
}
