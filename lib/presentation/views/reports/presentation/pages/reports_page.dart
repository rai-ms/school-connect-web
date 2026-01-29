import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../../dashboard/presentation/widgets/school_admin/bloc/school_admin_dashboard_bloc/school_admin_dashboard_bloc.dart';
import '../../../fee/data/models/fee_payment_model.dart';
import '../../../dashboard/data/models/res/school_admin/dashboard_stats_model.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<SchoolAdminDashboardBloc>().add(RefreshDashboard());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Reports', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.safetyBlue,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.greyColor,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Attendance'),
            Tab(text: 'Fees'),
          ],
        ),
      ),
      body: BlocBuilder<SchoolAdminDashboardBloc,
          SchoolAdminDashboardState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.tenantStats == null &&
              state.feeReport == null) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.safetyBlue),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(state),
              _buildAttendanceTab(state),
              _buildFeesTab(state),
            ],
          );
        },
      ),
    );
  }

  // ===== Overview Tab =====
  Widget _buildOverviewTab(SchoolAdminDashboardState state) {
    final stats = state.tenantStats;

    return ListView(
      padding: AppPadding.padA16,
      children: [
        // School Summary
        _buildSectionTitle('School Summary'),
        Space.h8,
        _buildSchoolSummaryCard(stats),

        Space.h20,

        // Quick Navigation
        _buildSectionTitle('Detailed Reports'),
        Space.h8,
        _buildReportLinkCard(
          'Student Reports',
          'View student-wise details, enrollment stats',
          Icons.school,
          AppColors.blueColor,
          () => context.push(RoutesName.studentList),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Teacher Reports',
          'View teacher-wise details, department stats',
          Icons.person,
          AppColors.greenCyan,
          () => context.push(RoutesName.teacherList),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Exam Results',
          'View exam-wise results and statistics',
          Icons.quiz,
          AppColors.purple,
          () => context.push(RoutesName.examList),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Fee Collection',
          'View detailed fee collection reports',
          Icons.payment,
          AppColors.myrtleGreen,
          () => context.push(RoutesName.feeDashboard),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Leave Summary',
          'View leave requests and approvals',
          Icons.event_busy,
          AppColors.safetyOrange,
          () => context.push(RoutesName.leaveHistory),
        ),
        Space.h20,
      ],
    );
  }

  Widget _buildSchoolSummaryCard(TenantStatistics? stats) {
    return GlassyBackground(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Students',
                  '${stats?.totalStudents ?? 0}',
                  Icons.school,
                  AppColors.blueColor,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Teachers',
                  '${stats?.totalTeachers ?? 0}',
                  Icons.person,
                  AppColors.greenCyan,
                ),
              ),
            ],
          ),
          Space.h16,
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Classes',
                  '${stats?.totalClasses ?? 0}',
                  Icons.class_,
                  AppColors.purple,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Active Users',
                  '${stats?.activeUsers ?? 0}',
                  Icons.people,
                  AppColors.selectiveYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: AppPadding.padA8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        Space.w8,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppStyles.medium.bold.white),
            Text(label, style: AppStyles.extraSmall.regular.greyColor),
          ],
        ),
      ],
    );
  }

  Widget _buildReportLinkCard(String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassyBackground(
        child: Row(
          children: [
            Container(
              padding: AppPadding.padA10,
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
                  Text(title,
                      style: AppStyles.semiMedium.semiBold.white),
                  Space.h4,
                  Text(subtitle,
                      style: AppStyles.small.regular.greyColor),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.greyColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  // ===== Attendance Tab =====
  Widget _buildAttendanceTab(SchoolAdminDashboardState state) {
    final stats = state.tenantStats;
    final attendanceRate = stats?.attendancePercentage ?? 0.0;
    final totalStudents = stats?.totalStudents ?? 0;
    final presentEstimate =
        (totalStudents * attendanceRate / 100).round();
    final absentEstimate = totalStudents - presentEstimate;

    return ListView(
      padding: AppPadding.padA16,
      children: [
        // Attendance Rate Circle
        _buildSectionTitle('Attendance Rate'),
        Space.h8,
        GlassyBackground(
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: attendanceRate / 100,
                        strokeWidth: 10,
                        backgroundColor:
                            AppColors.whiteColor.withValues(alpha: 0.1),
                        color: _getAttendanceColor(attendanceRate),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${attendanceRate.toStringAsFixed(1)}%',
                          style: AppStyles.large.bold.colored(
                              _getAttendanceColor(attendanceRate)),
                        ),
                        Text('Overall',
                            style:
                                AppStyles.extraSmall.regular.greyColor),
                      ],
                    ),
                  ],
                ),
              ),
              Space.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttendanceStat(
                      'Total', '$totalStudents', AppColors.safetyBlue),
                  _buildAttendanceStat(
                      'Present', '$presentEstimate', AppColors.safetyGreen),
                  _buildAttendanceStat(
                      'Absent', '$absentEstimate', AppColors.safetyLightRed),
                ],
              ),
            ],
          ),
        ),

        Space.h20,

        // Students by Class distribution
        if (stats?.studentsByClass.isNotEmpty == true) ...[
          _buildSectionTitle('Students by Class'),
          Space.h8,
          GlassyBackground(
            child: Column(
              children: stats!.studentsByClass.entries.map((entry) {
                final maxCount = stats.studentsByClass.values
                    .fold(0, (a, b) => a > b ? a : b);
                final ratio =
                    maxCount > 0 ? entry.value / maxCount : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style:
                                  AppStyles.small.semiBold.white),
                          Text('${entry.value}',
                              style: AppStyles
                                  .small.bold.colored(AppColors.safetyBlue)),
                        ],
                      ),
                      Space.h4,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: AppColors.whiteColor
                              .withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.safetyBlue),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        Space.h20,

        // Pending Leaves
        GlassyBackground(
          child: Row(
            children: [
              Container(
                padding: AppPadding.padA10,
                decoration: BoxDecoration(
                  color: AppColors.safetyOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.event_busy,
                    color: AppColors.safetyOrange, size: 24),
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending Leave Requests',
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Text(
                        '${state.pendingLeaveCount} requests awaiting approval',
                        style: AppStyles.small.regular.greyColor),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.push(RoutesName.leaveApprovals),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.safetyOrange
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Review',
                      style: AppStyles.small.bold
                          .colored(AppColors.safetyOrange)),
                ),
              ),
            ],
          ),
        ),
        Space.h20,
      ],
    );
  }

  Widget _buildAttendanceStat(
      String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: AppStyles.medium.bold.colored(color)),
        Space.h4,
        Text(label, style: AppStyles.extraSmall.regular.greyColor),
      ],
    );
  }

  Color _getAttendanceColor(double rate) {
    if (rate >= 75) return AppColors.safetyGreen;
    if (rate >= 50) return AppColors.safetyOrange;
    return AppColors.safetyLightRed;
  }

  // ===== Fees Tab =====
  Widget _buildFeesTab(SchoolAdminDashboardState state) {
    final feeReport = state.feeReport;

    return ListView(
      padding: AppPadding.padA16,
      children: [
        // Collection Summary
        _buildSectionTitle('Collection Summary'),
        Space.h8,
        _buildCollectionSummary(feeReport),

        Space.h20,

        // Collection Progress
        _buildSectionTitle('Collection Progress'),
        Space.h8,
        _buildCollectionProgress(feeReport),

        Space.h20,

        // Quick Links
        _buildSectionTitle('Actions'),
        Space.h8,
        _buildReportLinkCard(
          'Collect Fee',
          'Record a new fee payment',
          Icons.add_circle,
          AppColors.safetyGreen,
          () => context.push(RoutesName.collectFee),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Pending Fees',
          'View all pending and overdue fees',
          Icons.pending_actions,
          AppColors.safetyOrange,
          () => context.push(RoutesName.pendingFees),
        ),
        Space.h8,
        _buildReportLinkCard(
          'Fee Dashboard',
          'Full fee management dashboard',
          Icons.dashboard,
          AppColors.safetyBlue,
          () => context.push(RoutesName.feeDashboard),
        ),
        Space.h20,
      ],
    );
  }

  Widget _buildCollectionSummary(CollectionReport? report) {
    return GlassyBackground(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFeeStatCard(
                  'Collected',
                  _formatCurrency(report?.totalCollected ?? 0),
                  AppColors.safetyGreen,
                  Icons.check_circle,
                ),
              ),
              Space.w8,
              Expanded(
                child: _buildFeeStatCard(
                  'Pending',
                  _formatCurrency(report?.totalPending ?? 0),
                  AppColors.safetyOrange,
                  Icons.pending,
                ),
              ),
            ],
          ),
          Space.h12,
          Row(
            children: [
              Expanded(
                child: _buildFeeStatCard(
                  'Monthly',
                  _formatCurrency(report?.monthlyCollection ?? 0),
                  AppColors.safetyBlue,
                  Icons.calendar_month,
                ),
              ),
              Space.w8,
              Expanded(
                child: _buildFeeStatCard(
                  'Overdue',
                  '${report?.overdueCount ?? 0}',
                  AppColors.safetyLightRed,
                  Icons.warning_amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStatCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: AppPadding.padA12,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          Space.h8,
          Text(value,
              style: AppStyles.semiMedium.bold.colored(color)),
          Space.h4,
          Text(label, style: AppStyles.extraSmall.regular.greyColor),
        ],
      ),
    );
  }

  Widget _buildCollectionProgress(CollectionReport? report) {
    final collected = report?.totalCollected ?? 0.0;
    final pending = report?.totalPending ?? 0.0;
    final total = collected + pending;
    final percent = total > 0 ? (collected / total * 100) : 0.0;

    return GlassyBackground(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Collection',
                  style: AppStyles.semiMedium.semiBold.white),
              Text('${percent.toStringAsFixed(1)}%',
                  style: AppStyles.semiMedium.bold
                      .colored(_getCollectionColor(percent))),
            ],
          ),
          Space.h12,
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total > 0 ? collected / total : 0,
              backgroundColor:
                  AppColors.whiteColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(
                  _getCollectionColor(percent)),
              minHeight: 12,
            ),
          ),
          Space.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collected: ${_formatCurrency(collected)}',
                style: AppStyles.small.regular
                    .colored(AppColors.safetyGreen),
              ),
              Text(
                'Total: ${_formatCurrency(total)}',
                style: AppStyles.small.regular.greyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCollectionColor(double percent) {
    if (percent >= 75) return AppColors.safetyGreen;
    if (percent >= 50) return AppColors.safetyOrange;
    return AppColors.safetyLightRed;
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppStyles.semiMedium.bold.white);
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
