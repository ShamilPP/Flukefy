import 'package:carousel_slider/carousel_slider.dart';
import 'package:flukefy/model/product.dart';
import 'package:flukefy/view/screens/image_viewer/image_viewer_screen.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final Product product;
  final String imageHeroTag;

  const ImageSlider({required this.product, Key? key, required this.imageHeroTag}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;
  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          options: CarouselOptions(
            height: 300,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemCount: widget.product.images.length,
          itemBuilder: (ctx, index, value) {
            var heroTag = index == 0 ? widget.imageHeroTag : '$value';
            return Padding(
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageViewer(
                                image: widget.product.images[index],
                                tag: heroTag,
                              )));
                },
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    widget.product.images[index],
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.product.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(currentIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
