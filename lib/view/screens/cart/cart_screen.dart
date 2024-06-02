import 'package:flukefy/model/result.dart';
import 'package:flukefy/view/screens/cart/widgets/cart_card.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../view_model/cart_provider.dart';
import '../../widgets/general/curved_appbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CurvedAppBar(
        title: 'Cart',
      ),
      body: Center(
        child: Consumer<CartProvider>(builder: (ctx, provider, child) {
          switch (provider.carts.status) {
            case ResultStatus.success:
              if (provider.carts.data!.isNotEmpty) {
                var products = Provider.of<ProductsProvider>(context, listen: false).products;
                return ListView.builder(
                  itemCount: provider.carts.data!.length,
                  itemBuilder: (ctx, index) {
                    var cart = provider.carts.data![index];
                    var product = products.data![products.data!.indexWhere((element) => element.docId == cart.productId)];
                    return CartCard(product: product);
                  },
                );
              } else {
                return const Center(child: Text('No carts'));
              }
            case ResultStatus.loading:
              return SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(child: SpinKitFadingCube(color: AppColors.primaryColor, size: 25)),
              );
            case ResultStatus.failed:
              return Center(child: Text('Error : ${provider.carts.message}'));
            case ResultStatus.idle:
              return const SizedBox();
          }
        }),
      ),
    );
  }
}
