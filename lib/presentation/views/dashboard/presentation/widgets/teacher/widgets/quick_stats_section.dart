import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/manager/class_bloc/class_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/stat_item.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class QuickStatsSection extends StatelessWidget {
  const QuickStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              final count = state.isLoading ? '...' : '${state.students.length}';
              return StatItem(
                value: count,
                label: 'Students',
                icon: Icons.people_outline,
                color: Colors.blue,
              );
            },
          ),
          BlocBuilder<ClassBloc, ClassState>(
            builder: (context, state) {
              final count = state.isLoading ? '...' : '${state.classes.length}';
              return StatItem(
                value: count,
                label: 'Classes',
                icon: Icons.class_outlined,
                color: Colors.green,
              );
            },
          ),
          BlocBuilder<TimetableBloc, TimetableState>(
            builder: (context, state) {
              final count = state.isLoading ? '...' : '${state.entries.length}';
              return StatItem(
                value: count,
                label: 'Periods',
                icon: Icons.schedule_outlined,
                color: Colors.orange,
              );
            },
          ),
        ],
      ),
    );
  }
}
