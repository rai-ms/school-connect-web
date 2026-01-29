import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/leave_request_model.dart';
import '../../data/models/leave_type_model.dart';
import '../manager/leave_bloc/leave_bloc.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  LeaveTypeResponse? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isHalfDay = false;

  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(const FetchActiveLeaveTypes());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Apply for Leave', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state.leaveApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Leave application submitted successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is ApplyLeave) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to apply leave'),
                backgroundColor: AppColors.safetyLightRed,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Type Selection
                  Text('Leave Type', style: AppStyles.small.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: DropdownButtonFormField<LeaveTypeResponse>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Select leave type',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      dropdownColor: const Color(0xFF1E2A3A),
                      style: AppStyles.semiMedium.regular.white,
                      isExpanded: true,
                      items: state.leaveTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(type.name,
                                    style: AppStyles.semiMedium.regular.white),
                              ),
                              Text('${type.maxDaysPerYear}d/yr',
                                  style: AppStyles.extraSmall.regular.greyColor),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedLeaveType = value);
                      },
                      validator: (value) =>
                          value == null ? 'Please select a leave type' : null,
                    ),
                  ),

                  Space.h20,

                  // Date Selection
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Date',
                                style: AppStyles.small.semiBold.white),
                            Space.h8,
                            _buildDateField(
                              date: _startDate,
                              hint: 'Start date',
                              onTap: () => _pickDate(isStart: true),
                            ),
                          ],
                        ),
                      ),
                      Space.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date',
                                style: AppStyles.small.semiBold.white),
                            Space.h8,
                            _buildDateField(
                              date: _endDate,
                              hint: 'End date',
                              onTap: () => _pickDate(isStart: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Space.h16,

                  // Duration Info
                  if (_startDate != null && _endDate != null)
                    GlassyBackground(
                      borderColor:
                          AppColors.safetyBlue.withValues(alpha: 0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Days',
                              style: AppStyles.semiMedium.regular.white),
                          Text(
                            _isHalfDay
                                ? '0.5 day'
                                : '${_endDate!.difference(_startDate!).inDays + 1} day(s)',
                            style: AppStyles.semiMedium.bold
                                .colored(AppColors.safetyBlue),
                          ),
                        ],
                      ),
                    ),

                  Space.h16,

                  // Half Day Toggle
                  GlassyBackground(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Half Day',
                            style: AppStyles.semiMedium.regular.white),
                        Switch(
                          value: _isHalfDay,
                          onChanged: (value) {
                            setState(() {
                              _isHalfDay = value;
                              if (value && _startDate != null) {
                                _endDate = _startDate;
                              }
                            });
                          },
                          activeTrackColor: AppColors.safetyBlue,
                        ),
                      ],
                    ),
                  ),

                  Space.h20,

                  // Reason
                  Text('Reason', style: AppStyles.small.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: TextFormField(
                      controller: _reasonController,
                      style: AppStyles.semiMedium.regular.white,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter reason for leave...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Please enter a reason'
                          : null,
                    ),
                  ),

                  Space.h30,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitLeave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading && state.event is ApplyLeave
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text('Submit Application',
                              style: AppStyles.semiMedium.bold.white),
                    ),
                  ),
                  Space.h20,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateField({
    DateTime? date,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassyBackground(
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 18, color: AppColors.safetyBlue),
            Space.w8,
            Expanded(
              child: Text(
                date != null
                    ? DateFormat('dd MMM yyyy').format(date)
                    : hint,
                style: date != null
                    ? AppStyles.semiMedium.regular.white
                    : AppStyles.semiMedium.regular.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
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

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
          if (_isHalfDay) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitLeave() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
          backgroundColor: AppColors.safetyLightRed,
        ),
      );
      return;
    }

    final request = LeaveRequestCreate(
      leaveTypeId: _selectedLeaveType!.id,
      startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
      reason: _reasonController.text.trim(),
      isHalfDay: _isHalfDay,
    );

    context.read<LeaveBloc>().add(ApplyLeave(request));
  }
}
