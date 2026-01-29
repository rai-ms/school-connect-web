import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../manager/profile_management_bloc/profile_management_bloc.dart';
import 'bloc/school_admin_dashboard_bloc/school_admin_dashboard_bloc.dart';

class SchoolAdminDashboard extends StatefulWidget {
  const SchoolAdminDashboard({super.key, required this.profileState});
  final ProfileManageState profileState;

  @override
  State<SchoolAdminDashboard> createState() => _SchoolAdminDashboardState();
}

class _SchoolAdminDashboardState extends State<SchoolAdminDashboard> {
  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.school,
      'label': 'Students',
      'color': AppColors.blueColor,
      'route': RoutesName.studentList,
    },
    {
      'icon': Icons.group,
      'label': 'Teachers',
      'color': AppColors.greenCyan,
      'route': RoutesName.teacherList,
    },
    {
      'icon': Icons.family_restroom,
      'label': 'Parents',
      'color': AppColors.safetyOrange,
      'route': RoutesName.parentList,
    },
    {
      'icon': Icons.class_,
      'label': 'Classes',
      'color': AppColors.selectiveYellow,
      'route': RoutesName.classList,
    },
    {
      'icon': Icons.menu_book,
      'label': 'Subjects',
      'color': AppColors.verdigris,
      'route': RoutesName.subjectList,
    },
    {
      'icon': Icons.assessment,
      'label': 'Reports',
      'color': AppColors.kuCrimson,
      'route': RoutesName.reports,
    },
    {
      'icon': Icons.payment,
      'label': 'Fees',
      'color': AppColors.myrtleGreen,
      'route': RoutesName.feeDashboard,
    },
    {
      'icon': Icons.event_busy,
      'label': 'Leave',
      'color': AppColors.purple,
      'route': RoutesName.leaveHistory,
    },
    {
      'icon': Icons.assignment,
      'label': 'Assignments',
      'color': AppColors.safetyLightBlue,
      'route': RoutesName.assignmentList,
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Calendar',
      'color': AppColors.safetyBlue,
      'route': RoutesName.calendarHome,
    },
    {
      'icon': Icons.security,
      'label': 'Safety',
      'color': AppColors.safetyOrange,
      'route': RoutesName.safetyHome,
    },
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'color': AppColors.romanSilver,
      'route': RoutesName.settings,
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<SchoolAdminDashboardBloc>().add(RefreshDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final profile = widget.profileState.profile;

    return BlocListener<ProfileManageBloc, ProfileManageState>(
      listener: (context, state) {
        if (state.isTokenNotFound) {
          context.goNamed(RoutesName.loginScreen);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.ghostWhite,
        body: BlocBuilder<SchoolAdminDashboardBloc,
            SchoolAdminDashboardState>(
          builder: (context, dashState) {
            final stats = dashState.tenantStats;
            final feeReport = dashState.feeReport;

            return CustomScrollView(
              slivers: [
                // App Bar with School Info
                SliverAppBar(
                  expandedHeight: size.height * 0.18,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.darkGunMetal,
                            AppColors.myrtleGreen,
                          ],
                        ),
                      ),
                      padding: AppPadding.padSH24
                          .copyWith(top: 16.v, bottom: 16.v),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  GlassyBackground(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'School Admin',
                                      style:
                                          AppStyles.semiMedium.medium.white,
                                    ),
                                  ),
                                  Space.h8,
                                  Text(
                                    '${L!.welcomeBack}, ${profile?.firstName ?? "Admin"}',
                                    style: AppStyles.large28.medium.white,
                                  ),
                                  Space.h4,
                                  Text(
                                    'School Management System',
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: AppColors.whiteColor
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<ProfileManageBloc>()
                                    .add(LogOutEvent());
                              },
                              child: GlassyBackground(
                                child: Icon(
                                  FontAwesomeIcons
                                      .arrowRightFromBracket,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppPadding.padA16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Stats
                        _buildQuickStats(theme, stats),
                        Space.h24,

                        // Today's Attendance Overview
                        _buildSectionHeader('Overview', theme),
                        Space.h12,
                        _buildOverviewCards(theme, stats, feeReport,
                            dashState.pendingLeaveCount),
                        Space.h24,

                        // Quick Actions
                        _buildSectionHeader('Quick Actions', theme),
                        Space.h12,
                        _buildQuickActions(theme),
                        Space.h24,

                        // Fee Summary
                        if (feeReport != null) ...[
                          _buildSectionHeader(
                              'Fee Collection', theme,
                              onViewAll: () => context
                                  .push(RoutesName.feeDashboard)),
                          Space.h12,
                          _buildFeeOverview(theme, feeReport),
                          Space.h24,
                        ],

                        // Quick Links
                        _buildSectionHeader('Management', theme),
                        Space.h12,
                        _buildManagementLinks(theme),
                        Space.h24,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme, dynamic stats) {
    final totalStudents = stats?.totalStudents ?? 0;
    final totalTeachers = stats?.totalTeachers ?? 0;
    final totalClasses = stats?.totalClasses ?? 0;
    final attendanceRate = stats?.attendancePercentage ?? 0.0;

    return GlassyBackground(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '$totalStudents',
            'Students',
            Icons.school,
            AppColors.blueColor,
          ),
          _buildStatItem(
            '$totalTeachers',
            'Teachers',
            Icons.person,
            AppColors.greenCyan,
          ),
          _buildStatItem(
            '$totalClasses',
            'Classes',
            Icons.class_,
            AppColors.purple,
          ),
          _buildStatItem(
            '${attendanceRate.toStringAsFixed(1)}%',
            'Attendance',
            Icons.pie_chart,
            AppColors.selectiveYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: AppPadding.padA8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        Space.h8,
        Text(
          value,
          style:
              AppStyles.medium.bold.copyWith(color: AppColors.whiteColor),
        ),
        Text(
          label,
          style: AppStyles.small.regular.copyWith(
            color: AppColors.whiteColor.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCards(ThemeData theme, dynamic stats,
      dynamic feeReport, int pendingLeaves) {
    final totalStudents = stats?.totalStudents ?? 0;
    final attendanceRate = stats?.attendancePercentage ?? 0.0;
    final presentEstimate =
        (totalStudents * attendanceRate / 100).round();
    final absentEstimate = totalStudents - presentEstimate;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Present Today',
                '$presentEstimate',
                AppColors.greenCyan,
                Icons.check_circle,
              ),
            ),
            Space.w12,
            Expanded(
              child: _buildOverviewCard(
                'Absent Today',
                '$absentEstimate',
                AppColors.kuCrimson,
                Icons.cancel,
              ),
            ),
          ],
        ),
        Space.h12,
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Pending Leaves',
                '$pendingLeaves',
                AppColors.safetyOrange,
                Icons.event_busy,
              ),
            ),
            Space.w12,
            Expanded(
              child: _buildOverviewCard(
                'Overdue Fees',
                '${feeReport?.overdueCount ?? 0}',
                AppColors.safetyLightRed,
                Icons.warning_amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return GlassyBackground(
      child: Row(
        children: [
          Container(
            padding: AppPadding.padA8,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Space.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppStyles.large.bold.copyWith(color: color),
                ),
                Text(
                  label,
                  style: AppStyles.small.regular.copyWith(
                    color:
                        AppColors.whiteColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _quickActions.map((action) {
        return _buildActionItem(
          action['icon'] as IconData,
          action['label'] as String,
          action['color'] as Color,
          theme,
          onTap: () {
            final route = action['route'] as String?;
            if (route != null) {
              context.push(route);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color,
    ThemeData theme, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: AppPadding.padA12,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppPadding.padA10,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Space.h8,
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.darkElectricBlue,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeOverview(ThemeData theme, dynamic feeReport) {
    final collected = feeReport.totalCollected as double;
    final pending = feeReport.totalPending as double;
    final total = collected + pending;
    final collectionPercent =
        total > 0 ? (collected / total * 100) : 0.0;

    return GlassyBackground(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Collected',
                      style: AppStyles.small.regular.greyColor),
                  Space.h4,
                  Text(
                    _formatCurrency(collected),
                    style: AppStyles.medium.bold
                        .copyWith(color: AppColors.greenCyan),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Pending',
                      style: AppStyles.small.regular.greyColor),
                  Space.h4,
                  Text(
                    _formatCurrency(pending),
                    style: AppStyles.medium.bold
                        .copyWith(color: AppColors.safetyOrange),
                  ),
                ],
              ),
            ],
          ),
          Space.h12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Collection Rate',
                      style: AppStyles.small.medium.white),
                  Text(
                    '${collectionPercent.toStringAsFixed(1)}%',
                    style: AppStyles.small.bold
                        .copyWith(color: AppColors.greenCyan),
                  ),
                ],
              ),
              Space.h8,
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? collected / total : 0,
                  backgroundColor:
                      AppColors.whiteColor.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(
                      AppColors.greenCyan),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementLinks(ThemeData theme) {
    final links = [
      {
        'icon': Icons.how_to_reg,
        'label': 'Mark Attendance',
        'subtitle': 'Select a class to mark',
        'color': AppColors.greenCyan,
        'route': RoutesName.classList,
      },
      {
        'icon': Icons.person_add,
        'label': 'Add Student',
        'subtitle': 'Enroll a new student',
        'color': AppColors.blueColor,
        'route': RoutesName.addStudent,
      },
      {
        'icon': Icons.group_add,
        'label': 'Add Teacher',
        'subtitle': 'Register a new teacher',
        'color': AppColors.purple,
        'route': RoutesName.addTeacher,
      },
      {
        'icon': Icons.approval,
        'label': 'Leave Approvals',
        'subtitle': 'Review pending requests',
        'color': AppColors.safetyOrange,
        'route': RoutesName.leaveApprovals,
      },
    ];

    return GlassyBackground(
      child: Column(
        children: links.asMap().entries.map((entry) {
          final index = entry.key;
          final link = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: () =>
                    context.push(link['route'] as String),
                child: Row(
                  children: [
                    Container(
                      padding: AppPadding.padA10,
                      decoration: BoxDecoration(
                        color: (link['color'] as Color)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        link['icon'] as IconData,
                        color: link['color'] as Color,
                        size: 24,
                      ),
                    ),
                    Space.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            link['label'] as String,
                            style: AppStyles.medium.medium.white,
                          ),
                          Space.h4,
                          Text(
                            link['subtitle'] as String,
                            style:
                                AppStyles.small.regular.copyWith(
                              color: AppColors.whiteColor
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.whiteColor
                          .withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              if (index < links.length - 1) ...[
                Space.h12,
                Divider(
                  color:
                      AppColors.whiteColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Space.h12,
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme,
      {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.chineseBlack,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '\u20B9${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '\u20B9${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\u20B9${amount.toStringAsFixed(0)}';
  }
}
