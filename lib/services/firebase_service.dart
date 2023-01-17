import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/response.dart';
import 'package:flukefy/model/user.dart';

import '../model/brand.dart';
import '../model/cart.dart';
import '../model/product.dart';

class FirebaseService {
  static Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    var collection = FirebaseFirestore.instance.collection('products');
    var allDocs = await collection.get();
    for (var product in allDocs.docs) {
      products.add(Product(
        docId: product.id,
        name: product.get('name'),
        images: List<String>.from(product.get('images')),
        description: product.get('description'),
        brandId: product.get('category'),
        rating: product.get('rating'),
        price: product.get('price'),
        discount: product.get('discount'),
      ));
    }

    return products;
  }

  static Future<List<Brand>> getAllBrands() async {
    List<Brand> categorys = [];

    var collection = FirebaseFirestore.instance.collection('category');
    var allDocs = await collection.get();
    for (var category in allDocs.docs) {
      categorys.add(Brand(
        docId: category.id,
        name: category.get('name'),
      ));
    }

    return categorys;
  }

  static Future<Response> uploadUser(User user) async {
    var users = FirebaseFirestore.instance.collection('users');
    // Check user is already exists
    bool alreadyExists = await checkIfNumberAlreadyExists(user.phoneNumber);
    if (alreadyExists) {
      return Response(isSuccess: false, value: 'Phone number already exists');
    }
    // Then uploading user to firebase
    String? docId;
    if (user.id != null) {
      // If logged in to Google, create a document using its UID
      await users.doc(user.id).set({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
      });
      docId = user.id;
    } else {
      var result = await users.add({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
      });
      docId = result.id;
    }
    return Response(isSuccess: true, value: docId);
  }

  static Future<User?> getUserWithDocId(String docId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var user = await collection.doc(docId).get();
    if (user.exists) {
      // returning user data
      try {
        return User(
          id: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          email: user.get('email'),
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> checkIfNumberAlreadyExists(int? phoneNumber) async {
    if (phoneNumber != null) {
      var users = await FirebaseFirestore.instance.collection('users').get();

      for (var usr in users.docs) {
        if (usr.get('phoneNumber') == phoneNumber) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<List<Cart>> getCarts(String userId) async {
    List<Cart> carts = [];
    var collection = FirebaseFirestore.instance.collection("carts").where("userId", isEqualTo: userId);
    var allDocs = await collection.get();
    for (var cart in allDocs.docs) {
      carts.add(Cart(
        cartId: cart.id,
        userId: userId,
        productId: cart.get('productId'),
        time: (cart.get('time') as Timestamp).toDate(),
      ));
    }
    return carts;
  }

  static Future<Response> uploadCart(Cart cart) async {
    var carts = FirebaseFirestore.instance.collection('carts');
    var result = await carts.add({
      'userId': cart.userId,
      'productId': cart.productId,
      'time': cart.time,
    });
    return Response(value: result.id, isSuccess: true);
  }

  static Future<Response> removeCart(Cart cart) async {
    var carts = FirebaseFirestore.instance.collection('carts');
    await carts.doc(cart.cartId).delete();
    return Response(value: 'Success', isSuccess: true);
  }

  static Future<Response> getUpdateCode() async {
    int code;
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
    } catch (e) {
      return Response(isSuccess: false, value: 'Error detected : $e');
    }
    // check document exists ( avoiding null exceptions )
    if (doc.exists && doc.data()!.containsKey("code")) {
      // if document exists, fetch version in firebase
      try {
        code = doc['code'];
        return Response(isSuccess: true, value: code);
      } catch (e) {
        return Response(isSuccess: false, value: 'Error detected : $e');
      }
    } else {
      return Response(isSuccess: false, value: 'Error detected : Update code fetching problem');
    }
  }
}
