import 'package:flukefy/view/widgets/buttons/expand_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../model/cart.dart';
import '../../../../model/product.dart';
import '../../../../view_model/cart_provider.dart';
import '../../../../view_model/user_provider.dart';
import '../../cart/cart_screen.dart';

class CartBox extends StatefulWidget {
  final Product product;

  const CartBox({Key? key, required this.product}) : super(key: key);

  @override
  State<CartBox> createState() => _CartBoxState();
}

class _CartBoxState extends State<CartBox> {
  bool isAlreadyCarted = true;

  @override
  Widget build(BuildContext context) {
    // Hide cart if item is already cart
    var carts = Provider.of<CartProvider>(context, listen: false).carts;
    int cartIndex = carts.indexWhere((element) => element.productId == widget.product.docId);
    if (cartIndex == -1) isAlreadyCarted = false;
    return Container(
      color: Colors.white,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ExpandButton(
              animationDelay: 400,
              onTap: isAlreadyCarted ? goToCart : addToCart,
              child: Text(isAlreadyCarted ? 'Go to cart' : 'Add to cart'),
            ),
            const SizedBox(width: 10),
            ExpandButton(
              animationDelay: 400,
              onTap: () => Fluttertoast.showToast(msg: 'Currently unavailable'),
              color: Colors.amber,
              child: const Text("Buy now"),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart() async {
    var userId = Provider.of<UserProvider>(context, listen: false).user.id!;
    Cart cart = Cart(userId: userId, productId: widget.product.docId!, time: DateTime.now());
    showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
    await Provider.of<CartProvider>(context, listen: false).addToCart(cart);
    Navigator.pop(context);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart'),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          },
        ),
      ),
    );
    setState(() {
      isAlreadyCarted = true;
    });
  }

  void goToCart() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }
}
