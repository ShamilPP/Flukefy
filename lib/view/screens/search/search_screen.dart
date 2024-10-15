import 'package:flukefy/model/brand.dart';
import 'package:flukefy/model/product.dart';
import 'package:flukefy/model/result.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flukefy/view/screens/product/product_screen.dart';
import 'package:flukefy/view_model/brands_provider.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/general/loading_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> allProducts = [];
  List<Product> searchedProducts = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    var provider = Provider.of<ProductsProvider>(context, listen: false);
    if (provider.products.status == ResultStatus.success) {
      allProducts = provider.products.data!.toList();
      allProducts.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      searchedProducts = allProducts;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Flukefy'), centerTitle: true, backgroundColor: AppColors.backgroundColor, foregroundColor: Colors.black, elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Search TextField
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.text.isNotEmpty
                      ? Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: const Icon(Icons.cancel),
                            onTap: () => setState(() {
                              controller.clear();
                              searchedProducts = allProducts;
                            }),
                          ),
                        )
                      : null,
                ),
                onChanged: onTextChanged,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchedProducts.length,
                itemBuilder: (ctx, index) {
                  return productCard(searchedProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTextChanged(String value) {
    List<Product> products = [];
    for (var product in allProducts) {
      var brand = getBrand(product.brandId);
      if (product.name.toLowerCase().contains(value.toLowerCase()) ||
          product.description.toLowerCase().contains(value.toLowerCase()) ||
          (brand != null && brand.name.toString().contains(value.toLowerCase()))) {
        products.add(product);
      }
    }
    setState(() {
      searchedProducts = products;
    });
  }

  Widget productCard(Product product) {
    final String heroTag = '${product.docId}Search';

    return SlideAnimation(
      delay: 100,
      animateEveryBuild: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.secondaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: product, heroTag: heroTag)));
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      delay: 200,
                      animateEveryBuild: true,
                      child: Hero(
                        tag: heroTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LoadingNetworkImage(
                            product.images[0],
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FadeAnimation(
                              delay: 300,
                              animateEveryBuild: true,
                              child: Text(product.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
                            ),
                            FadeAnimation(
                              delay: 400,
                              animateEveryBuild: true,
                              child: Text(product.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Brand? getBrand(String brandId) {
    var allBrands = Provider.of<BrandsProvider>(context, listen: false).brands;
    if (allBrands.data != null) {
      for (var brand in allBrands.data!) {
        if (brand.docId == brandId) {
          return brand;
        }
      }
    }
    return null;
  }
}
