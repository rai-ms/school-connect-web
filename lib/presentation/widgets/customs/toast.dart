import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart' show AppColors;
import 'package:student_management/core/utils/app_extension.dart';
import 'package:student_management/core/utils/app_style.dart';


class CustomToast {
  String message;
  final Widget? icon;
  final Alignment? alignment;
  final bool showIcon;
  CustomToast({
    required BuildContext context,
    required this.message,
    this.icon,
    this.alignment,
    this.showIcon = true,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 130),
        child: SafeArea(
          child: Scaffold(
            body: Align(
              alignment: alignment ?? Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkBlueColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.greyColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showIcon)
                      Flexible(
                        child:
                            icon ??
                            const Icon(
                              Icons.notifications_on_rounded,
                              color: AppColors.whiteColor,
                            ),
                      ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(message, style: AppStyles.baseStyle.s12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

void _snackBar({
  required String message,
  required BuildContext ctx,
  DismissDirection dismissDirection = DismissDirection.down,
  Color backgroundColor = AppColors.chineseBlack,
  TextStyle? textStyle
}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        dismissDirection: dismissDirection,
        elevation: 20,
        hitTestBehavior: HitTestBehavior.opaque,
        showCloseIcon: true,
        content: Text(
          message,
          style: textStyle ?? AppStyles.large.regular.white
        )
    ),
  );
}

extension XSnackBar on BuildContext{
  void snackBar ({
    required String message,
    DismissDirection dismissDirection = DismissDirection.down,
    Color backgroundColor = AppColors.chineseBlack,
    TextStyle? textStyle
  }) => _snackBar(message: message, backgroundColor: backgroundColor, dismissDirection: dismissDirection, textStyle: textStyle, ctx: this);
}