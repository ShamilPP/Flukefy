import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/result.dart';
import '../../../model/user.dart';

class UserService {
  static CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('users');

  static Future<Result<User>> getUserWithDocId(String docId) async {
    var user = await collection.doc(docId).get();
    if (user.exists) {
      // returning user data
      var usr = User.fromDocument(user);
      return Result.success(usr);
    } else {
      return Result.error('User not exists');
    }
  }

  static Future<Result<User?>> getUserWithUID(String uid) async {
    var user = await collection.where('uid', isEqualTo: uid).get();
    if (user.size == 1) {
      // returning user data
      var usr = User.fromDocument(user.docs[0]);
      return Result.success(usr);
    } else {
      return Result.error('The provided user ID already exists or is not available. Please choose a different user ID to proceed.');
    }
  }

  static Future<Result<User>> uploadUser(User user) async {
    var result = await collection.add(User.toMap(user));
    user.docId = result.id;
    return Result.success(user);
  }

  static Future<Result<bool>> updateUserLastLogged(String userID, DateTime time) async {
    await collection.doc(userID).update({'lastLogged': time});
    return Result.success(true);
  }

  static Future<bool> isPhoneNumberRegistered(int phone) async {
    var allDocs = await collection.get();
    for (var usr in allDocs.docs) {
      if (usr.get('phone') == phone) {
        return true;
      }
    }

    return false;
  }
}
