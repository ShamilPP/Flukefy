import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/brand.dart';
import '../../../../view_model/brands_provider.dart';

class Brands extends StatelessWidget {
  const Brands({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandsProvider>(builder: (ctx, provider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: BrandCard(brand: Brand(docId: 'New', name: 'New')),
            ),
            ...List.generate(
                provider.brands.length,
                (index) => SlideAnimation(
                      delay: 200,
                      position: SlidePosition.left,
                      child: BrandCard(brand: provider.brands[index]),
                    ))
          ],
        ),
      );
    });
  }
}

class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brandProvider = Provider.of<BrandsProvider>(context, listen: false);
    bool isSelected = brandProvider.selectedBrand.docId == brand.docId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: primaryColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : null,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                brand.name,
                style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : Colors.black),
              ),
            ),
          ),
          onTap: () async {
            brandProvider.setBrand(brand);
          },
        ),
      ),
    );
  }
}
