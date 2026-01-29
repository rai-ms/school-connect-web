import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/assignment_model.dart';
import '../manager/assignment_bloc/assignment_bloc.dart';

class AssignmentDetailPage extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailPage({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final bloc = context.read<AssignmentBloc>();
    bloc.add(FetchAssignmentById(widget.assignmentId));
    bloc.add(FetchSubmissions(widget.assignmentId));
    bloc.add(FetchAssignmentStatistics(widget.assignmentId));
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
        title: Text('Assignment Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.whiteColor),
            color: AppColors.darkGunMetal,
            onSelected: (value) {
              if (value == 'edit') {
                context.push(
                  RoutesName.createAssignment,
                  extra: widget.assignmentId,
                );
              } else if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit', style: AppStyles.medium.regular.white),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete',
                    style: AppStyles.medium.regular
                        .copyWith(color: AppColors.safetyRed)),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state.isSuccess && state.actionCompleted) {
            if (state.event is DeleteAssignment) {
              context.pop();
            }
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.event is FetchAssignmentById) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final assignment = state.selectedAssignment;
          if (assignment == null) {
            return Center(
              child: Text('Assignment not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return Column(
            children: [
              // Assignment Info Header
              Padding(
                padding: AppPadding.padA16,
                child: GlassyBackground(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              assignment.title,
                              style: AppStyles.large.bold.white,
                            ),
                          ),
                          _buildStatusChip(assignment.status),
                        ],
                      ),
                      Space.h12,
                      if (assignment.description != null &&
                          assignment.description!.isNotEmpty) ...[
                        Text(
                          assignment.description!,
                          style: AppStyles.medium.regular.copyWith(
                            color:
                                AppColors.whiteColor.withValues(alpha: 0.8),
                          ),
                        ),
                        Space.h12,
                      ],
                      _buildInfoRow(Icons.home_work, 'Type',
                          assignment.type, AppColors.safetyBlue),
                      Space.h8,
                      _buildInfoRow(Icons.calendar_today, 'Due Date',
                          assignment.dueDate ?? 'TBD',
                          assignment.isOverdue
                              ? AppColors.safetyRed
                              : AppColors.safetyGreen),
                      Space.h8,
                      _buildInfoRow(Icons.date_range, 'Assigned',
                          assignment.assignedDate ?? 'N/A',
                          AppColors.safetyLightBlue),
                      Space.h8,
                      _buildInfoRow(Icons.grade, 'Max Marks',
                          '${assignment.maxMarks}', AppColors.safetyOrange),
                      if (assignment.attachmentUrl != null) ...[
                        Space.h8,
                        _buildInfoRow(Icons.attach_file, 'Attachment',
                            'View', AppColors.purple),
                      ],
                    ],
                  ),
                ),
              ),
              // Statistics
              if (state.statistics != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStatisticsRow(state.statistics!),
                ),
              Space.h12,
              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.safetyBlue,
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: AppColors.greyColor,
                tabs: const [
                  Tab(text: 'Submissions'),
                  Tab(text: 'Details'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSubmissionsList(state.submissions),
                    _buildDetailsTab(assignment),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        Space.w8,
        Text('$label: ', style: AppStyles.small.medium.greyColor),
        Expanded(
          child: Text(
            value,
            style: AppStyles.small.medium.colored(color),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsRow(AssignmentStatistics stats) {
    return GlassyBackground(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              stats.totalSubmissions.toString(), 'Total', AppColors.safetyBlue),
          _buildStatItem(
              stats.submittedCount.toString(), 'Submitted', AppColors.safetyGreen),
          _buildStatItem(
              stats.gradedCount.toString(), 'Graded', AppColors.safetyOrange),
          _buildStatItem(stats.averageMarks.toStringAsFixed(1), 'Avg',
              AppColors.purple),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: AppStyles.medium.bold.copyWith(color: color)),
        Space.h4,
        Text(label,
            style: AppStyles.extraSmall.regular.copyWith(
              color: AppColors.whiteColor.withValues(alpha: 0.7),
            )),
      ],
    );
  }

  Widget _buildSubmissionsList(List<AssignmentSubmissionResponse> submissions) {
    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64,
                color: AppColors.greyColor.withValues(alpha: 0.5)),
            Space.h16,
            Text('No submissions yet',
                style: AppStyles.medium.regular.greyColor),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppPadding.padA16,
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        final submission = submissions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassyBackground(
            child: InkWell(
              onTap: () {
                if (!submission.isGraded) {
                  context.push(
                    RoutesName.gradeSubmission
                        .replaceFirst(':submissionId', submission.id),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getSubmissionColor(submission.status)
                          .withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getSubmissionIcon(submission.status),
                      color: _getSubmissionColor(submission.status),
                      size: 20,
                    ),
                  ),
                  Space.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student: ${submission.studentId}',
                          style: AppStyles.small.medium.white,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Space.h4,
                        Text(
                          submission.submissionDate != null
                              ? 'Submitted: ${submission.submissionDate!.toString().substring(0, 16)}'
                              : 'Not submitted',
                          style: AppStyles.extraSmall.regular.greyColor,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSubmissionStatusChip(submission.status),
                      if (submission.marksObtained != null) ...[
                        Space.h4,
                        Text(
                          '${submission.marksObtained}',
                          style: AppStyles.small.bold
                              .copyWith(color: AppColors.safetyGreen),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab(AssignmentResponse assignment) {
    return SingleChildScrollView(
      padding: AppPadding.padA16,
      child: GlassyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assignment Information',
                style: AppStyles.medium.bold.white),
            Space.h16,
            _buildDetailRow('Title', assignment.title),
            _buildDetailRow(
                'Description', assignment.description ?? 'No description'),
            _buildDetailRow('Type', assignment.type),
            _buildDetailRow('Status', assignment.status),
            _buildDetailRow('Max Marks', '${assignment.maxMarks}'),
            _buildDetailRow('Due Date', assignment.dueDate ?? 'TBD'),
            _buildDetailRow(
                'Assigned Date', assignment.assignedDate ?? 'N/A'),
            _buildDetailRow('Class ID', assignment.classId ?? 'N/A'),
            _buildDetailRow('Teacher ID', assignment.teacherId ?? 'N/A'),
            if (assignment.subjectId != null)
              _buildDetailRow('Subject ID', assignment.subjectId!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppStyles.small.medium.greyColor),
          ),
          Expanded(
            child: Text(value, style: AppStyles.small.regular.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'DRAFT':
        color = AppColors.greyColor;
        break;
      case 'PUBLISHED':
        color = AppColors.safetyGreen;
        break;
      case 'CLOSED':
        color = AppColors.safetyRed;
        break;
      default:
        color = AppColors.greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: AppStyles.extraSmall.medium.colored(color),
      ),
    );
  }

  Widget _buildSubmissionStatusChip(String status) {
    Color color = _getSubmissionColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppStyles.extraSmall.medium.colored(color),
      ),
    );
  }

  Color _getSubmissionColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return AppColors.safetyBlue;
      case 'GRADED':
        return AppColors.safetyGreen;
      case 'LATE':
        return AppColors.safetyOrange;
      case 'PENDING':
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getSubmissionIcon(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return Icons.check_circle;
      case 'GRADED':
        return Icons.grade;
      case 'LATE':
        return Icons.timer_off;
      case 'PENDING':
      default:
        return Icons.hourglass_empty;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkGunMetal,
        title: Text('Delete Assignment', style: AppStyles.medium.bold.white),
        content: Text(
          'Are you sure you want to delete this assignment?',
          style: AppStyles.small.regular.copyWith(
            color: AppColors.whiteColor.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppStyles.small.medium.greyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AssignmentBloc>()
                  .add(DeleteAssignment(widget.assignmentId));
            },
            child: Text('Delete',
                style: AppStyles.small.medium
                    .copyWith(color: AppColors.safetyRed)),
          ),
        ],
      ),
    );
  }
}
