import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/brand.dart';
import '../../../model/result.dart';

class BrandService {
  static CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('category');

  static Future<Result<List<Brand>>> getAllBrands() async {
    List<Brand> brands = [];
    var allDocs = await collection.get();
    for (var category in allDocs.docs) {
      brands.add(Brand.fromDocument(category));
    }
    return Result.success(brands);
  }
}
