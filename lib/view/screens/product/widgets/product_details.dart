import 'package:flukefy/model/product.dart';
import 'package:flukefy/view/screens/product/widgets/similar_products.dart';
import 'package:flukefy/view_model/brands_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/brand.dart';
import '../../../animations/fade_animation.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  final double boxHeight;

  const ProductDetails({Key? key, required this.product, required this.boxHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // Rating
              Positioned(
                top: 0,
                right: 0,
                child: FadeAnimation(
                  delay: 100,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  FadeAnimation(
                    delay: 100,
                    child:
                        Text(getBrand(context, product.brandId).name, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  const SizedBox(height: 5),
                  // Product name
                  FadeAnimation(delay: 200, child: Text(product.name, style: const TextStyle(fontSize: 20))),
                  const SizedBox(height: 5),
                  // Price
                  Row(
                    children: [
                      FadeAnimation(
                        delay: 250,
                        child: Text(
                          '₹${product.price}',
                          style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeAnimation(
                        delay: 300,
                        child: Text(
                          '₹${product.price - (product.price * product.discount ~/ 100)}',
                          style: const TextStyle(color: Colors.black, fontSize: 23),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeAnimation(
                        delay: 200,
                        child: Text(
                          '${product.discount}% off',
                          style: const TextStyle(color: Colors.green, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Description
                  Text(product.description, style: const TextStyle(color: Colors.grey, fontSize: 16)),

                  // Similar Products
                  const SimilarProducts(),
                ],
              ),
            ],
          ),
        ),
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
