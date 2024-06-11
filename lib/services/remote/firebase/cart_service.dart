import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/cart.dart';
import '../../../model/result.dart';

class CartService {
  static CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('carts');

  static Future<Result<List<Cart>>> getAllCarts(String userId) async {
    List<Cart> carts = [];
    var allDocs = await collection.where('userId', isEqualTo: userId).get();
    for (var cart in allDocs.docs) {
      carts.add(Cart.fromDocument(cart));
    }
    return Result.success(carts);
  }

  static Future<Result<Cart>> uploadCart(Cart cart) async {
    var result = await collection.add(Cart.toMap(cart));
    cart.docId = result.id;
    return Result.success(cart);
  }

  static Future<Result<bool>> removeCart(Cart cart) async {
    await collection.doc(cart.docId).delete();
    return Result.success(true);
  }
}
