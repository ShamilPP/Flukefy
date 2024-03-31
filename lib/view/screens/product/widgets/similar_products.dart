import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../model/product.dart';
import '../../../../model/result.dart';
import '../../../../utils/colors.dart';
import '../../../../view_model/brands_provider.dart';
import '../../../../view_model/products_provider.dart';
import '../../../animations/fade_animation.dart';
import '../../../widgets/general/loading_network_image.dart';
import '../product_screen.dart';

class SimilarProducts extends StatelessWidget {
  final Product product;

  const SimilarProducts({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //For Responsive Design
    int crossAxisCount = 2;
    if (size.height < size.width) crossAxisCount = size.width ~/ 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Similar Products', style: TextStyle(fontSize: 19)),
        const SizedBox(height: 10),
        Consumer<ProductsProvider>(builder: (ctx, provider, child) {
          var status = provider.productsStatus;
          if (status == Status.loading) {
            return SizedBox(
              height: 300,
              width: double.infinity,
              child: Center(child: SpinKitFadingCube(color: primaryColor, size: 25)),
            );
          } else if (status == Status.success) {
            var brandProvider = Provider.of<BrandsProvider>(context, listen: false);
            var products = brandProvider.getBrandProducts(product.brandId, provider.products);
            products.remove(product);
            return GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length < 4 ? products.length : 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, childAspectRatio: 9 / 12),
              itemBuilder: (ctx, index) {
                return productCard(context, products[index]);
              },
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget productCard(BuildContext context, Product productDetails) {
    final String heroTag = '${productDetails.docId}SimilarProducts';
    Widget space = const SizedBox(height: 5);

    return FadeAnimation(
      delay: 400,
      child: Container(
        height: 280,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 2, offset: const Offset(0, 2))],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Hero(
                      tag: heroTag,
                      child: LoadingNetworkImage(
                        productDetails.images[0],
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )),
                  space,
                  Text(productDetails.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
                  space,
                  Text(productDetails.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  space,
                  // Price
                  Row(
                    children: [
                      Text(
                        '₹ ${productDetails.price - (productDetails.price * productDetails.discount ~/ 100)}',
                        style: TextStyle(color: Colors.red.shade900, fontSize: 18),
                      ),
                      const SizedBox(width: 5),
                      Text('${productDetails.discount}% off', style: const TextStyle(color: Colors.green, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: productDetails, heroTag: heroTag)));
            },
          ),
        ),
      ),
    );
  }
}
