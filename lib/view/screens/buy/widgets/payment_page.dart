import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../model/product.dart';
import '../../../widgets/buttons/black_button.dart';

class PaymentPage extends StatefulWidget {
  final Product product;

  const PaymentPage({Key? key, required this.product}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String paymentMethod = "GPay";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile(
                    title: const Text('GPay'),
                    value: 'GPay',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Paytm'),
                    value: "Paytm",
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('PhonePay'),
                    value: "PhonePay",
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Cash on delivery'),
                    value: "Cash on delivery",
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("PRICE DETAILS"),
                            const Divider(),
                            _priceDetailsTile('Price', '₹ ${widget.product.price}'),
                            _priceDetailsTile(
                              'Discount (${widget.product.discount}%)',
                              '-${(widget.product.price * widget.product.discount ~/ 100).toInt()}',
                            ),
                            _priceDetailsTile('Delivery', 'FREE'),
                            const Divider(),
                            _priceDetailsTile('Amount payable',
                                '₹ ${widget.product.price - (widget.product.price * widget.product.discount ~/ 100)}'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: BlackButton(
              title: 'Buy',
              onPressed: () async {
                Fluttertoast.showToast(msg: 'Currently unavailable');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceDetailsTile(String title, String endTitle) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        Text(endTitle),
      ],
    );
  }
}
