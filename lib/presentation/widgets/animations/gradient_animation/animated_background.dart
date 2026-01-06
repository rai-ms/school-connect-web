import 'package:flutter/material.dart';

class BorderOrbit extends StatefulWidget {
  final double width;
  final double height;
  final List<Widget> children;
  final Duration duration;
  final double childSize;

  const BorderOrbit({
    super.key,
    required this.width,
    required this.height,
    required this.children,
    this.duration = const Duration(seconds: 30),
    this.childSize = 250,
  });

  @override
  State<BorderOrbit> createState() => _BorderOrbitState();
}

class _BorderOrbitState extends State<BorderOrbit> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  Offset _calculatePosition(double t) {
    final w = widget.width;
    final h = widget.height;
    final size = widget.childSize;

    double x = 0, y = 0;

    if (t < 0.25) {
      final progress = t / 0.25;
      x = progress * (w - size);
      y = 0;
    } else if (t < 0.5) {
      final progress = (t - 0.25) / 0.25;
      x = w - size;
      y = progress * (h - size);
    } else if (t < 0.75) {
      final progress = (t - 0.5) / 0.25;
      x = (1 - progress) * (w - size);
      y = h - size;
    } else {
      final progress = (t - 0.75) / 0.25;
      x = 0;
      y = (1 - progress) * (h - size);
    }

    return Offset(x, y);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childSize = widget.childSize;
    final childCount = widget.children.length;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Stack(
            children: List.generate(childCount, (i) {
              final double t = (_animation.value + (i / childCount)) % 1.0;
              final pos = _calculatePosition(t);
              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: SizedBox(
                  width: childSize,
                  height: childSize,
                  child: widget.children[i],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
