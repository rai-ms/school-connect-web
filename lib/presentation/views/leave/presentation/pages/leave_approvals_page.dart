import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/leave_request_model.dart';
import '../manager/leave_bloc/leave_bloc.dart';

class LeaveApprovalsPage extends StatefulWidget {
  const LeaveApprovalsPage({super.key});

  @override
  State<LeaveApprovalsPage> createState() => _LeaveApprovalsPageState();
}

class _LeaveApprovalsPageState extends State<LeaveApprovalsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<LeaveBloc>().add(const FetchPendingApprovals());
    context.read<LeaveBloc>().add(const FetchAllLeaveRequests());
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
        title: Text('Leave Approvals', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.safetyBlue,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.greyColor,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'All Requests'),
          ],
        ),
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state.actionCompleted &&
              (state.event is ApproveLeave || state.event is RejectLeave)) {
            final action =
                state.event is ApproveLeave ? 'approved' : 'rejected';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Leave $action successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildPendingTab(state),
              _buildAllRequestsTab(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPendingTab(LeaveState state) {
    if (state.isLoading && state.pendingApprovals.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.safetyBlue),
      );
    }

    if (state.pendingApprovals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64,
                color: AppColors.safetyGreen.withValues(alpha: 0.5)),
            Space.h16,
            Text('No pending approvals',
                style: AppStyles.medium.regular.greyColor),
            Space.h4,
            Text('All caught up!',
                style: AppStyles.small.regular
                    .colored(AppColors.safetyGreen)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeaveBloc>().add(const FetchPendingApprovals());
      },
      child: ListView.builder(
        padding: AppPadding.padA16,
        itemCount: state.pendingApprovals.length,
        itemBuilder: (context, index) =>
            _buildPendingCard(state.pendingApprovals[index]),
      ),
    );
  }

  Widget _buildAllRequestsTab(LeaveState state) {
    if (state.isLoading && state.allRequests.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.safetyBlue),
      );
    }

    if (state.allRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox,
                size: 64,
                color: AppColors.greyColor.withValues(alpha: 0.5)),
            Space.h16,
            Text('No leave requests',
                style: AppStyles.medium.regular.greyColor),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeaveBloc>().add(const FetchAllLeaveRequests());
      },
      child: ListView.builder(
        padding: AppPadding.padA16,
        itemCount: state.allRequests.length,
        itemBuilder: (context, index) =>
            _buildRequestCard(state.allRequests[index]),
      ),
    );
  }

  Widget _buildPendingCard(LeaveRequestResponse leave) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassyBackground(
        borderColor:
            AppColors.selectiveYellow.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      AppColors.safetyBlue.withValues(alpha: 0.15),
                  child: Text(
                    (leave.userName ?? 'U')[0].toUpperCase(),
                    style: AppStyles.semiMedium.bold
                        .colored(AppColors.safetyBlue),
                  ),
                ),
                Space.w8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(leave.userName ?? 'Unknown',
                          style: AppStyles.semiMedium.semiBold.white),
                      if (leave.userRole != null)
                        Text(leave.userRole!,
                            style: AppStyles.extraSmall.regular.greyColor),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.safetyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    leave.leaveTypeName ?? 'Leave',
                    style: AppStyles.extraSmall.bold
                        .colored(AppColors.safetyBlue),
                  ),
                ),
              ],
            ),
            Space.h12,

            // Date & Duration
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
            Space.h8,

            // Reason
            Text(leave.reason,
                style: AppStyles.small.regular.greyColor,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            Space.h12,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRemarksDialog(leave.id, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.safetyLightRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Reject',
                        style: AppStyles.small.semiBold
                            .colored(AppColors.safetyLightRed)),
                  ),
                ),
                Space.w12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRemarksDialog(leave.id, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Approve',
                        style: AppStyles.small.bold.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(LeaveRequestResponse leave) {
    final statusColor = _getStatusColor(leave.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassyBackground(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  AppColors.safetyBlue.withValues(alpha: 0.15),
              child: Text(
                (leave.userName ?? 'U')[0].toUpperCase(),
                style: AppStyles.small.bold
                    .colored(AppColors.safetyBlue),
              ),
            ),
            Space.w8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(leave.userName ?? 'Unknown',
                            style: AppStyles.semiMedium.semiBold.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(leave.statusLabel,
                            style: AppStyles.extraSmall.bold
                                .colored(statusColor)),
                      ),
                    ],
                  ),
                  Space.h4,
                  Text(
                    '${leave.leaveTypeName ?? "Leave"} - ${leave.dateRange}',
                    style: AppStyles.small.regular.greyColor,
                  ),
                  Space.h4,
                  Text(
                    '${leave.totalDays} day(s) - ${leave.reason}',
                    style: AppStyles.extraSmall.regular.greyColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemarksDialog(String leaveId, bool isApprove) {
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3A),
        title: Text(
          isApprove ? 'Approve Leave' : 'Reject Leave',
          style: AppStyles.medium.bold.white,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isApprove
                  ? 'Add remarks (optional):'
                  : 'Add reason for rejection:',
              style: AppStyles.small.regular.greyColor,
            ),
            Space.h8,
            TextField(
              controller: remarksController,
              style: AppStyles.small.regular.white,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter remarks...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: AppColors.whiteColor.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: AppColors.whiteColor.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.safetyBlue),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppStyles.small.regular.greyColor),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final remarks = remarksController.text.trim().isNotEmpty
                  ? remarksController.text.trim()
                  : null;
              if (isApprove) {
                context
                    .read<LeaveBloc>()
                    .add(ApproveLeave(leaveId, remarks: remarks));
              } else {
                context
                    .read<LeaveBloc>()
                    .add(RejectLeave(leaveId, remarks: remarks));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove
                  ? AppColors.safetyGreen
                  : AppColors.safetyLightRed,
            ),
            child: Text(
              isApprove ? 'Approve' : 'Reject',
              style: AppStyles.small.bold.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return AppColors.safetyGreen;
      case 'REJECTED':
        return AppColors.safetyLightRed;
      case 'CANCELLED':
        return AppColors.greyColor;
      default:
        return AppColors.selectiveYellow;
    }
  }
}
