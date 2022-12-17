import 'package:flukefy/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  final String? tag;

  const ImageViewer({Key? key, required this.image, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Image'),
      body: tag == null
          ? body()
          : Hero(
              tag: tag!,
              child: body(),
            ),
    );
  }

  Widget body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Image.network(image),
      ),
    );
  }
}
