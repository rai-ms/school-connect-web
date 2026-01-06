import 'package:flutter/material.dart';
import 'dart:math';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_utils.dart';

class RotatingDotsLoader extends StatefulWidget {
  final double size;
  final Color color;
  final int dotCount;
  final bool isLoading;
  final bool isShowChildDuringLoading;
  final Widget? child;
  final List<Color>? colors;

  const RotatingDotsLoader({
    super.key,
    this.size = 40,
    this.isLoading = false,
    this.isShowChildDuringLoading = true,
    this.color = Colors.blue,
    this.dotCount = 5,
    this.child,
    this.colors = const [
      AppColors.blueColor,
      AppColors.safetyYellow,
      AppColors.greenColor,
      AppColors.safetyOrange,
      AppColors.safetyRed,
    ],
  });

  @override
  State<RotatingDotsLoader> createState() => _RotatingDotsLoaderState();
}

class _RotatingDotsLoaderState extends State<RotatingDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(!(widget.isShowChildDuringLoading && widget.isLoading))widget.child ?? Space.z,
        if(widget.isLoading)Center(
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(widget.dotCount, (index) {
                      final angle = (2 * pi / widget.dotCount) * index;
                      final radius = widget.size * 0.35;

                      // pick color (cycle if needed, fallback to default)
                      final dotColor = (widget.colors != null && widget.colors!.isNotEmpty)
                          ? widget.colors![index % widget.colors!.length]
                          : widget.color;

                      return Transform.translate(
                        offset: Offset(
                          cos(angle) * radius,
                          sin(angle) * radius,
                        ),
                        child: _dot(dotColor),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(Color dotColor) => Container(
    width: widget.size * 0.2,
    height: widget.size * 0.2,
    decoration: BoxDecoration(
      color: dotColor,
      shape: BoxShape.circle,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
