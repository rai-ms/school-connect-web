import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/leave_balance_model.dart';
import '../../data/models/leave_request_model.dart';
import '../manager/leave_bloc/leave_bloc.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(const FetchMySummary());
    context.read<LeaveBloc>().add(const FetchMyLeaves());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('My Leaves', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/leave/apply'),
        backgroundColor: AppColors.safetyBlue,
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        label: Text('Apply Leave', style: AppStyles.small.bold.white),
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is CancelLeave) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Leave cancelled successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading &&
              state.myLeaves.isEmpty &&
              state.summary == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<LeaveBloc>().add(const FetchMySummary());
              context.read<LeaveBloc>().add(const FetchMyLeaves());
            },
            child: ListView(
              padding: AppPadding.padA16,
              children: [
                // Balance Summary
                if (state.summary != null) _buildSummaryCard(state.summary!),
                Space.h16,

                // Balance Breakdown
                if (state.balances.isNotEmpty) ...[
                  Text('Leave Balance',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  ...state.balances.map(_buildBalanceCard),
                  Space.h20,
                ],

                // Leave History
                Text('Leave History',
                    style: AppStyles.semiMedium.bold.white),
                Space.h8,

                if (state.myLeaves.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.event_available,
                              size: 48,
                              color:
                                  AppColors.greyColor.withValues(alpha: 0.5)),
                          Space.h12,
                          Text('No leave records',
                              style: AppStyles.medium.regular.greyColor),
                        ],
                      ),
                    ),
                  )
                else
                  ...state.myLeaves.map(_buildLeaveCard),
                Space.h30,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(LeaveSummaryResponse summary) {
    return GlassyBackground(
      borderColor: AppColors.safetyBlue.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Leave Summary',
                  style: AppStyles.semiMedium.bold.white),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.safetyBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(summary.academicYear,
                    style: AppStyles.extraSmall.bold
                        .colored(AppColors.safetyBlue)),
              ),
            ],
          ),
          Space.h16,
          Row(
            children: [
              _buildSummaryStat(
                  'Allocated', '${summary.totalAllocated}', AppColors.safetyBlue),
              _buildSummaryStat(
                  'Used', '${summary.totalUsed}', AppColors.safetyOrange),
              _buildSummaryStat(
                  'Pending', '${summary.totalPending}', AppColors.selectiveYellow),
              _buildSummaryStat(
                  'Remaining', '${summary.totalRemaining}', AppColors.safetyGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: AppStyles.large.bold.colored(color)),
          Space.h4,
          Text(label,
              style: AppStyles.extraSmall.regular.greyColor),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(LeaveBalanceResponse balance) {
    final percentage = balance.usagePercentage / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(balance.leaveTypeName ?? 'Leave',
                    style: AppStyles.semiMedium.semiBold.white),
                Text(
                  '${balance.used}/${balance.totalAllocated} used',
                  style: AppStyles.small.regular.greyColor,
                ),
              ],
            ),
            Space.h8,
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage.clamp(0.0, 1.0),
                backgroundColor:
                    AppColors.whiteColor.withValues(alpha: 0.1),
                color: percentage > 0.8
                    ? AppColors.safetyLightRed
                    : percentage > 0.5
                        ? AppColors.safetyOrange
                        : AppColors.safetyGreen,
                minHeight: 6,
              ),
            ),
            Space.h4,
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${balance.remaining} remaining',
                style: AppStyles.extraSmall.regular
                    .colored(AppColors.safetyGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCard(LeaveRequestResponse leave) {
    final statusInfo = _getStatusInfo(leave.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassyBackground(
        borderColor: statusInfo.color.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(leave.leaveTypeName ?? 'Leave',
                      style: AppStyles.semiMedium.semiBold.white),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusInfo.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    leave.statusLabel,
                    style: AppStyles.extraSmall.bold
                        .colored(statusInfo.color),
                  ),
                ),
              ],
            ),
            Space.h8,
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: AppColors.safetyBlue),
                Space.w4,
                Text(leave.dateRange,
                    style: AppStyles.small.regular
                        .colored(AppColors.safetyBlue)),
                Space.w12,
                Icon(Icons.timelapse,
                    size: 14, color: AppColors.greyColor),
                Space.w4,
                Text(
                  leave.isHalfDay
                      ? '0.5 day'
                      : '${leave.totalDays} day(s)',
                  style: AppStyles.small.regular.greyColor,
                ),
              ],
            ),
            Space.h4,
            Text(leave.reason,
                style: AppStyles.small.regular.greyColor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            if (leave.approvalRemarks != null) ...[
              Space.h4,
              Row(
                children: [
                  Icon(Icons.comment,
                      size: 12, color: AppColors.safetyOrange),
                  Space.w4,
                  Expanded(
                    child: Text(leave.approvalRemarks!,
                        style: AppStyles.extraSmall.regular
                            .colored(AppColors.safetyOrange),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
            if (leave.isPending) ...[
              Space.h8,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showCancelDialog(leave.id);
                  },
                  child: Text('Cancel',
                      style: AppStyles.small.semiBold
                          .colored(AppColors.safetyLightRed)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(String leaveId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3A),
        title: Text('Cancel Leave', style: AppStyles.medium.bold.white),
        content: Text('Are you sure you want to cancel this leave request?',
            style: AppStyles.small.regular.greyColor),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No', style: AppStyles.small.regular.greyColor),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<LeaveBloc>().add(CancelLeave(leaveId));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyLightRed),
            child: Text('Yes, Cancel',
                style: AppStyles.small.bold.white),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'APPROVED':
        return _StatusInfo(AppColors.safetyGreen, Icons.check_circle);
      case 'REJECTED':
        return _StatusInfo(AppColors.safetyLightRed, Icons.cancel);
      case 'CANCELLED':
        return _StatusInfo(AppColors.greyColor, Icons.block);
      default:
        return _StatusInfo(AppColors.selectiveYellow, Icons.pending);
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  _StatusInfo(this.color, this.icon);
}
