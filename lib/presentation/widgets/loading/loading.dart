import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/size_utils.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.height = 140,
    this.width = 180,
    this.fit = BoxFit.fill,
    required this.child,
    this.isLoading = false,
  });
  final double height;
  final double width;
  final BoxFit fit;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Space.h,
      width: Space.w,
      child: Stack(
        children: [
          SizedBox(height: Space.h, width: Space.w, child: child),
          if (isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.2),
              height: Space.h,
              width: Space.w,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.blueGrey),
              ),
            ),
        ],
      ),
    );
  }
}
