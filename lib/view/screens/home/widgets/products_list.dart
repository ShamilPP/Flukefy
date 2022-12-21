import 'package:flukefy/view/screens/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/enums/status.dart';
import '../../../../model/product.dart';
import '../../../../utils/colors.dart';
import '../../../../view_model/products_provider.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('Most popular', style: TextStyle(fontSize: 20)),
          Consumer<ProductsProvider>(builder: (ctx, provider, child) {
            var status = provider.productsStatus;
            if (status == Status.loading) {
              return const SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (status == Status.success) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.products.length < 10 ? provider.products.length : 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 9 / 12),
                itemBuilder: (ctx, index) {
                  return productCard(context, provider.products[index]);
                },
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }

  Widget productCard(BuildContext context, Product productDetails) {
    final String heroTag = '${productDetails.docId}Popular';
    Widget space = const SizedBox(height: 5);

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 2, offset: const Offset(0, 2))],
      ),
      height: 280,
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
                    child: Image.network(
                      productDetails.images[0],
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
                space,
                Text(productDetails.name,
                    overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
                space,
                Text(productDetails.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ProductScreen(product: productDetails, imageHeroTag: heroTag)));
          },
        ),
      ),
    );
  }
}
