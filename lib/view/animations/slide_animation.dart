import 'package:flutter/material.dart';

enum SlidePosition { top, bottom, right, left }

enum SlideDistance { slightly, high }

class SlideAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final SlidePosition position;
  final SlideDistance distance;

  const SlideAnimation({
    Key? key,
    required this.child,
    this.delay = 100,
    this.duration = const Duration(milliseconds: 300),
    this.position = SlidePosition.bottom,
    this.distance = SlideDistance.slightly,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlideAnimationState();
}

class SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<Offset> animOffset;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    opacity = Tween<double>(begin: 0, end: 1).animate(controller);
    animOffset = Tween<Offset>(begin: getOffset(), end: Offset.zero).animate(controller);

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
    return SlideTransition(
      position: animOffset,
      child: FadeTransition(
        opacity: opacity,
        child: widget.child,
      ),
    );
  }

  Offset getOffset() {
    double distance;
    // Set Offset Distance
    if (widget.distance == SlideDistance.slightly) {
      distance = 0.2;
    } else {
      distance = 1;
    }

    // Set slide position
    if (widget.position == SlidePosition.top) {
      return Offset(0, -distance);
    } else if (widget.position == SlidePosition.bottom) {
      return Offset(0, distance);
    } else if (widget.position == SlidePosition.right) {
      return Offset(distance, 0);
    } else {
      return Offset(-distance, 0);
    }
  }
}
