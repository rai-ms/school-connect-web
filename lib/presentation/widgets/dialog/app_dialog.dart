import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_extension.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart'
    show Space, AppPadding;
import 'package:student_management/presentation/widgets/customs/custom_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    this.description,
    this.onTap,
    this.buttonTitle,
  });
  final String? title;
  final String? description;
  final String? buttonTitle;
  final VoidCallback? onTap;

  static Future<void> show(
    BuildContext context, {
    bool barrierDismissible = false,
    String? title,
    String? description,
    String? buttonTitle,
    VoidCallback? onTapButton,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          child: AppDialog(
            onTap: onTapButton,
            title: title,
            description: description,
            buttonTitle: buttonTitle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.padA20,
      decoration: BoxDecoration(
        color: AppColors.msuGreen.withValues(alpha: 1),
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(16),
          topEnd: Radius.circular(16),
          bottomStart: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title?.isNotEmpty ?? false)
            Text(title!, style: AppStyles.larger.semiBold.white),
          Space.h10,
          if (description?.isNotEmpty ?? false)
            Text(
              description!,
              style: AppStyles.baseStyle.medium.white.w4,
              textAlign: TextAlign.center,
            ),
          Space.h20,
          CustomButton(
            isActive: true,
            onPressed: onTap ?? () => Navigator.of(context).pop(),
            child: Text(
              buttonTitle ?? "Submit",
              style: AppStyles.baseStyle.medium.white,
            ),
          ),
        ],
      ),
    );
  }
}
