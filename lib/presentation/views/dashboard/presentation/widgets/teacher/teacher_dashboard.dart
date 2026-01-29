import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/manager/class_bloc/class_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/quick_actions.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/quick_stats_section.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/recent_activity.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/upcoming_classes.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/attendance_gauge.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/safety_dashboard.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AttendanceBloc>(
          create: (_) => InjectorService.service.inject<AttendanceBloc>(),
        ),
        BlocProvider<StudentBloc>(
          create: (_) => InjectorService.service.inject<StudentBloc>(),
        ),
        BlocProvider<ClassBloc>(
          create: (_) => InjectorService.service.inject<ClassBloc>(),
        ),
        BlocProvider<TimetableBloc>(
          create: (_) => InjectorService.service.inject<TimetableBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => InjectorService.service.inject<NotificationBloc>(),
        ),
      ],
      child: _TeacherDashboardContent(profileState: widget.profileState),
    );
  }
}

class _TeacherDashboardContent extends StatefulWidget {
  const _TeacherDashboardContent({required this.profileState});
  final ProfileManageState profileState;

  @override
  State<_TeacherDashboardContent> createState() =>
      _TeacherDashboardContentState();
}

class _TeacherDashboardContentState extends State<_TeacherDashboardContent> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final teacherId = widget.profileState.profile?.id ?? '';

    // Fetch today's attendance
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    context.read<AttendanceBloc>().add(FetchAttendanceByDate(dateStr));

    // Fetch students
    context.read<StudentBloc>().add(const FetchStudents());

    // Fetch classes
    context.read<ClassBloc>().add(const FetchAllClasses());

    // Fetch teacher's timetable
    if (teacherId.isNotEmpty) {
      context.read<TimetableBloc>().add(FetchTeacherTimetable(teacherId));
    }

    // Fetch notifications
    context.read<NotificationBloc>().add(const FetchNotifications());
  }

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
                  BlocBuilder<AttendanceBloc, AttendanceState>(
                    builder: (context, attendanceState) {
                      final records = attendanceState.records;
                      final total = records.length;
                      final present =
                          records.where((r) => r.isPresent || r.isLate).length;

                      return AttendanceGauge(
                        present: total > 0 ? present : 0,
                        total: total > 0 ? total : 0,
                        isLoading: attendanceState.isLoading,
                        profileState: widget.profileState,
                      );
                    },
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
