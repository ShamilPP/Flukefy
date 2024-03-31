import 'package:flukefy/model/product.dart';
import 'package:flukefy/view/screens/product/widgets/similar_products.dart';
import 'package:flukefy/view_model/brands_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/brand.dart';
import '../../../animations/fade_animation.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade600, spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3)),
        ],
      ),
      child: Stack(
        children: [
          // Rating
          Positioned(
            top: 10,
            right: 10,
            child: FadeAnimation(
              delay: 500,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  '${product.rating} ★',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                FadeAnimation(
                  delay: 100,
                  child: Text(getBrand(context, product.brandId).name, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                const SizedBox(height: 5),
                // Product name
                FadeAnimation(delay: 200, child: Text(product.name, style: const TextStyle(fontSize: 19))),
                const SizedBox(height: 5),
                // Price
                FadeAnimation(
                  delay: 300,
                  child: Row(
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 17),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '₹${product.price - (product.price * product.discount ~/ 100)}',
                        style: const TextStyle(color: Colors.black, fontSize: 22),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${product.discount}% off',
                        style: const TextStyle(color: Colors.green, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Description
                FadeAnimation(delay: 400, child: Text(product.description, style: const TextStyle(color: Colors.grey, fontSize: 16))),

                // Similar Products
                FadeAnimation(delay: 500, child: SimilarProducts(product: product)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Brand getBrand(BuildContext context, String docId) {
    var brands = Provider.of<BrandsProvider>(context, listen: false).brands;
    int brandIndex = brands.indexWhere((element) => element.docId == docId);
    if (brandIndex == -1) {
      return Brand(name: 'No Brand');
    } else {
      return brands[brandIndex];
    }
  }
}
