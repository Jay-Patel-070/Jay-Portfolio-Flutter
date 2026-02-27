import 'package:flutter/material.dart';

class HoverAnimation extends StatefulWidget {
  final Widget child;
  final double scaleTarget;
  final double tiltTarget;

  const HoverAnimation({
    Key? key,
    required this.child,
    this.scaleTarget = 1.05,
    this.tiltTarget = 0.0,
  }) : super(key: key);

  @override
  _HoverAnimationState createState() => _HoverAnimationState();
}

class _HoverAnimationState extends State<HoverAnimation> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(_isHovered ? widget.tiltTarget : 0.0)
          ..rotateY(_isHovered ? -widget.tiltTarget : 0.0)
          ..scale(_isHovered ? widget.scaleTarget : 1.0),
        child: widget.child,
      ),
    );
  }
}
