import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukefy/utils/extensions/extension.dart';
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
        var usr = flukefy_user.User(id: user.uid, name: user.displayName!, email: user.email!);
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

  static Future<Response> signWithEmail(String email, String password) async {
    if (email == '' && email.isValidEmail()) {
      return Response(isSuccess: false, value: 'Invalid email');
    } else if (password == '') {
      return Response(isSuccess: false, value: 'Invalid password');
    }
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Response(isSuccess: false, value: 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        return Response(isSuccess: false, value: 'Wrong password');
      }
    }
    if (credential == null) {
      return Response(isSuccess: false, value: 'Admin has blocked you');
    } else {
      // returning success and docId
      return Response(isSuccess: true, value: credential.user?.uid);
    }
  }

  static Future<Response> createAccount(
      String name, String phoneNumber, String email, String password, String confirmPassword) async {
    if (name == '' && email.isValidEmail()) {
      return Response(isSuccess: false, value: 'Invalid name');
    } else if (phoneNumber == '') {
      return Response(isSuccess: false, value: 'Invalid phone number');
    } else if (email == '') {
      return Response(isSuccess: false, value: 'Invalid email');
    } else if (password == '') {
      return Response(isSuccess: false, value: 'Invalid password');
    } else if (password != confirmPassword) {
      return Response(isSuccess: false, value: 'Confirm password incorrect');
    } else if (!verifyPhoneNumber(phoneNumber)) {
      return Response(isSuccess: false, value: 'Entered mobile number is invalid');
    }
    bool numberAlreadyExists = await FirebaseService.checkIfNumberAlreadyExists(int.parse(phoneNumber));
    if (numberAlreadyExists) return Response(isSuccess: false, value: 'Phone number already exists');

    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Response(isSuccess: false, value: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Response(isSuccess: false, value: 'The account already exists for that email.');
      }
    } catch (e) {
      return Response(isSuccess: false, value: e);
    }

    flukefy_user.User user = flukefy_user.User(
      id: credential!.user!.uid,
      name: name,
      phoneNumber: int.parse(phoneNumber),
      email: email,
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
