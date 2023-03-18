class User {
  String? docId;
  String? uid;
  final String name;
  final String email;
  int? phone;

  // Use only when uploading to Firebase
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
}
