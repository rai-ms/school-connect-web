import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/exam_result_model.dart';
import '../manager/exam_bloc/exam_bloc.dart';

class ReportCardPage extends StatefulWidget {
  final String studentId;

  const ReportCardPage({super.key, required this.studentId});

  @override
  State<ReportCardPage> createState() => _ReportCardPageState();
}

class _ReportCardPageState extends State<ReportCardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(FetchReportCard(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Report Card', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state.isLoading && state.reportCard == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final reportCard = state.reportCard;
          if (reportCard == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined,
                      size: 64,
                      color: AppColors.greyColor.withValues(alpha: 0.5)),
                  Space.h16,
                  Text('No report card available',
                      style: AppStyles.medium.regular.greyColor),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ExamBloc>()
                  .add(FetchReportCard(widget.studentId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPadding.padA16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Performance Card
                  _buildOverallPerformanceCard(reportCard),
                  Space.h20,

                  // Summary Stats
                  _buildSummaryRow(reportCard),
                  Space.h20,

                  // Subject-wise Results
                  Text('Subject-wise Results',
                      style: AppStyles.medium.semiBold.white),
                  Space.h12,
                  if (reportCard.results.isEmpty)
                    GlassyBackground(
                      child: Center(
                        child: Padding(
                          padding: AppPadding.padSV16,
                          child: Text('No exam results yet',
                              style: AppStyles.small.regular.greyColor),
                        ),
                      ),
                    )
                  else
                    ...reportCard.results
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

  Widget _buildOverallPerformanceCard(ReportCard reportCard) {
    final Color gradeColor = _getGradeColor(reportCard.overallGrade);

    return GlassyBackground(
      child: Column(
        children: [
          Row(
            children: [
              // Grade Circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      gradeColor.withValues(alpha: 0.3),
                      gradeColor.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(color: gradeColor, width: 2),
                ),
                child: Center(
                  child: Text(reportCard.overallGrade,
                      style: AppStyles.large28.bold.colored(gradeColor)),
                ),
              ),
              Space.w20,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overall Performance',
                        style: AppStyles.medium.semiBold.white),
                    Space.h4,
                    Text(
                      '${reportCard.overallPercentage.toStringAsFixed(1)}%',
                      style: AppStyles.large24.bold.colored(gradeColor),
                    ),
                    Space.h4,
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: reportCard.overallPercentage / 100,
                        backgroundColor:
                            AppColors.greyColor.withValues(alpha: 0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(gradeColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ReportCard reportCard) {
    return Row(
      children: [
        _buildSummaryCard(
          icon: Icons.assignment,
          label: 'Total Exams',
          value: '${reportCard.totalExams}',
          color: AppColors.safetyBlue,
        ),
        Space.w12,
        _buildSummaryCard(
          icon: Icons.check_circle,
          label: 'Exams Taken',
          value: '${reportCard.examsTaken}',
          color: AppColors.safetyGreen,
        ),
        Space.w12,
        _buildSummaryCard(
          icon: Icons.event_busy,
          label: 'Absent',
          value: '${reportCard.totalExams - reportCard.examsTaken}',
          color: AppColors.safetyRed,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: GlassyBackground(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            Space.h8,
            Text(value, style: AppStyles.larger.bold.colored(color)),
            Space.h4,
            Text(label,
                style: AppStyles.extraSmall.regular.greyColor,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ExamResultResponse result) {
    final Color statusColor = result.isPassed
        ? AppColors.safetyGreen
        : result.isFailed
            ? AppColors.safetyRed
            : AppColors.greyColor;
    final percentage = result.percentage ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.subjectName ?? result.examName ?? 'Exam',
                        style: AppStyles.semiMedium.semiBold.white,
                      ),
                      if (result.examName != null &&
                          result.subjectName != null)
                        Text(result.examName!,
                            style: AppStyles.extraSmall.regular.greyColor),
                    ],
                  ),
                ),
                if (result.isAbsent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.safetyRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('ABSENT',
                        style: AppStyles.extraSmall.bold
                            .colored(AppColors.safetyRed)),
                  )
                else if (result.grade != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: statusColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(result.grade!,
                        style: AppStyles.small.bold.colored(statusColor)),
                  ),
              ],
            ),
            if (!result.isAbsent) ...[
              Space.h8,
              Row(
                children: [
                  Text(
                    'Marks: ${result.marksObtained.toStringAsFixed(0)}/${result.maxMarks}',
                    style: AppStyles.small.regular.white,
                  ),
                  const Spacer(),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: AppStyles.small.semiBold.colored(statusColor),
                  ),
                ],
              ),
              Space.h6,
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor:
                      AppColors.greyColor.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 4,
                ),
              ),
            ],
            if (result.remarks != null) ...[
              Space.h6,
              Text(result.remarks!,
                  style: AppStyles.extraSmall.regular.greyColor),
            ],
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.safetyGreen;
      case 'B+':
      case 'B':
        return AppColors.safetyBlue;
      case 'C':
        return AppColors.safetyOrange;
      case 'D':
      case 'E':
        return AppColors.selectiveYellow;
      case 'F':
        return AppColors.safetyRed;
      default:
        return AppColors.greyColor;
    }
  }
}
