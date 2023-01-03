import 'package:flukefy/model/product.dart';
import 'package:flukefy/view/screens/product/widgets/cart_box.dart';
import 'package:flukefy/view/screens/product/widgets/image_slider.dart';
import 'package:flukefy/view/screens/product/widgets/more_details.dart';
import 'package:flukefy/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  final String imageHeroTag;

  const ProductScreen({Key? key, required this.product, required this.imageHeroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(title: product.name),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ImageSlider(product: product, imageHeroTag: imageHeroTag),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(product.name, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        // Price
                        Row(
                          children: [
                            Text(
                              '₹${product.price}',
                              style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${product.price - (product.price * product.discount ~/ 100)}',
                              style: const TextStyle(color: Colors.black, fontSize: 25),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${product.discount}% off',
                              style: const TextStyle(color: Colors.green, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                '${product.rating} ★',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text('1 Rating', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // More details
                        MoreDetails(product: product),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CartBox(product: product),
        ],
      ),
    );
  }
}
