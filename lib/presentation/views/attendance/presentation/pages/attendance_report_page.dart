import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/attendance_model.dart';
import '../manager/attendance_bloc/attendance_bloc.dart';

class AttendanceReportPage extends StatefulWidget {
  final String studentId;
  const AttendanceReportPage({super.key, required this.studentId});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
          FetchStudentAttendancePercentage(widget.studentId));
    context.read<AttendanceBloc>().add(
          FetchStudentAttendance(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title:
            Text('Attendance Report', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.records.isEmpty &&
              state.percentage == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Percentage Card
              if (state.percentage != null)
                _buildPercentageCard(state.percentage!),

              Space.h16,

              // Stats Row
              if (state.percentage != null) ...[
                Row(
                  children: [
                    _buildStatCard('Present', '${state.percentage!.presentDays}',
                        AppColors.safetyGreen),
                    Space.w8,
                    _buildStatCard('Absent', '${state.percentage!.absentDays}',
                        AppColors.safetyLightRed),
                    Space.w8,
                    _buildStatCard('Late', '${state.percentage!.lateDays}',
                        AppColors.safetyOrange),
                  ],
                ),
                Space.h20,
              ],

              // Recent Records
              Text('Recent Attendance',
                  style: AppStyles.semiMedium.bold.white),
              Space.h8,

              if (state.records.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text('No attendance records',
                        style: AppStyles.medium.regular.greyColor),
                  ),
                )
              else
                ...state.records.map(_buildAttendanceCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPercentageCard(AttendancePercentage pct) {
    final color = pct.percentage >= 75
        ? AppColors.safetyGreen
        : pct.percentage >= 50
            ? AppColors.safetyOrange
            : AppColors.safetyLightRed;

    return GlassyBackground(
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        children: [
          Text('Overall Attendance',
              style: AppStyles.semiMedium.regular.greyColor),
          Space.h12,
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: pct.percentage / 100,
                    strokeWidth: 8,
                    backgroundColor:
                        AppColors.whiteColor.withValues(alpha: 0.1),
                    color: color,
                  ),
                ),
                Text(
                  '${pct.percentage.toStringAsFixed(1)}%',
                  style: AppStyles.large.bold.colored(color),
                ),
              ],
            ),
          ),
          Space.h12,
          Text(
            '${pct.presentDays} of ${pct.totalDays} days',
            style: AppStyles.small.regular.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: GlassyBackground(
        child: Column(
          children: [
            Text(value,
                style: AppStyles.large.bold.colored(color)),
            Space.h4,
            Text(label, style: AppStyles.extraSmall.regular.greyColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceResponse record) {
    final statusColor = _getStatusColor(record.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassyBackground(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getStatusIcon(record.status),
                size: 20,
                color: statusColor,
              ),
            ),
            Space.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.attendanceDate,
                      style: AppStyles.semiMedium.semiBold.white),
                  if (record.subject != null)
                    Text(record.subject!,
                        style: AppStyles.small.regular.greyColor),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                record.statusLabel,
                style:
                    AppStyles.extraSmall.bold.colored(statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PRESENT':
        return AppColors.safetyGreen;
      case 'ABSENT':
        return AppColors.safetyLightRed;
      case 'LATE':
        return AppColors.safetyOrange;
      case 'HALF_DAY':
        return AppColors.selectiveYellow;
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PRESENT':
        return Icons.check_circle;
      case 'ABSENT':
        return Icons.cancel;
      case 'LATE':
        return Icons.access_time;
      case 'HALF_DAY':
        return Icons.timelapse;
      default:
        return Icons.help_outline;
    }
  }
}
