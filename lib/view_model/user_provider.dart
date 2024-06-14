import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/local/local_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
  }

  Future<String?> getUserIdFromLocal() async {
    String? docId = await LocalService.getUser();
    return docId;
  }
}
