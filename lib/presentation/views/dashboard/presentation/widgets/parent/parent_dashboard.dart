import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/child_attendance.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/child_performance.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/upcoming_events.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/section_title.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/quick_actions.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/safety_dashboard.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/recent_activity.dart';
import 'package:student_management/presentation/views/exam/presentation/manager/exam_bloc/exam_bloc.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../../../../generated/generated_images.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key, required this.profileState});
  final ProfileManageState profileState;

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late final AttendanceBloc _attendanceBloc;
  late final ExamBloc _examBloc;
  late final NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _attendanceBloc = InjectorService.service.inject<AttendanceBloc>();
    _examBloc = InjectorService.service.inject<ExamBloc>();
    _notificationBloc = InjectorService.service.inject<NotificationBloc>();
    _fetchAllData();
  }

  void _fetchAllData() {
    final studentId = widget.profileState.profile?.id ?? '';
    if (studentId.isNotEmpty) {
      _attendanceBloc.add(FetchStudentAttendancePercentage(studentId));
      _examBloc.add(FetchStudentResults(studentId));
    }
    _notificationBloc.add(const FetchNotifications());
  }

  Future<void> _handleRefresh() async {
    _fetchAllData();
    // Give BLoCs time to process
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _attendanceBloc.close();
    _examBloc.close();
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileState.profile;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AttendanceBloc>.value(value: _attendanceBloc),
        BlocProvider<ExamBloc>.value(value: _examBloc),
        BlocProvider<NotificationBloc>.value(value: _notificationBloc),
      ],
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.bg3),
              fit: BoxFit.cover,
            ),
          ),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: SafeArea(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Header with Glass Effect
                          GlassyBackground(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${L!.welcomeBack}, ${profile?.firstName ?? 'Parent'}',
                                  style: AppStyles.large28.extraBold.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Here\'s what\'s happening with your child',
                                  style: AppStyles.medium.normal.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Child Attendance
                          const SectionTitle(title: 'Child Attendance'),
                          const SizedBox(height: 12),
                          const ChildAttendance(),
                          const SizedBox(height: 24),

                          // Child Performance
                          const SectionTitle(title: 'Performance Overview'),
                          const SizedBox(height: 12),
                          const ChildPerformance(),
                          const SizedBox(height: 24),

                          // Upcoming Events
                          const SectionTitle(title: 'Upcoming Events'),
                          const SizedBox(height: 12),
                          const UpcomingEvents(),
                          const SizedBox(height: 24),

                          // Quick Actions
                          const SectionTitle(title: 'Quick Actions'),
                          const SizedBox(height: 12),
                          const ParentQuickActions(),
                          const SizedBox(height: 24),

                          // Recent Activity
                          const SectionTitle(title: 'Recent Activity'),
                          const SizedBox(height: 12),
                          const RecentActivity(),
                          const SizedBox(height: 24),

                          // Safety & Compliance
                          const SafetyDashboard(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
