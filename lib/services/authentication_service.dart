import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/response.dart';
import '../model/user.dart' as flukefy_user;
import 'firebase_service.dart';

class AuthenticationService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<flukefy_user.User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null && user.displayName != null && user.email != null) {
        var usr = flukefy_user.User(id: user.uid, name: user.displayName!, username: user.email!, password: 'Google');
        return usr;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<User?> signInWithFacebook() async {
    final LoginResult facebookResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(facebookResult.accessToken!.token);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(facebookAuthCredential);
    User? user = result.user;

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  static Future<Response> loginAccount(String username, String password) async {
    flukefy_user.User? user = await FirebaseService.getUserWithUsername(username);
    if (username == '') {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (password == '') {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (user == null) {
      return Response(isSuccess: false, value: 'Username or not exits');
    } else if (password != user.password) {
      return Response(isSuccess: false, value: 'Password is incorrect');
    }
    // returning success and docId
    return Response(isSuccess: true, value: user.id);
  }

  static Future<Response> createAccount(
      String name, String phoneNumber, String username, String password, String confirmPassword) async {
    if (name == '') {
      return Response(isSuccess: false, value: 'Invalid name');
    } else if (phoneNumber == '') {
      return Response(isSuccess: false, value: 'Invalid phone number');
    } else if (username == '') {
      return Response(isSuccess: false, value: 'Invalid username');
    } else if (password == '') {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (password != confirmPassword) {
      return Response(isSuccess: false, value: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return Response(isSuccess: false, value: 'Entered mobile number is invalid');
    }

    flukefy_user.User user = flukefy_user.User(
      name: name,
      phoneNumber: int.parse(phoneNumber),
      username: username,
      password: password,
    );
    return FirebaseService.uploadUser(user);
  }

  static bool verifyPhoneNumber(String number) {
    int? phoneNumber = int.tryParse(number);
    if (phoneNumber != null && number.length == 10) {
      return true;
    }
    return false;
  }
}
