import 'package:flukefy/model/product.dart';
import 'package:flukefy/view_model/brands_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/brand.dart';

class MoreDetails extends StatelessWidget {
  final Product product;

  const MoreDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.all(borderRadius: BorderRadius.circular(2)),
      children: [
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Brand", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(getBrand(context, product.brandId).name, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Description", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(product.description, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }

  Brand getBrand(BuildContext context, String docId) {
    var brands = Provider.of<BrandsProvider>(context, listen: false).brands;
    return brands[brands.indexWhere((element) => element.docId == docId)];
  }
}
