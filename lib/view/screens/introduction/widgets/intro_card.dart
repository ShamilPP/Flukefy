import 'package:flukefy/view/animations/size_animation.dart';
import 'package:flutter/material.dart';

import '../../../animations/fade_animation.dart';

class IntroCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const IntroCard({Key? key, required this.image, required this.title, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageHeight = MediaQuery.of(context).size.height / 2;
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizeAnimation(
                  delay: 300,
                  child: Center(child: Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                ),
                FadeAnimation(
                  delay: 600,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                      child: Image.asset(
                    image,
                    height: imageHeight,
                  )),
                ),
                SizeAnimation(
                  delay: 900,
                  child: Center(
                    child: Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
