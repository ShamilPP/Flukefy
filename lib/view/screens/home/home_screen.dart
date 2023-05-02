import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/home/widgets/brands.dart';
import 'package:flukefy/view/screens/home/widgets/home_appbar.dart';
import 'package:flukefy/view/screens/home/widgets/home_drawer.dart';
import 'package:flukefy/view/screens/home/widgets/products_list.dart';
import 'package:flukefy/view/screens/home/widgets/products_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text('Find your product', style: TextStyle(fontSize: 25)),
            ),
            const SizedBox(height: 20),
            const Brands(),
            const SizedBox(height: 10),
            ProductsSlider(),
            const ProductsList(),
          ],
        ),
      ),
    );
  }
}
