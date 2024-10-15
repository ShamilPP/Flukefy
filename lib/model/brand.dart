import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String? docId;
  final String name;

  Brand({
    this.docId,
    required this.name,
  });

  factory Brand.fromDocument(DocumentSnapshot<Map<String, dynamic>> brand) {
    return Brand(docId: brand.id, name: brand.get('name'));
  }
}
