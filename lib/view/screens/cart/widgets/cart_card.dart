import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flukefy/view/screens/product/product_screen.dart';
import 'package:flukefy/view/widgets/buttons/expand_button.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../model/product.dart';

class CartCard extends StatelessWidget {
  final Product product;

  CartCard({Key? key, required this.product}) : super(key: key);

  final DateTime deliveryTime = DateTime.now().add(const Duration(days: 8));
  final Widget space = const SizedBox(height: 7);

  @override
  Widget build(BuildContext context) {
    final String heroTag = '${product.docId}CartScreen';
    return FadeAnimation(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: product, imageHeroTag: heroTag)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 12),
                child: Row(
                  children: [
                    // Product image and qty
                    FadeAnimation(
                      delay: 600,
                      child: Column(
                        children: [
                          Hero(
                            tag: heroTag,
                            child: Image.network(
                              product.images[0],
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: 75,
                                  width: 75,
                                  child: Center(child: SpinKitPulse(color: Colors.black, size: 30)),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Qty: 1'),
                        ],
                      ),
                    ),

                    // Product details (right side of image)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SlideAnimation(
                              delay: 500,
                              child: Text(product.name,
                                  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
                            ),
                            space,
                            SlideAnimation(
                              delay: 400,
                              child: Text(product.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ),
                            space,

                            // RatingBar
                            SlideAnimation(
                              delay: 300,
                              child: RatingBarIndicator(
                                rating: product.rating,
                                itemCount: 5,
                                itemSize: 18,
                                unratedColor: Colors.amber.shade100,
                                itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              ),
                            ),
                            space,
                            // Price
                            SlideAnimation(
                              delay: 200,
                              child: Row(
                                children: [
                                  Text(
                                    '₹${product.price}',
                                    style:
                                        const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '₹${product.price - (product.price * product.discount ~/ 100)}',
                                    style: TextStyle(color: Colors.red.shade900, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SlideAnimation(delay: 100, child: _deliveryDate()),
              const SizedBox(height: 10),
              const Divider(thickness: 1, height: 0),
              IntrinsicHeight(
                child: Row(
                  children: [
                    ExpandButton(
                        animationDelay: 800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.grey.shade700),
                            const SizedBox(width: 10),
                            Text(
                              'Remove',
                              style: TextStyle(color: Colors.grey.shade700),
                            )
                          ],
                        ),
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false).removeCart(context, product);
                        }),
                    const VerticalDivider(thickness: 1, width: 0),
                    ExpandButton(
                      animationDelay: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.electric_bolt, color: Colors.grey.shade700),
                          const SizedBox(width: 10),
                          Text(
                            'Buy this now',
                            style: TextStyle(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                      onTap: () => Fluttertoast.showToast(msg: 'Currently unavailable'),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 0),
            ],
          ),
        ),
      ),
    );
  }

  _deliveryDate() {
    final List<String> weeks = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    final List<String> mounts = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec",
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text:
                    'Delivery by ${weeks[DateTime.now().weekday - 1]} ${mounts[DateTime.now().month - 1]} ${deliveryTime.day} | '),
            const TextSpan(
              text: '₹40',
              style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
            const TextSpan(
              text: ' Free delivery',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
