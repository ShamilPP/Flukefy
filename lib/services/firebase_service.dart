import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/result.dart';
import 'package:flukefy/model/user.dart';

import '../model/brand.dart';
import '../model/cart.dart';
import '../model/product.dart';

class FirebaseService {
  static Future<Result<List<Product>>> getAllProducts() async {
    try {
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
            createdTime: (product.get('createdTime') as Timestamp).toDate()));
      }

      return Result.success(products);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<List<Brand>>> getAllBrands() async {
    try {
      List<Brand> brands = [];
      var collection = FirebaseFirestore.instance.collection('category');
      var allDocs = await collection.get();
      for (var category in allDocs.docs) {
        brands.add(Brand(docId: category.id, name: category.get('name')));
      }
      return Result.success(brands);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<List<Cart>>> getAllCarts(String userId) async {
    try {
      List<Cart> carts = [];
      var collection = FirebaseFirestore.instance.collection("carts").where("userId", isEqualTo: userId);
      var allDocs = await collection.get();
      for (var cart in allDocs.docs) {
        carts.add(Cart(
          docId: cart.id,
          userId: userId,
          productId: cart.get('productId'),
          time: (cart.get('time') as Timestamp).toDate(),
        ));
      }
      return Result.success(carts);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User>> getUserWithDocId(String docId) async {
    try {
      var collection = FirebaseFirestore.instance.collection('users');
      var user = await collection.doc(docId).get();
      if (user.exists) {
        // returning user data
        var usr = User(
          docId: user.id,
          uid: user.get('uid'),
          name: user.get('name'),
          phone: user.get('phone'),
          email: user.get('email'),
        );
        return Result.success(usr);
      } else {
        return Result.error('User not exists');
      }
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User?>> getUserWithUID(String uid) async {
    try {
      var collection = FirebaseFirestore.instance.collection('users');
      var user = await collection.where('uid', isEqualTo: uid).get();
      if (user.size == 1) {
        // returning user data
        var usr = User(
          docId: user.docs[0].id,
          uid: user.docs[0].get('uid'),
          name: user.docs[0].get('name'),
          phone: user.docs[0].get('phone'),
          email: user.docs[0].get('email'),
        );
        return Result.success(usr);
      } else {
        return Result.success(null);
      }
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User>> uploadUser(User user) async {
    try {
      var users = FirebaseFirestore.instance.collection('users');
      var result = await users.add({
        'uid': user.uid ?? "NO UID",
        'name': user.name,
        'phone': user.phone,
        'email': user.email,
        'createdTime': user.createdTime!,
        'lastLogged': user.lastLogged!,
      });
      user.docId = result.id;
      return Result.success(user);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<Cart>> uploadCart(Cart cart) async {
    try {
      var carts = FirebaseFirestore.instance.collection('carts');
      var result = await carts.add({
        'userId': cart.userId,
        'productId': cart.productId,
        'time': cart.time,
      });
      cart.docId = result.id;
      return Result.success(cart);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<bool>> removeCart(Cart cart) async {
    try {
      var carts = FirebaseFirestore.instance.collection('carts');
      await carts.doc(cart.docId).delete();
      return Result.success(true);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<bool>> updateUserLastLogged(String userID) async {
    try {
      DateTime time = DateTime.now();
      var users = FirebaseFirestore.instance.collection('users');
      await users.doc(userID).update({'lastLogged': time});
      return Result.success(true);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<bool> checkIfNumberAlreadyExists(int? phone) async {
    if (phone != null) {
      var users = await FirebaseFirestore.instance.collection('users').get();

      for (var usr in users.docs) {
        if (usr.get('phone') == phone) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<Result> getUpdateCode() async {
    try {
      var doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
      // check document exists ( avoiding null exceptions )
      if (doc.exists && doc.data()!.containsKey("client")) {
        // if document exists, fetch version in firebase
        int code = doc['client'];
        return Result.success(code);
      } else {
        return Result.error('Update code fetching problem');
      }
    } catch (e) {
      return Result.error('$e');
    }
  }
}
