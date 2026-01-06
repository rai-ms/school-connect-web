import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/size_utils.dart'
    show CircularBorderRadius;

abstract class DesignHelper {
  static Decoration get decoration01 => BoxDecoration(
    color: AppColors.whiteColor.withValues(alpha: 0.1),
    borderRadius: CircularBorderRadius.b20,
  );

  static Decoration get decoration02 => BoxDecoration(
    color: AppColors.whiteColor.withValues(alpha: 0.2),
    borderRadius: CircularBorderRadius.b20,
  );

  static Decoration get decoration03 => BoxDecoration(
    color: AppColors.whiteColor.withValues(alpha: 0.3),
    borderRadius: CircularBorderRadius.b20,
  );

  static Decoration get decoration04 => BoxDecoration(
    color: AppColors.whiteColor.withValues(alpha: 0.4),
    borderRadius: CircularBorderRadius.b20,
  );

  static Decoration get decoration05 => BoxDecoration(
    color: AppColors.whiteColor.withValues(alpha: 0.5),
    borderRadius: CircularBorderRadius.b20,
  );
}
