import 'package:flukefy/utils/app_default.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/brand.dart';
import '../../../../view_model/brands_provider.dart';

class Brands extends StatelessWidget {
  const Brands({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandsProvider>(
      builder: (ctx, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // New Button
              Padding(padding: const EdgeInsets.only(left: 15), child: BrandCard(brand: AppDefault.defaultNewBrand)),

              if (provider.brands.data != null)
                ...List.generate(
                  provider.brands.data!.length,
                  (index) => SlideAnimation(
                    delay: 200,
                    position: SlidePosition.left,
                    child: BrandCard(brand: provider.brands.data![index]),
                  ),
                ),
            ],
          ),
        );
      },
    );
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
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.primaryColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : null,
              border: Border.all(color: AppColors.primaryColor),
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
            var productProvider = Provider.of<ProductsProvider>(context, listen: false);
            brandProvider.setSelectedBrand(brand);
            productProvider.loadBrandProducts(brand);
          },
        ),
      ),
    );
  }
}
