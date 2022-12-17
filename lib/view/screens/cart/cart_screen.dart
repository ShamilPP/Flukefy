import 'package:flutter/material.dart';

import '../../widgets/general/curved_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: 'Cart',
      ),
      body: Center(
        child: Text('No cart items'),
      ),
    );
  }
}
