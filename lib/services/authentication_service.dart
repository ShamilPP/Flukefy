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

  static Future<Response> createAccount(flukefy_user.User user, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
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

    user.id = credential!.user!.uid;

    return FirebaseService.uploadUser(user);
  }
}
