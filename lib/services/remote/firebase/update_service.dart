import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/result.dart';

class UpdateService {
  static Future<Result<int>> getUpdateCode() async {
    var doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("client")) {
      // if document exists, fetch version in firebase
      int code = doc['client'];
      return Result.success(code);
    } else {
      return Result.error('Update code fetching problem');
    }
  }
}
