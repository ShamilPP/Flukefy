import 'package:flukefy/view/screens/image_viewer/image_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../widgets/general/loading_network_image.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final String heroTag;

  const ImageSlider({required this.images, Key? key, required this.heroTag}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;
  CarouselSliderController controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            itemCount: widget.images.length,
            itemBuilder: (ctx, index, value) {
              var heroTag = index == 0 ? widget.heroTag : '$index';
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageViewer(
                                image: widget.images[index],
                                tag: heroTag,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Hero(
                    tag: heroTag,
                    child: LoadingNetworkImage(
                      widget.images[index],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),

          // Number of images
          Positioned.fill(
            bottom: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
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
            ),
          ),
        ],
      ),
    );
  }
}
