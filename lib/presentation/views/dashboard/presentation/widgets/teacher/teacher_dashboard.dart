import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/quick_actions.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/quick_stats_section.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/recent_activity.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/upcoming_classes.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/attendance_gauge.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/safety_dashboard.dart';
import '../../manager/profile_management_bloc/profile_management_bloc.dart';
import 'widgets/section_title.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key, required this.profileState});
  final ProfileManageState profileState;

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attendance Gauge
                  AttendanceGauge(
                    present: 100,
                    total: 120,
                    profileState: widget.profileState,
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats
                  QuickStatsSection(),
                  const SizedBox(height: 16),

                  // Upcoming Classes
                  SectionTitle(title: L!.upcomingClasses),
                  const SizedBox(height: 12),
                  UpcomingClasses(),
                  const SizedBox(height: 24),

                  // Quick Actions
                  SectionTitle(title: L!.quickActions),
                  const SizedBox(height: 12),
                  QuickActions(),
                  const SizedBox(height: 24),

                  // Recent Activity
                  SectionTitle(title: L!.recentActivity),
                  const SizedBox(height: 12),
                  RecentActivity(),
                  const SizedBox(height: 24),

                  // Safety & Compliance
                  SafetyDashboard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
