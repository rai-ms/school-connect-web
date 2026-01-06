import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';

class BackgroundShader extends StatelessWidget {
  const BackgroundShader({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blackColor,
                  AppColors.darkGunMetal,
                  // Color(0xFF031C5B),
                  AppColors.blackColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}
