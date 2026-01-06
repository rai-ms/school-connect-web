import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';

class MoonShaderWidget extends StatelessWidget {
  const MoonShaderWidget({
    super.key,
    required this.height,
    this.shaderColor = AppColors.blackColor,
    required this.backgroundColor,
  });

  final double height;
  final Color shaderColor, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blackColor.withValues(alpha: 0.01),
            AppColors.blackColor.withValues(alpha: 0.1),
            AppColors.blackColor.withValues(alpha: 0.2),
            AppColors.blackColor.withValues(alpha: 0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
