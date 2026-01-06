import 'package:flutter/material.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class ChildAttendance extends StatelessWidget {
  const ChildAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance',
                style: AppStyles.medium.medium.white,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '95%',
                  style: AppStyles.medium.medium.greyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.95,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
            minHeight: 8,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Present: 19/20 days',
                style: AppStyles.regular.normal.greyColor,
              ),
              Text(
                'Absent: 1 day',
                style: AppStyles.regular.normal.greyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
