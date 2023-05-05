import 'package:flukefy/model/product.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/buy/widgets/address_page.dart';
import 'package:flukefy/view/screens/buy/widgets/payment_page.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flutter/material.dart';

class BuyScreen extends StatefulWidget {
  final Product product;
  static ValueNotifier<int> pageNotifier = ValueNotifier(1);

  const BuyScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  int page = 1;

  @override
  void initState() {
    BuyScreen.pageNotifier.addListener(() {
      setState(() {
        page = BuyScreen.pageNotifier.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CurvedAppBar(title: page == 1 ? 'Address' : "Payment"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buyProgress(page == 1 ? 1 : null, 'Address', Colors.black, Colors.white),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(width: 100, child: Divider(thickness: 1, color: Colors.black)),
                ),
                buyProgress(2, 'Payment', page == 2 ? Colors.black : backgroundColor, page == 2 ? Colors.white : Colors.black),
              ],
            ),
          ),
          page == 1 ? AddressPage() : PaymentPage(product: widget.product),
        ],
      ),
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
