import 'package:flutter/material.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class ChildPerformance extends StatelessWidget {
  const ChildPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: AppStyles.medium.medium.white,
          ),
          const SizedBox(height: 16),
          _buildSubjectProgress(
            'Mathematics',
            0.85,
            AppColors.blueColor,
          ),
          const SizedBox(height: 12),
          _buildSubjectProgress(
            'Science',
            0.78,
            AppColors.greenColor,
          ),
          const SizedBox(height: 12),
          _buildSubjectProgress(
            'English',
            0.92,
            AppColors.safetyOrange,
          ),
          const SizedBox(height: 12),
          _buildSubjectProgress(
            'History',
            0.68,
            AppColors.crayolaRed,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgress(
      String subject, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject,
              style: AppStyles.regular.normal.greyColor,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }
}
