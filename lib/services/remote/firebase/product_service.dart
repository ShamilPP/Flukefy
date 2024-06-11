import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/product.dart';
import '../../../model/result.dart';

class ProductService {
  static CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('products');

  static Future<Result<List<Product>>> getAllProducts() async {
    List<Product> products = [];
    var allDocs = await collection.get();
    for (var product in allDocs.docs) {
      products.add(Product.fromDocument(product));
    }
    return Result.success(products);
  }
}
