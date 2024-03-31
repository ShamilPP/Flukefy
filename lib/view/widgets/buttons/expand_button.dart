import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flutter/material.dart';

class ExpandButton extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final Color? color;
  final int animationDelay;
  final OutlinedBorder? shape;

  const ExpandButton({Key? key, required this.child, required this.onTap, this.color, this.animationDelay = 0, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: double.infinity,
        child: FadeAnimation(
          delay: animationDelay,
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              shape: shape,
              backgroundColor: color,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
