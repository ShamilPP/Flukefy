import 'package:flukefy/model/product.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/buy/widgets/address_page.dart';
import 'package:flukefy/view/screens/buy/widgets/payment_page.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flukefy/view_model/buy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyScreen extends StatelessWidget {
  final Product product;

  const BuyScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CurvedAppBar(title: "Order Screen"),
      body: Consumer<BuyProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buyProgress(provider.page == 1 ? 1 : null, 'Address', Colors.black, Colors.white),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(width: 100, child: Divider(thickness: 1, color: Colors.black)),
                  ),
                  buyProgress(2, 'Payment', provider.page == 2 ? Colors.black : backgroundColor,
                      provider.page == 2 ? Colors.white : Colors.black),
                ],
              ),
            ),
            provider.page == 1 ? const AddressPage() : PaymentPage(product: product),
          ],
        );
      }),
    );
  }

  Widget buyProgress(int? progressNum, String title, Color backgroundColor, Color foregroundColor) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: progressNum == null
                ? Icon(Icons.check, size: 20, color: foregroundColor)
                : Text('$progressNum', style: TextStyle(fontSize: 16, color: foregroundColor)),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
