import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/products_provider.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 25),
          onPressed: () {
            Provider.of<ProductsProvider>(context, listen: false).errorToast();
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, size: 25),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          },
        ),
      ],
    );
  }
}
