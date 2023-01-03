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
  void dispose() {
    QtyBox.qty.value = 1;
    super.dispose();
  }

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
            ValueListenableBuilder<int>(
              valueListenable: QtyBox.qty,
              builder: (ctx,value,child) {
                int productPrice = widget.product.price - (widget.product.price * widget.product.discount ~/ 100);
                return Text(
                  '₹ ${value*productPrice}',
                  style: TextStyle(color: Colors.red.shade900, fontSize: 22),
                );
              }
            ),
            isAlreadyCarted
                ? Row(
                    children: [
                      Text('Qty : ${carts[cartIndex].qty}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      const Text('Carted', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                    ],
                  )
                : Row(
                    children: [
                      const QtyBox(),
                      const SizedBox(width: 20),
                      BlackButton(
                          title: 'Add to cart',
                          onPressed: () async {
                            var userId = Provider.of<UserProvider>(context, listen: false).user.id!;
                            Cart cart = Cart(
                                userId: userId, productId: widget.product.docId!, qty: QtyBox.qty.value, time: DateTime.now());
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
                          }),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class QtyBox extends StatelessWidget {
  const QtyBox({Key? key}) : super(key: key);

  static ValueNotifier<int> qty = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              if (qty.value > 1) qty.value--;
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.remove, size: 15),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: ValueListenableBuilder<int>(
                valueListenable: qty,
                builder: (ctx, value, child) {
                  return Text(
                    '$value',
                    style: const TextStyle(fontSize: 18),
                  );
                })),
        Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              if (qty.value < 5) qty.value++;
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add, size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
