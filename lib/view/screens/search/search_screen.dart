import 'package:flukefy/model/product.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flukefy/view/screens/product/product_screen.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> products = [];
  List<Product> searchedProducts = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    products = Provider.of<ProductsProvider>(context, listen: false).products;
    searchedProducts = products;
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: const Text('Flukefy'),
          centerTitle: true,
          backgroundColor: backgroundColor,
          foregroundColor: Colors.black,
          elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Search TextField
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                              searchedProducts = products;
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

  void onTextChanged(String searchedName) {
    List<Product> _products = [];
    for (var user in products) {
      if (user.name.toLowerCase().contains(searchedName.toLowerCase())) {
        _products.add(user);
      }
    }
    setState(() {
      searchedProducts = _products;
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
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: product, imageHeroTag: heroTag)));
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
                          child: Image.network(
                            product.images[0],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: SpinKitPulse(color: Colors.black, size: 30),
                                ),
                              );
                            },
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
                              child: Text(product.name,
                                  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
                            ),
                            FadeAnimation(
                              delay: 400,
                              animateEveryBuild: true,
                              child: Text(product.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeAnimation(
                      delay: 500,
                      animateEveryBuild: true,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '${product.rating} ★',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
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
}
