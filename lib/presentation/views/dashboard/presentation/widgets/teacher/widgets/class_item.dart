import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import '../../../../../../../core/utils/app_global.dart';

class ClassItem extends StatelessWidget {
  final String time;
  final String subject;
  final String room;
  final bool isLast;
  final VoidCallback? onNotificationPressed;

  const ClassItem({
    super.key,
    required this.time,
    required this.subject,
    required this.room,
    this.isLast = false,
    this.onNotificationPressed,
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
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: AppStyles.semiMedium.regular.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: AppStyles.medium.regular.white,
                ),
                const SizedBox(height: 4),
                Text(
                  room,
                  style: AppStyles.regular.regular.white,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 20, color: AppColors.whiteColor),
            onPressed: onNotificationPressed,
            highlightColor: AppColors.darkCharcoal,
            tooltip: L?.notifyMe ?? 'Notify me',
          ),
        ],
      ),
    );
  }
}
