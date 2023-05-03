import 'package:flukefy/model/product.dart';
import 'package:flukefy/view/screens/product/widgets/cart_box.dart';
import 'package:flukefy/view/screens/product/widgets/image_slider.dart';
import 'package:flukefy/view/screens/product/widgets/product_details.dart';
import 'package:flutter/material.dart';

import '../../widgets/general/curved_appbar.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  final String imageHeroTag;

  const ProductScreen({Key? key, required this.product, required this.imageHeroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(title: product.name),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Images
          ImageSlider(images: product.images, imageHeroTag: imageHeroTag),
          // Product details (Included similar products)
          Expanded(child: ProductDetails(product: product)),
          // Cart box on bottom
          CartBox(product: product),
        ],
      ),
    );
  }
}
