import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/size_utils.dart';

class BuildStatItem extends StatelessWidget {
  const BuildStatItem({
    super.key,
    required this.label,
    required this.studentCount,
    required this.icon,
    required this.color,
  });
  final String label;
  final String studentCount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppPadding.padA8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        Space.h8,
        Text(
          studentCount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.chineseBlack,
          ),
        ),
        Space.h4,
        Text(label, style: TextStyle(color: AppColors.darkElectricBlue)),
      ],
    );
  }
}
