import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String? docId;
  final String userId;
  final String productId;
  final DateTime time;

  Cart({
    this.docId,
    required this.userId,
    required this.productId,
    required this.time,
  });

  factory Cart.fromDocument(DocumentSnapshot<Map<String, dynamic>> cart) {
    return Cart(
      docId: cart.id,
      userId: cart.get('userId'),
      productId: cart.get('productId'),
      time: (cart.get('time') as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toMap(Cart cart) {
    return {
      'userId': cart.userId,
      'productId': cart.productId,
      'time': cart.time,
    };
  }
}
