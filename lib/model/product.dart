import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? docId;
  final List<String> images;
  final String name;
  final String description;
  final String brandId;
  final double rating;
  final int price;
  final int discount;
  final DateTime createdTime;

  Product({
    required this.docId,
    required this.images,
    required this.name,
    required this.description,
    required this.brandId,
    required this.rating,
    required this.price,
    required this.discount,
    required this.createdTime,
  });

  factory Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> product) {
    return Product(
        docId: product.id,
        name: product.get('name'),
        images: List<String>.from(product.get('images')),
        description: product.get('description'),
        brandId: product.get('category'),
        rating: product.get('rating'),
        price: product.get('price'),
        discount: product.get('discount'),
        createdTime: (product.get('createdTime') as Timestamp).toDate());
  }
}
