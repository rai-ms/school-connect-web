import 'package:flutter/material.dart';
import 'package:student_management/core/utils/size_utils.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
  });
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? AppPadding.padA15,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
        borderRadius: CircularBorderRadius.b10,
        boxShadow: [
          BoxShadow(
            spreadRadius: 0.3,
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.6),
            blurRadius: 0.4,
            offset: const Offset(0.1, 1.0),
          ),
        ],
      ),
      child: child,
    );
  }
}
