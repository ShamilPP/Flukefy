import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height, width;
  final BoxFit? fit;

  const LoadingNetworkImage(this.imageUrl, {this.height, this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (ctx, ob, st) => Image.asset('assets/images/general/broken_image.png', height: height, width: width),
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: Center(
            child: SpinKitPulse(color: Colors.black, size: 30),
          ),
        );
      },
    );
  }
}
