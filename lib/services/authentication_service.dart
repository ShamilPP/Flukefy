import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/response.dart';
import '../model/user.dart' as flukefy_user;

class AuthenticationService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Response<flukefy_user.User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;

        if (user != null && user.displayName != null && user.email != null) {
          var usr = flukefy_user.User(uid: user.uid, name: user.displayName!, email: user.email!);
          return Response.completed(usr);
        } else {
          return Response.error('Error : Null');
        }
      } else {
        return Response.error('Error : Null');
      }
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  // static Future<User?> signInWithFacebook() async {
  //   final LoginResult facebookResult = await FacebookAuth.instance.login();
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(facebookResult.accessToken!.token);
  //
  //   // Getting users credential
  //   UserCredential result = await auth.signInWithCredential(facebookAuthCredential);
  //   User? user = result.user;
  //
  //   if (user != null) {
  //     return user;
  //   } else {
  //     return null;
  //   }
  // }

  static Future<Response<String>> signWithEmail(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return Response.completed(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Response.error('No user found for that email');
      } else if (e.code == 'wrong-password') {
        return Response.error('Wrong password');
      } else {
        return Response.error(e.toString());
      }
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  static Future<Response<flukefy_user.User>> createAccount(flukefy_user.User user, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      if (credential.user != null) {
        user.uid = credential.user!.uid;
        return Response.completed(user);
      } else {
        return Response.error('User is null');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Response.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Response.error('The account already exists for that email.');
      } else {
        return Response.error(e.toString());
      }
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  static Future<Response<bool>> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Response.completed(true);
    } catch (e) {
      return Response.error(e.toString());
    }
  }
}
