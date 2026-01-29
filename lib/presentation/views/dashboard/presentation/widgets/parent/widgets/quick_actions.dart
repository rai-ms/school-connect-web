import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/size_utils.dart';

import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class ParentQuickActions extends StatelessWidget {
  const ParentQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.school,
        'label': 'Homework',
        'color': Colors.blue,
        'route': RoutesName.examList,
      },
      {
        'icon': Icons.assignment,
        'label': 'Assignments',
        'color': Colors.green,
        'route': RoutesName.examList,
      },
      {
        'icon': Icons.attach_money,
        'label': 'Fees',
        'color': Colors.orange,
        'route': RoutesName.feeDashboard,
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Schedule',
        'color': Colors.purple,
        'route': RoutesName.notifications,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionItem(
          context: context,
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          color: action['color'] as Color,
          route: action['route'] as String,
        );
      },
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(route);
      },
      child: GlassyBackground(
        padding: AppPadding.z,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Space.h8,
            Text(
              label,
              style: AppStyles.regular.normal.white,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
