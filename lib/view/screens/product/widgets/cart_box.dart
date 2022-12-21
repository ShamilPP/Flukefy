import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/cart.dart';
import '../../../../model/product.dart';
import '../../../../utils/colors.dart';
import '../../../../view_model/cart_provider.dart';
import '../../../../view_model/user_provider.dart';
import '../../../widgets/buttons/black_button.dart';
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 5, offset: const Offset(0, -2))],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹ ${widget.product.price - (widget.product.price * widget.product.discount ~/ 100)}',
              style: TextStyle(color: Colors.red.shade900, fontSize: 22),
            ),
            isAlreadyCarted
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text('Qty : ${carts[cartIndex].qty}    Carted', style: TextStyle(fontSize: 16)),
                  )
                : BlackButton(
                    title: 'Add to cart',
                    onPressed: () async {
                      var userId = Provider.of<UserProvider>(context, listen: false).user.id!;
                      Cart cart = Cart(userId: userId, productId: widget.product.docId!, qty: 1, time: DateTime.now());
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
                    })
          ],
        ),
      ),
    );
  }
}
