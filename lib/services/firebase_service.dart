import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/response.dart';
import 'package:flukefy/model/user.dart';

import '../model/brand.dart';
import '../model/cart.dart';
import '../model/product.dart';

class FirebaseService {
  static Future<Response<List<Product>>> getAllProducts() async {
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
        ));
      }

      return Response.completed(products);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<List<Brand>>> getAllBrands() async {
    try {
      List<Brand> brands = [];
      var collection = FirebaseFirestore.instance.collection('category');
      var allDocs = await collection.get();
      for (var category in allDocs.docs) {
        brands.add(Brand(docId: category.id, name: category.get('name')));
      }
      return Response.completed(brands);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<List<Cart>>> getAllCarts(String userId) async {
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
      return Response.completed(carts);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<User>> getUserWithDocId(String docId) async {
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
        return Response.completed(usr);
      } else {
        return Response.error('User not exists');
      }
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<User?>> getUserWithUID(String uid) async {
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
        return Response.completed(usr);
      } else {
        return Response.completed(null);
      }
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<User>> uploadUser(User user) async {
    try {
      var users = FirebaseFirestore.instance.collection('users');
      var result = await users.add({
        'uid': user.uid ?? "NO UID",
        'name': user.name,
        'phone': user.phone,
        'email': user.email,
      });
      user.docId = result.id;
      return Response.completed(user);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<Cart>> uploadCart(Cart cart) async {
    try {
      var carts = FirebaseFirestore.instance.collection('carts');
      var result = await carts.add({
        'userId': cart.userId,
        'productId': cart.productId,
        'time': cart.time,
      });
      cart.docId = result.id;
      return Response.completed(cart);
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }

  static Future<Response<bool>> removeCart(Cart cart) async {
    try {
      var carts = FirebaseFirestore.instance.collection('carts');
      await carts.doc(cart.docId).delete();
      return Response.completed(true);
    } catch (e) {
      return Response.error('Error detected : $e');
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

  static Future<Response> getUpdateCode() async {
    try {
      var doc = await FirebaseFirestore.instance.collection('application').doc('update').get();
      // check document exists ( avoiding null exceptions )
      if (doc.exists && doc.data()!.containsKey("code")) {
        // if document exists, fetch version in firebase
        int code = doc['code'];
        return Response.completed(code);
      } else {
        return Response.error('Error detected : Update code fetching problem');
      }
    } catch (e) {
      return Response.error('Error detected : $e');
    }
  }
}
