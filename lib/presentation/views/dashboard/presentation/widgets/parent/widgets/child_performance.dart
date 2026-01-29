import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';
import '../../../../../../views/exam/presentation/manager/exam_bloc/exam_bloc.dart';
import '../../../../../../views/exam/data/models/exam_result_model.dart';

class ChildPerformance extends StatelessWidget {
  const ChildPerformance({super.key});

  static const List<Color> _subjectColors = [
    AppColors.blueColor,
    AppColors.greenColor,
    AppColors.safetyOrange,
    AppColors.crayolaRed,
    AppColors.purple,
    AppColors.greenCyan,
    AppColors.selectiveYellow,
    AppColors.kuCrimson,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state.isLoading &&
            state.studentResults.isEmpty &&
            (state.event is FetchStudentResults)) {
          return GlassyBackground(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.isFailed && state.studentResults.isEmpty) {
          return GlassyBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.greyColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Could not load performance data',
                      style: AppStyles.regular.normal.greyColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final results = state.studentResults;

        if (results.isEmpty) {
          return GlassyBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    const Icon(Icons.assessment_outlined,
                        color: AppColors.greyColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No exam results available',
                      style: AppStyles.regular.normal.greyColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Group results by subject and show the latest result per subject
        final subjectResults = _getLatestResultsBySubject(results);

        return GlassyBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Performance',
                style: AppStyles.medium.medium.white,
              ),
              const SizedBox(height: 16),
              ...subjectResults.asMap().entries.map((entry) {
                final index = entry.key;
                final result = entry.value;
                final subjectName =
                    result.subjectName ?? result.examName ?? 'Exam';
                final pct = result.percentage ??
                    (result.maxMarks > 0
                        ? (result.marksObtained / result.maxMarks * 100)
                        : 0.0);
                final progress = (pct / 100.0).clamp(0.0, 1.0);
                final color =
                    _subjectColors[index % _subjectColors.length];

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index < subjectResults.length - 1 ? 12.0 : 0),
                  child: _buildSubjectProgress(
                      subjectName, progress, pct, color),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Groups results by subject and returns the most recent result per subject
  List<ExamResultResponse> _getLatestResultsBySubject(
      List<ExamResultResponse> results) {
    final Map<String, ExamResultResponse> subjectMap = {};
    for (final result in results) {
      final key = result.subjectName ?? result.examName ?? result.id;
      if (!subjectMap.containsKey(key)) {
        subjectMap[key] = result;
      } else {
        // Keep the most recent one
        final existing = subjectMap[key]!;
        if (result.createdAt != null &&
            existing.createdAt != null &&
            result.createdAt!.isAfter(existing.createdAt!)) {
          subjectMap[key] = result;
        }
      }
    }
    return subjectMap.values.toList();
  }

  Widget _buildSubjectProgress(
      String subject, double progress, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                subject,
                style: AppStyles.regular.normal.greyColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }
}
