import 'package:flutter/material.dart';

import '../../widgets/appbar/curved_appbar.dart';

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
