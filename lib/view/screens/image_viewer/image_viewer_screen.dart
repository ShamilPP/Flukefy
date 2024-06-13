import 'package:flukefy/view/widgets/appbar/curved_appbar.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  final String? tag;

  const ImageViewer({Key? key, required this.image, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Image
          tag == null
              ? body()
              : Hero(
                  tag: tag!,
                  child: body(),
                ),
          // Appbar
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top + 50,
            child: const CurvedAppBar(
              title: 'Image',
              elevation: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return InteractiveViewer(
      child: Center(
        child: Image.network(image),
      ),
    );
  }
}
