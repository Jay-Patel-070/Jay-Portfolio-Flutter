import 'package:flutter/material.dart';

class TypingLoader extends StatefulWidget {
  final double fontSize;
  final Color? color;

  const TypingLoader({Key? key, this.fontSize = 24, this.color}) : super(key: key);

  @override
  _TypingLoaderState createState() => _TypingLoaderState();
}

class _TypingLoaderState extends State<TypingLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final String _text = "Jay Patel...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _animation = IntTween(begin: 0, end: _text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          String visibleText = _text.substring(0, _animation.value);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                visibleText,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.color ?? Theme.of(context).colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
              Opacity(
                opacity: _controller.value > 0.5 ? 1.0 : 0.0,
                child: Text(
                  "|",
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
