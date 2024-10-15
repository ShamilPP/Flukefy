import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? docId;
  String? uid;
  final String name;
  final String email;
  int? phone;
  DateTime? createdTime;
  DateTime? lastLogged;

  User({
    this.docId,
    this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.createdTime,
    this.lastLogged,
  });

  factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> user) {
    return User(
      docId: user.id,
      uid: user.get('uid'),
      name: user.get('name'),
      phone: user.get('phone'),
      email: user.get('email'),
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      'uid': user.uid ?? "NO UID",
      'name': user.name,
      'phone': user.phone,
      'email': user.email,
      'createdTime': user.createdTime!,
      'lastLogged': user.lastLogged!,
    };
  }
}
