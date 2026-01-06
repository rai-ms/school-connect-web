import 'package:flutter/material.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/stat_item.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class QuickStatsSection extends StatelessWidget {
  const QuickStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      padding: EdgeInsets.all(10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            value: '24',
            label: 'Students',
            icon: Icons.people_outline,
            color: Colors.blue,
          ),
          StatItem(
            value: '5',
            label: 'Classes',
            icon: Icons.class_outlined,
            color: Colors.green,
          ),
          StatItem(
            value: '12',
            label: 'Tasks',
            icon: Icons.assignment_outlined,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
