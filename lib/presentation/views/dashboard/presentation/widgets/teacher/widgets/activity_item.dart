import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isLast;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: AppColors.whiteColor,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.semiMedium.normal.white,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppStyles.semiMedium.medium.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
