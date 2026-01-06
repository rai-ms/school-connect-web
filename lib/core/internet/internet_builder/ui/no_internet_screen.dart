import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_extension.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/core/utils/utility_helper.dart';
import 'package:student_management/generated/generated_images.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.msuGreen,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.L.no_internet,
                style: AppStyles.larger.semiBold.white,
              ),
              UtilityHelper.assetImage(
                width: Space.w,
                path: AppAssets.noInternet,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
