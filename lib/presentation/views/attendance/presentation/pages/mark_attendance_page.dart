import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/attendance_model.dart';
import '../manager/attendance_bloc/attendance_bloc.dart';

class MarkAttendancePage extends StatefulWidget {
  final String classId;
  const MarkAttendancePage({super.key, required this.classId});

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  DateTime _selectedDate = DateTime.now();
  final List<StudentAttendanceRecord> _records = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context
        .read<AttendanceBloc>()
        .add(FetchClassAttendance(widget.classId, dateStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Mark Attendance', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state.attendanceMarked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attendance marked successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is MarkBulkAttendance) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.error ?? 'Failed to mark attendance'),
                backgroundColor: AppColors.safetyLightRed,
              ),
            );
          }
          // Initialize records from existing attendance
          if (!_initialized && state.records.isNotEmpty) {
            _initialized = true;
            _records.clear();
            for (final record in state.records) {
              _records.add(StudentAttendanceRecord(
                studentId: record.studentId,
                status: record.status,
                remarks: record.remarks,
              ));
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Date Selector
              Padding(
                padding: AppPadding.padSH16,
                child: GlassyBackground(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: AppColors.whiteColor),
                        onPressed: () => _changeDate(-1),
                      ),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: AppColors.safetyBlue),
                            Space.w8,
                            Text(
                              DateFormat('dd MMM yyyy')
                                  .format(_selectedDate),
                              style: AppStyles.semiMedium.bold.white,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: AppColors.whiteColor),
                        onPressed: _selectedDate
                                .isBefore(DateTime.now())
                            ? () => _changeDate(1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              Space.h8,

              // Quick Actions
              Padding(
                padding: AppPadding.padSH16,
                child: Row(
                  children: [
                    _buildQuickAction(
                        'All Present', AppColors.safetyGreen, () {
                      setState(() {
                        for (final r in _records) {
                          r.status = 'PRESENT';
                        }
                      });
                    }),
                    Space.w8,
                    _buildQuickAction(
                        'All Absent', AppColors.safetyLightRed, () {
                      setState(() {
                        for (final r in _records) {
                          r.status = 'ABSENT';
                        }
                      });
                    }),
                  ],
                ),
              ),

              Space.h8,

              // Student List
              Expanded(
                child: state.isLoading && _records.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.safetyBlue),
                      )
                    : _records.isEmpty
                        ? Center(
                            child: Text('No students found',
                                style:
                                    AppStyles.medium.regular.greyColor),
                          )
                        : ListView.builder(
                            padding: AppPadding.padA16,
                            itemCount: _records.length,
                            itemBuilder: (context, index) {
                              final record = _records[index];
                              final existingInfo =
                                  index < state.records.length
                                      ? state.records[index]
                                      : null;

                              return _buildStudentRow(
                                  record, existingInfo, index);
                            },
                          ),
              ),

              // Submit Button
              Padding(
                padding: AppPadding.padA16,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submitAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isLoading &&
                            state.event is MarkBulkAttendance
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.whiteColor,
                            ),
                          )
                        : Text('Submit Attendance',
                            style: AppStyles.semiMedium.bold.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(
      String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(label,
                style: AppStyles.small.semiBold.colored(color)),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentRow(StudentAttendanceRecord record,
      AttendanceResponse? info, int index) {
    final statusColor = _getStatusColor(record.status);
    final name = info?.studentName ?? 'Student ${index + 1}';
    final roll = info?.rollNumber ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassyBackground(
        borderColor: statusColor.withValues(alpha: 0.2),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  statusColor.withValues(alpha: 0.15),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style:
                    AppStyles.semiMedium.bold.colored(statusColor),
              ),
            ),
            Space.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppStyles.semiMedium.semiBold.white),
                  if (roll.isNotEmpty)
                    Text('Roll: $roll',
                        style: AppStyles.extraSmall.regular.greyColor),
                ],
              ),
            ),
            // Status Chips
            ...['PRESENT', 'ABSENT', 'LATE'].map((status) {
              final isSelected = record.status == status;
              final chipColor = _getStatusColor(status);
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() => record.status = status);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? chipColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? chipColor
                            : AppColors.greyColor
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      status[0],
                      style: AppStyles.extraSmall.bold.colored(
                          isSelected ? chipColor : AppColors.greyColor),
                    ),
                  ),
                ),
              );
            }),
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

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _initialized = false;
      _records.clear();
    });
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context
        .read<AttendanceBloc>()
        .add(FetchClassAttendance(widget.classId, dateStr));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.safetyBlue,
              surface: Color(0xFF1E2A3A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _initialized = false;
        _records.clear();
      });
      final dateStr = DateFormat('yyyy-MM-dd').format(picked);
      context
          .read<AttendanceBloc>()
          .add(FetchClassAttendance(widget.classId, dateStr));
    }
  }

  void _submitAttendance() {
    if (_records.isEmpty) return;

    final request = MarkAttendanceRequest(
      attendanceDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      classId: widget.classId,
      studentAttendance: _records,
    );

    context.read<AttendanceBloc>().add(MarkBulkAttendance(request));
  }
}
