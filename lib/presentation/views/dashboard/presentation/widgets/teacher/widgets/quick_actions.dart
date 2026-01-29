import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'action_button.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.assignment, 'label': L?.assignments ?? 'Assignments', 'route': RoutesName.assignmentList},
      {'icon': Icons.grade, 'label': L?.grades ?? 'Grades', 'route': RoutesName.examList},
      {'icon': Icons.calendar_today, 'label': L?.schedule ?? 'Schedule', 'route': RoutesName.calendarHome},
      {'icon': Icons.chat, 'label': L?.messages ?? 'Messages', 'route': RoutesName.notifications},
    ];

    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      runSpacing: 10,
      spacing: 10,
      children: actions.map((action) => SizedBox(
        height: 80,
        width: 80,
        child: ActionButton(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          onTap: () {
            final route = action['route'] as String?;
            if (route != null) {
              context.push(route);
            }
          },
        ),
      ))
          .toList(),
    );
  }
}
