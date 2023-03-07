class User {
  String? docId;
  String? uid;
  final String name;
  final String email;
  int? phone;

  User({this.docId, this.uid, required this.name, required this.email, this.phone});
}
