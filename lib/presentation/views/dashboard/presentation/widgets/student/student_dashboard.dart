

import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/size_utils.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final List<Map<String, dynamic>> _upcomingClasses = [
    {
      'subject': 'Mathematics',
      'time': '09:00 - 10:30 AM',
      'room': 'Room 101',
      'teacher': 'Mr. Smith',
      'color': AppColors.selectiveYellow,
    },
    {
      'subject': 'Science',
      'time': '11:00 - 12:30 PM',
      'room': 'Lab 2',
      'teacher': 'Dr. Johnson',
      'color': AppColors.greenCyan,
    },
    {
      'subject': 'English',
      'time': '02:00 - 03:30 PM',
      'room': 'Room 205',
      'teacher': 'Ms. Williams',
      'color': AppColors.kuCrimson,
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.assignment, 'label': 'Assignments', 'color': AppColors.greenCyan},
    {'icon': Icons.calendar_today, 'label': 'Schedule', 'color': AppColors.kuCrimson},
    {'icon': Icons.school, 'label': 'Courses', 'color': AppColors.selectiveYellow},
    {'icon': Icons.assessment, 'label': 'Grades', 'color': AppColors.myrtleGreen},
  ];

  Future<void> _handleRefresh() async {
    // Implement refresh logic here
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                  padding: AppPadding.padSH16.copyWith(top: 12.v, bottom: 12.v),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${L!.welcomeBack},',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Space.h4,
                        Text(
                          'Here\'s your dashboard',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.whiteColor.withValues(alpha: 0.9),
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
                    _buildSectionHeader('Upcoming Classes', theme),
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
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '95%',
            'Attendance',
            Icons.calendar_today,
            AppColors.greenCyan,
            theme,
          ),
          _buildStatItem(
            'A-',
            'GPA',
            Icons.school,
            AppColors.selectiveYellow,
            theme,
          ),
          _buildStatItem(
            '3',
            'Assignments Due',
            Icons.assignment,
            AppColors.kuCrimson,
            theme,
          ),
        ],
      ),
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

  Widget _buildUpcomingClasses(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      padding: AppPadding.padSV8,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _upcomingClasses.length,
      separatorBuilder: (_, __) => Space.h12,
      itemBuilder: (context, index) {
        final classInfo = _upcomingClasses[index];
        return _buildClassCard(classInfo, theme);
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo, ThemeData theme) {
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
              color: classInfo['color'] as Color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Space.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classInfo['subject'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.chineseBlack,
                  ),
                ),
                Space.h4,
                Text(
                  classInfo['time'],
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
                classInfo['room'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkElectricBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Space.h4,
              Text(
                classInfo['teacher'],
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

  Widget _buildQuickActions(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      padding: AppPadding.padSV8,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _quickActions.length,
      itemBuilder: (context, index) {
        final action = _quickActions[index];
        return _buildActionItem(
          action['icon'] as IconData,
          action['label'] as String,
          action['color'] as Color,
          theme,
        );
      },
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, ThemeData theme) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
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

  Widget _buildRecentActivity(ThemeData theme) {
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
          _buildActivityItem(
            'Math Assignment Graded',
            'Your Linear Algebra assignment has been graded A',
            '2 hours ago',
            Icons.assignment_turned_in,
            AppColors.greenCyan,
            theme,
          ),
          Space.h16,
          const Divider(height: 24, color: AppColors.gainsboro),
          _buildActivityItem(
            'New Assignment',
            'New Physics assignment due in 3 days',
            '5 hours ago',
            Icons.assignment,
            AppColors.selectiveYellow,
            theme,
          ),
          Space.h16,
          const Divider(height: 24, color: AppColors.gainsboro),
          _buildActivityItem(
            'Class Cancelled',
            'English class cancelled tomorrow',
            '1 day ago',
            Icons.cancel,
            AppColors.kuCrimson,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time,
      IconData icon, Color color, ThemeData theme) {
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
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.chineseBlack,
                ),
              ),
              Space.h4,
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.darkElectricBlue,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
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
