import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/exam_result_model.dart';
import '../manager/exam_bloc/exam_bloc.dart';

class ExamDetailsPage extends StatefulWidget {
  final String examId;

  const ExamDetailsPage({super.key, required this.examId});

  @override
  State<ExamDetailsPage> createState() => _ExamDetailsPageState();
}

class _ExamDetailsPageState extends State<ExamDetailsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ExamBloc>();
    bloc.add(FetchExamDetails(widget.examId));
    bloc.add(FetchExamResults(widget.examId));
    bloc.add(FetchExamStatistics(widget.examId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Exam Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(
              RoutesName.markEntry,
              pathParameters: {'examId': widget.examId},
            ),
            icon: const Icon(Icons.edit_note, color: AppColors.safetyBlue),
            tooltip: 'Enter Marks',
          ),
        ],
      ),
      body: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          final exam = state.selectedExam;
          if (state.isLoading && exam == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (exam == null) {
            return Center(
              child: Text('Exam not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ExamBloc>()
                ..add(FetchExamDetails(widget.examId))
                ..add(FetchExamResults(widget.examId))
                ..add(FetchExamStatistics(widget.examId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPadding.padA16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exam Info Card
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exam.name,
                            style: AppStyles.larger.bold.white),
                        Space.h8,
                        if (exam.description != null) ...[
                          Text(exam.description!,
                              style: AppStyles.small.regular.greyColor),
                          Space.h12,
                        ],
                        _buildInfoRow(Icons.calendar_today, 'Date',
                            exam.examDate ?? 'TBD'),
                        if (exam.startTime != null)
                          _buildInfoRow(Icons.access_time, 'Time',
                              '${exam.startTime}${exam.endTime != null ? ' - ${exam.endTime}' : ''}'),
                        _buildInfoRow(
                            Icons.grade, 'Max Marks', '${exam.maxMarks}'),
                        _buildInfoRow(Icons.check_circle_outline,
                            'Passing Marks', '${exam.passingMarks}'),
                        if (exam.room != null)
                          _buildInfoRow(Icons.room, 'Room', exam.room!),
                        if (exam.examType != null)
                          _buildInfoRow(Icons.category, 'Type',
                              exam.examType!.name),
                        if (exam.subjectName != null)
                          _buildInfoRow(
                              Icons.book, 'Subject', exam.subjectName!),
                      ],
                    ),
                  ),
                  Space.h16,

                  // Statistics Card
                  if (state.statistics != null) ...[
                    Text('Statistics',
                        style: AppStyles.medium.semiBold.white),
                    Space.h8,
                    _buildStatisticsCard(state.statistics!),
                    Space.h16,
                  ],

                  // Results List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Results (${state.examResults.length})',
                          style: AppStyles.medium.semiBold.white),
                      TextButton.icon(
                        onPressed: () => context.pushNamed(
                          RoutesName.markEntry,
                          pathParameters: {'examId': widget.examId},
                        ),
                        icon: const Icon(Icons.add,
                            size: 16, color: AppColors.safetyBlue),
                        label: Text('Enter Marks',
                            style: AppStyles.small.medium
                                .colored(AppColors.safetyBlue)),
                      ),
                    ],
                  ),
                  Space.h8,
                  if (state.examResults.isEmpty)
                    GlassyBackground(
                      child: Center(
                        child: Padding(
                          padding: AppPadding.padSV16,
                          child: Text('No results entered yet',
                              style: AppStyles.small.regular.greyColor),
                        ),
                      ),
                    )
                  else
                    ...state.examResults
                        .map((r) => _buildResultCard(r)),
                  Space.h30,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.safetyLightBlue),
          Space.w8,
          Text('$label: ', style: AppStyles.small.medium.greyColor),
          Expanded(
            child: Text(value,
                style: AppStyles.small.regular.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ExamStatistics stats) {
    return GlassyBackground(
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem('Total', '${stats.totalStudents}',
                  AppColors.safetyBlue),
              _buildStatItem(
                  'Passed', '${stats.passed}', AppColors.safetyGreen),
              _buildStatItem(
                  'Failed', '${stats.failed}', AppColors.safetyRed),
            ],
          ),
          Space.h12,
          Row(
            children: [
              _buildStatItem('Average',
                  '${stats.averagePercentage.toStringAsFixed(1)}%',
                  AppColors.safetyOrange),
              _buildStatItem('Pass Rate',
                  '${stats.passPercentage.toStringAsFixed(1)}%',
                  AppColors.safetyGreen),
              if (stats.highestMarks != null)
                _buildStatItem('Highest',
                    stats.highestMarks!.toStringAsFixed(0),
                    AppColors.safetyBlue),
            ],
          ),
          if (stats.topper != null) ...[
            Space.h12,
            Row(
              children: [
                const Icon(Icons.emoji_events,
                    size: 16, color: AppColors.selectiveYellow),
                Space.w8,
                Text('Topper: ',
                    style: AppStyles.small.medium.greyColor),
                Text(stats.topper!,
                    style: AppStyles.small.semiBold
                        .colored(AppColors.selectiveYellow)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: AppStyles.larger.bold.colored(color)),
          Space.h4,
          Text(label, style: AppStyles.extraSmall.regular.greyColor),
        ],
      ),
    );
  }

  Widget _buildResultCard(ExamResultResponse result) {
    final Color statusColor = result.isPassed
        ? AppColors.safetyGreen
        : result.isFailed
            ? AppColors.safetyRed
            : AppColors.greyColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassyBackground(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: statusColor.withValues(alpha: 0.2),
              child: Text(
                result.rank != null ? '#${result.rank}' : '--',
                style: AppStyles.extraSmall.bold.colored(statusColor),
              ),
            ),
            Space.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.studentName ?? 'Student',
                      style: AppStyles.small.semiBold.white),
                  Space.h4,
                  Row(
                    children: [
                      Text(
                        '${result.marksObtained.toStringAsFixed(0)}/${result.maxMarks}',
                        style: AppStyles.extraSmall.regular.greyColor,
                      ),
                      if (result.percentage != null) ...[
                        Space.w8,
                        Text(
                          '${result.percentage!.toStringAsFixed(1)}%',
                          style: AppStyles.extraSmall.medium
                              .colored(statusColor),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (result.grade != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(result.grade!,
                    style: AppStyles.small.bold.colored(statusColor)),
              ),
            if (result.isAbsent)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.safetyRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('ABSENT',
                    style: AppStyles.extraSmall.bold
                        .colored(AppColors.safetyRed)),
              ),
          ],
        ),
      ),
    );
  }
}
