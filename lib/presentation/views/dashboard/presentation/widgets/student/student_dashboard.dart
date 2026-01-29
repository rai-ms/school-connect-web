import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/views/notification/data/models/notification_model.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';
import 'package:student_management/presentation/views/timetable/data/models/timetable_entry_model.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key, required this.profileState});
  final ProfileManageState profileState;

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  static const List<String> _dayNames = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  String? _studentClassId;

  String get _todayDayName {
    final weekday = DateTime.now().weekday; // 1=Monday, 7=Sunday
    return _dayNames[(weekday - 1).clamp(0, 6)];
  }

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final userId = widget.profileState.profile?.id;
    if (userId != null && userId.isNotEmpty) {
      // Fetch attendance percentage using userId as studentId
      context
          .read<AttendanceBloc>()
          .add(FetchStudentAttendancePercentage(userId));

      // Fetch student details to get classId for timetable
      context.read<StudentBloc>().add(FetchStudentById(userId));
    }

    // Fetch recent notifications
    context.read<NotificationBloc>().add(const FetchNotifications());
  }

  void _loadTimetable(String classId) {
    context.read<TimetableBloc>().add(FetchClassTimetable(classId));
  }

  Future<void> _handleRefresh() async {
    final userId = widget.profileState.profile?.id;
    if (userId != null && userId.isNotEmpty) {
      context
          .read<AttendanceBloc>()
          .add(FetchStudentAttendancePercentage(userId));
      context.read<StudentBloc>().add(FetchStudentById(userId));
    }
    context.read<NotificationBloc>().add(const FetchNotifications());
    if (_studentClassId != null) {
      _loadTimetable(_studentClassId!);
    }
    // Give BLoCs time to respond
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Color _getSubjectColor(String? subject) {
    if (subject == null) return AppColors.greenCyan;
    final hash = subject.hashCode;
    final colors = [
      AppColors.greenCyan,
      AppColors.selectiveYellow,
      AppColors.kuCrimson,
      AppColors.myrtleGreen,
      AppColors.greenCyan,
      AppColors.selectiveYellow,
      AppColors.kuCrimson,
    ];
    return colors[hash.abs() % colors.length];
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'FEE_REMINDER':
        return Icons.payment;
      case 'ATTENDANCE_ALERT':
        return Icons.fact_check;
      case 'EXAM_NOTICE':
        return Icons.school;
      case 'ANNOUNCEMENT':
        return Icons.campaign;
      case 'LEAVE_STATUS':
        return Icons.event_available;
      case 'TIMETABLE_CHANGE':
        return Icons.schedule;
      case 'RESULT_PUBLISHED':
        return Icons.grade;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'FEE_REMINDER':
        return AppColors.selectiveYellow;
      case 'ATTENDANCE_ALERT':
        return AppColors.kuCrimson;
      case 'EXAM_NOTICE':
        return AppColors.greenCyan;
      case 'ANNOUNCEMENT':
        return AppColors.myrtleGreen;
      case 'LEAVE_STATUS':
        return AppColors.greenCyan;
      case 'TIMETABLE_CHANGE':
        return AppColors.selectiveYellow;
      case 'RESULT_PUBLISHED':
        return AppColors.kuCrimson;
      default:
        return AppColors.greenCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final profile = widget.profileState.profile;

    return BlocListener<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state.isSuccess && state.selectedStudent != null) {
          final classId = state.selectedStudent!.currentClassId;
          if (classId != null && classId.isNotEmpty && classId != _studentClassId) {
            _studentClassId = classId;
            _loadTimetable(classId);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.ghostWhite,
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: size.height * 0.18,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkGunMetal,
                          AppColors.myrtleGreen,
                        ],
                      ),
                    ),
                    padding:
                        AppPadding.padSH16.copyWith(top: 12.v, bottom: 12.v),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${L!.welcomeBack}, ${profile?.firstName ?? "Student"}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Space.h4,
                          Text(
                            'Here\'s your dashboard',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  AppColors.whiteColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppPadding.padSV16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats Row
                      _buildQuickStats(theme),
                      Space.h24,

                      // Upcoming Classes
                      _buildSectionHeader('Today\'s Classes', theme),
                      Space.h12,
                      _buildUpcomingClasses(theme),
                      Space.h24,

                      // Quick Actions
                      _buildSectionHeader('Quick Actions', theme),
                      Space.h12,
                      _buildQuickActions(theme),
                      Space.h24,

                      // Recent Activity
                      _buildSectionHeader('Recent Activity', theme),
                      Space.h12,
                      _buildRecentActivity(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== QUICK STATS (Real Data) ====================

  Widget _buildQuickStats(ThemeData theme) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, attendanceState) {
        final pct = attendanceState.percentage;
        final attendanceStr =
            pct != null ? '${pct.percentage.toStringAsFixed(1)}%' : '--';
        final presentDays = pct?.presentDays.toString() ?? '--';
        final absentDays = pct?.absentDays.toString() ?? '--';

        return Container(
          padding: AppPadding.padSV16,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: attendanceState.isLoading && pct == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      attendanceStr,
                      'Attendance',
                      Icons.calendar_today,
                      AppColors.greenCyan,
                      theme,
                    ),
                    _buildStatItem(
                      presentDays,
                      'Present Days',
                      Icons.check_circle_outline,
                      AppColors.selectiveYellow,
                      theme,
                    ),
                    _buildStatItem(
                      absentDays,
                      'Absent Days',
                      Icons.cancel_outlined,
                      AppColors.kuCrimson,
                      theme,
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildStatItem(
      String value, String label, IconData icon, Color color, ThemeData theme) {
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
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.chineseBlack,
          ),
        ),
        Space.h4,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.darkElectricBlue,
          ),
        ),
      ],
    );
  }

  // ==================== UPCOMING CLASSES (Real Timetable Data) ====================

  Widget _buildUpcomingClasses(ThemeData theme) {
    return BlocBuilder<TimetableBloc, TimetableState>(
      builder: (context, timetableState) {
        if (timetableState.isLoading && timetableState.entries.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        // Filter entries for today
        final todayEntries = timetableState.entries.where((entry) {
          return entry.dayOfWeek.toUpperCase() == _todayDayName &&
              entry.isActive &&
              !(entry.period?.isBreak ?? false);
        }).toList()
          ..sort((a, b) => (a.period?.periodNumber ?? 0)
              .compareTo(b.period?.periodNumber ?? 0));

        if (todayEntries.isEmpty) {
          return Container(
            padding: AppPadding.padSV16,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy,
                      size: 40,
                      color: AppColors.romanSilver.withValues(alpha: 0.5)),
                  Space.h8,
                  Text(
                    'No classes scheduled for today',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.romanSilver,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: AppPadding.padSV8,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayEntries.length,
          separatorBuilder: (_, __) => Space.h12,
          itemBuilder: (context, index) {
            final entry = todayEntries[index];
            return _buildClassCard(entry, theme);
          },
        );
      },
    );
  }

  Widget _buildClassCard(TimetableEntryResponse entry, ThemeData theme) {
    final color = _getSubjectColor(entry.subjectName);
    final period = entry.period;
    final timeRange = period != null ? period.timeRange : '';

    return Container(
      padding: AppPadding.padSV16,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Space.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.subjectName ?? 'Subject',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.chineseBlack,
                  ),
                ),
                Space.h4,
                Text(
                  timeRange,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkElectricBlue,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.room ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkElectricBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Space.h4,
              Text(
                entry.teacherName ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.romanSilver,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== QUICK ACTIONS (Real Navigation) ====================

  Widget _buildQuickActions(ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      padding: AppPadding.padSV8,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.8,
      children: [
        _buildActionItem(
          Icons.assignment,
          'Assignments',
          AppColors.greenCyan,
          theme,
          onTap: () => context.push(RoutesName.examList),
        ),
        _buildActionItem(
          Icons.calendar_today,
          'Schedule',
          AppColors.kuCrimson,
          theme,
          onTap: () {
            if (_studentClassId != null && _studentClassId!.isNotEmpty) {
              context.push(
                  RoutesName.timetable.replaceFirst(':classId', _studentClassId!));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Class information not available yet')),
              );
            }
          },
        ),
        _buildActionItem(
          Icons.school,
          'Courses',
          AppColors.selectiveYellow,
          theme,
          onTap: () => context.push(RoutesName.classList),
        ),
        _buildActionItem(
          Icons.assessment,
          'Grades',
          AppColors.myrtleGreen,
          theme,
          onTap: () => context.push(RoutesName.examList),
        ),
      ],
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, ThemeData theme,
      {VoidCallback? onTap}) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: AppPadding.padA12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppPadding.padA12,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Space.h8,
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.darkElectricBlue,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== RECENT ACTIVITY (Real Notifications) ====================

  Widget _buildRecentActivity(ThemeData theme) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, notifState) {
        if (notifState.isLoading && notifState.notifications.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final notifications = notifState.notifications.take(5).toList();

        if (notifications.isEmpty) {
          return Container(
            padding: AppPadding.padSV16,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.notifications_none,
                      size: 40,
                      color: AppColors.romanSilver.withValues(alpha: 0.5)),
                  Space.h8,
                  Text(
                    'No recent activity',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.romanSilver,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          padding: AppPadding.padSV16,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < notifications.length; i++) ...[
                if (i > 0) ...[
                  Space.h16,
                  const Divider(height: 24, color: AppColors.gainsboro),
                ],
                _buildActivityItem(
                  notifications[i],
                  theme,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityItem(
      NotificationResponse notification, ThemeData theme) {
    final color = _getNotificationColor(notification.notificationType);
    final icon = _getNotificationIcon(notification.notificationType);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppPadding.padA8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        Space.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.chineseBlack,
                ),
              ),
              Space.h4,
              Text(
                notification.body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.darkElectricBlue,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          notification.timeAgo,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.romanSilver,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.chineseBlack,
      ),
    );
  }
}
