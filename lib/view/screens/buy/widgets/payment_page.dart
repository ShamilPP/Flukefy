import 'package:flukefy/model/product.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/utils/constants.dart';
import 'package:flukefy/view/widgets/general/fill_remaining_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentPage extends StatefulWidget {
  final Product product;

  PaymentPage({Key? key, required this.product}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedPayment = PaymentMethod.CREDIT_CARD;

  @override
  Widget build(BuildContext context) {
    return FillRemainingScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              value: PaymentMethod.CREDIT_CARD,
              title: "Credit Card",
              icon: Icons.credit_card,
            ),
            const SizedBox(height: 5),
            _buildPaymentOption(
              value: PaymentMethod.UPI,
              title: "UPI (GPay/Paytm/PhonePe)",
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 5),
            _buildPaymentOption(
              value: PaymentMethod.PAYPAL,
              title: "PayPal",
              icon: Icons.account_balance,
            ),
            const SizedBox(height: 5),
            _buildPaymentOption(
              value: PaymentMethod.CASH_ON_DELIVERY,
              title: "Cash on Delivery",
              icon: Icons.money,
            ),
            _buildPriceDetails(widget.product),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Buy Action
                  Fluttertoast.showToast(msg: "You can't buy this product");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textSecondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("Buy"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({required int value, required String title, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title),
      trailing: Radio<int>(
        groupValue: selectedPayment,
        value: value,
        onChanged: (int? value) {
          if (value != null) {
            setState(() {
              selectedPayment = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildPriceDetails(Product product) {
    final discountedPrice = product.price - (product.price * product.discount / 100);

    return Card(
      elevation: 5,
      color: AppColors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Divider(thickness: 1.5),
            _priceDetailsTile(
              title: "Price",
              amount: "₹ ${product.price.toStringAsFixed(2)}",
              icon: Icons.price_check,
            ),
            _priceDetailsTile(
              title: "Discount",
              amount: "-${product.discount}%",
              icon: Icons.local_offer,
            ),
            _priceDetailsTile(
              title: "Delivery",
              amount: "FREE",
              icon: Icons.local_shipping,
            ),
            const Divider(thickness: 1.5),
            _priceDetailsTile(
              title: "Amount Payable",
              amount: "₹ ${discountedPrice.toStringAsFixed(2)}",
              icon: Icons.attach_money,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceDetailsTile({
    required String title,
    required String amount,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
