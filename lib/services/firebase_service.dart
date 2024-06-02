import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/result.dart';
import 'package:flukefy/model/user.dart';

import '../model/brand.dart';
import '../model/cart.dart';
import '../model/product.dart';

class FirebaseService {
  static Future<Result<List<Product>>> getAllProducts() async {
    List<Product> products = [];
    var collection = FirebaseFirestore.instance.collection('products');
    var allDocs = await collection.get();
    for (var product in allDocs.docs) {
      products.add(Product.fromDocument(product));
    }
    return Result.success(products);
  }

  static Future<Result<List<Brand>>> getAllBrands() async {
    List<Brand> brands = [];
    var collection = FirebaseFirestore.instance.collection('category');
    var allDocs = await collection.get();
    for (var category in allDocs.docs) {
      brands.add(Brand.fromDocument(category));
    }
    return Result.success(brands);
  }

  static Future<Result<List<Cart>>> getAllCarts(String userId) async {
    List<Cart> carts = [];
    var collection = FirebaseFirestore.instance.collection("carts").where("userId", isEqualTo: userId);
    var allDocs = await collection.get();
    for (var cart in allDocs.docs) {
      carts.add(Cart.fromDocument(cart));
    }
    return Result.success(carts);
  }

  static Future<Result<User>> getUserWithDocId(String docId) async {
    var collection = FirebaseFirestore.instance.collection('users');
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
    var collection = FirebaseFirestore.instance.collection('users');
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
    var users = FirebaseFirestore.instance.collection('users');
    var result = await users.add(User.toMap(user));
    user.docId = result.id;
    return Result.success(user);
  }

  static Future<Result<Cart>> uploadCart(Cart cart) async {
    var carts = FirebaseFirestore.instance.collection('carts');
    var result = await carts.add(Cart.toMap(cart));
    cart.docId = result.id;
    return Result.success(cart);
  }

  static Future<Result<bool>> removeCart(Cart cart) async {
    var carts = FirebaseFirestore.instance.collection('carts');
    await carts.doc(cart.docId).delete();
    return Result.success(true);
  }

  static Future<Result<bool>> updateUserLastLogged(String userID, DateTime time) async {
    var users = FirebaseFirestore.instance.collection('users');
    await users.doc(userID).update({'lastLogged': time});
    return Result.success(true);
  }

  static Future<bool> isPhoneNumberRegistered(int phone) async {
    var users = await FirebaseFirestore.instance.collection('users').get();
    for (var usr in users.docs) {
      if (usr.get('phone') == phone) {
        return true;
      }
    }

    return false;
  }

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
