import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import 'activity_item.dart';

class ActivityData {
  final String title;
  final String time;
  final IconData icon;

  const ActivityData({
    required this.title,
    required this.time,
    required this.icon,
  });
}

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final s = L;
    
    final activities = [
      ActivityData(
        title: s?.newAssignmentAdded ?? 'New assignment added',
        time: s?.hoursAgo(2) ?? '2 hours ago',
        icon: Icons.assignment,
      ),
      ActivityData(
        title: s?.gradeUpdatedForMathQuiz ?? 'Grade updated for Math Quiz',
        time: s?.daysAgo(1) ?? '1 day ago',
        icon: Icons.grade,
      ),
      ActivityData(
        title: s?.newStudentEnrolled ?? 'New student enrolled',
        time: s?.daysAgo(2) ?? '2 days ago',
        icon: Icons.person_add,
      ),
    ];

    return GlassyBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: activities.asMap().entries.map((entry) => ActivityItem(
          title: entry.value.title,
          time: entry.value.time,
          isLast: entry.key == activities.length - 1,
        )).toList(),
      ),
    );
  }
}
