import 'package:flukefy/model/result.dart';
import 'package:flukefy/view/screens/cart/widgets/cart_card.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../view_model/cart_provider.dart';
import '../../widgets/general/curved_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CurvedAppBar(
        title: 'Cart',
      ),
      body: Center(
        child: Consumer<CartProvider>(builder: (ctx, provider, child) {
          var status = provider.cartsStatus;
          if (status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (status == Status.success) {
            var products = Provider.of<ProductsProvider>(context, listen: false).products;
            if (provider.carts.isEmpty) return const Center(child: Text('No carts'));
            return ListView.builder(
              itemCount: provider.carts.length,
              itemBuilder: (ctx, index) {
                var cart = provider.carts[index];
                var product = products[products.indexWhere((element) => element.docId == cart.productId)];
                return CartCard(product: product);
              },
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
