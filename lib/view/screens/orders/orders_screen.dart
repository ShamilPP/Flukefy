import 'package:flutter/material.dart';

import '../../widgets/general/curved_app_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: 'Orders',
      ),
      body: Center(
        child: Text('No orders'),
      ),
    );
  }
}
