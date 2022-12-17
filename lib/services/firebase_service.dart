import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukefy/model/response.dart';
import 'package:flukefy/model/user.dart';

import '../model/brand.dart';
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
        brand: product.get('category'),
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
    Response alreadyExists = await checkUserWithUsernameAndPhoneNumber(user);
    if (!alreadyExists.isSuccess) {
      return alreadyExists;
    }
    // Then uploading user to firebase
    String? docId;
    if (user.id != null) {
      // If logged in to Google, create a document using its UID
      await users.doc(user.id).set({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'username': user.username,
        'password': user.password,
      });
      docId = user.id;
    } else {
      var result = await users.add({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'username': user.username,
        'password': user.password,
      });
      docId = result.id;
    }
    return Response(isSuccess: true, value: docId);
  }

  static Future<User?> getUserWithUsername(String username) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var users = await collection.get();
    for (var user in users.docs) {
      if (user.get('username') == username) {
        // returning user data
        return User(
          id: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
        );
      }
      if (user.get('phoneNumber').toString() == username) {
        // returning user data
        return User(
          id: user.id,
          name: user.get('name'),
          phoneNumber: user.get('phoneNumber'),
          username: user.get('username'),
          password: user.get('password'),
        );
      }
    }
    return null;
  }

  static Future<User?> getUserWithDocId(String docId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var user = await collection.doc(docId).get();
    if (user.exists) {
      // returning user data
      return User(
        id: user.id,
        name: user.get('name'),
        phoneNumber: user.get('phoneNumber'),
        username: user.get('username'),
        password: user.get('password'),
      );
    }
    return null;
  }

  static Future<Response> checkUserWithUsernameAndPhoneNumber(User user) async {
    var users = await FirebaseFirestore.instance.collection('users').get();

    for (var _user in users.docs) {
      if (_user.get('username') == user.username) {
        return Response(isSuccess: false, value: 'Username already exists');
      }
      if (_user.get('phoneNumber') == user.phoneNumber) {
        return Response(isSuccess: false, value: 'Phone number already exists');
      }
    }
    return Response(isSuccess: true, value: "Success");
  }
}
