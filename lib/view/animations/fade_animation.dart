import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;

  const FadeAnimation({
    Key? key,
    required this.child,
    this.delay = 100,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FadeAnimationState();
}

class FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    // Waiting delay
    Future.delayed(Duration(milliseconds: widget.delay)).then(
      (value) {
        if (mounted) {
          controller.forward();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }
}
