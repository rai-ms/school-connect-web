import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';
import '../../../../../../views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';

class ChildAttendance extends StatelessWidget {
  const ChildAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state.isLoading && state.percentage == null) {
          return GlassyBackground(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(
                  color: AppColors.greenColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.isFailed && state.percentage == null) {
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
                      'Could not load attendance',
                      style: AppStyles.regular.normal.greyColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final percentage = state.percentage;
        final pctValue = percentage?.percentage ?? 0.0;
        final totalDays = percentage?.totalDays ?? 0;
        final presentDays = percentage?.presentDays ?? 0;
        final absentDays = percentage?.absentDays ?? 0;
        final progressValue = pctValue / 100.0;

        return GlassyBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance',
                    style: AppStyles.medium.medium.white,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getAttendanceColor(pctValue)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${pctValue.toStringAsFixed(1)}%',
                      style: AppStyles.medium.medium.greyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progressValue.clamp(0.0, 1.0),
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _getAttendanceColor(pctValue)),
                minHeight: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Present: $presentDays/$totalDays days',
                    style: AppStyles.regular.normal.greyColor,
                  ),
                  Text(
                    'Absent: $absentDays ${absentDays == 1 ? 'day' : 'days'}',
                    style: AppStyles.regular.normal.greyColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 75) return AppColors.greenColor;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
