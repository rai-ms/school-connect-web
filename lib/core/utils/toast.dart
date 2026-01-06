import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart' show AppColors;
import 'package:student_management/core/utils/app_enum.dart' show ToastType;
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart'
    show Space, AppPadding, CircularBorderRadius;

extension _ToastColorExt on ToastType {
  Color get color {
    switch (this) {
      case ToastType.success:
        return AppColors.brunswickGreen;
      case ToastType.error:
        return AppColors.kuCrimson;
    }
  }
}

void toast(
  String message, {
  bool isLong = false,
  BuildContext? context,
  ToastType toastType = ToastType.success,
}) {
  BotToast.showCustomNotification(
    duration: const Duration(seconds: 5),
    toastBuilder: (cancel) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 750),
        padding: AppPadding.padA16,
        margin: AppPadding.padA20,
        decoration: BoxDecoration(
          color: toastType.color,
          borderRadius: CircularBorderRadius.b6,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.start,
                style: AppStyles.medium.semiBold.white,
              ),
            ),
            Space.w50,
            GestureDetector(
              onTap: cancel,
              child: const Icon(
                Icons.close,
                color: AppColors.whiteColor,
                size: 17,
              ),
            ),
          ],
        ),
      );
    },
  );
}
