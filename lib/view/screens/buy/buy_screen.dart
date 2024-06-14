import 'package:flukefy/model/product.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/utils/constants.dart';
import 'package:flukefy/view/screens/buy/widgets/address_page.dart';
import 'package:flukefy/view/screens/buy/widgets/payment_page.dart';
import 'package:flukefy/view/widgets/appbar/curved_appbar.dart';
import 'package:flukefy/view_model/buy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum BuyProgress { incompleted, active, completed }

class BuyScreen extends StatefulWidget {
  final Product product;

  const BuyScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<BuyProvider>(context, listen: false);
      provider.loadAddress(context);
      provider.setPage(OrderScreenPage.ADDRESS);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: CurvedAppBar(title: 'Order Screen'),
      body: Consumer<BuyProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBuyStepIndicator(
                    progress: provider.page == OrderScreenPage.ADDRESS ? BuyProgress.active : BuyProgress.completed,
                    title: 'Address',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                  ),
                  _buildBuyStepIndicator(
                    progress: provider.page == OrderScreenPage.PAYMENT ? BuyProgress.active : BuyProgress.incompleted,
                    title: 'Payment',
                  ),
                ],
              ),
            ),
            Expanded(
              child: provider.page == OrderScreenPage.ADDRESS ? AddressPage() : PaymentPage(product: widget.product),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBuyStepIndicator({required BuyProgress progress, required String title}) {
    Color color;
    Widget child;

    if (progress == BuyProgress.completed) {
      color = AppColors.primaryColor;
      child = Icon(Icons.check, color: Colors.white);
    } else if (progress == BuyProgress.active) {
      color = AppColors.primaryColor;
      child = Icon(Icons.radio_button_unchecked, color: Colors.white);
    } else {
      color = AppColors.greyColor;
      child = Text('2', style: TextStyle(color: Colors.white));
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: child,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: progress == BuyProgress.active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
