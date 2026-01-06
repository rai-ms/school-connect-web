import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class GlassyBackground extends StatelessWidget {
  const GlassyBackground({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
  });
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.msuGreen.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
