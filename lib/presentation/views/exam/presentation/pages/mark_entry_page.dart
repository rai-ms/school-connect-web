import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/core/utils/toast.dart' show toast;
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/exam_result_model.dart';
import '../manager/exam_bloc/exam_bloc.dart';

class MarkEntryPage extends StatefulWidget {
  final String examId;

  const MarkEntryPage({super.key, required this.examId});

  @override
  State<MarkEntryPage> createState() => _MarkEntryPageState();
}

class _MarkEntryPageState extends State<MarkEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _marksController = TextEditingController();
  final _maxMarksController = TextEditingController(text: '100');
  final _remarksController = TextEditingController();
  bool _isAbsent = false;

  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(FetchExamDetails(widget.examId));
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _marksController.dispose();
    _maxMarksController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _submitMarks() {
    if (!_formKey.currentState!.validate()) return;

    final request = ExamResultRequest(
      studentId: _studentIdController.text.trim(),
      studentName: _studentNameController.text.trim().isEmpty
          ? null
          : _studentNameController.text.trim(),
      marksObtained: _isAbsent ? 0 : double.parse(_marksController.text.trim()),
      maxMarks: int.parse(_maxMarksController.text.trim()),
      isAbsent: _isAbsent,
      remarks: _remarksController.text.trim().isEmpty
          ? null
          : _remarksController.text.trim(),
    );

    context.read<ExamBloc>().add(EnterMarks(widget.examId, request));
  }

  void _clearForm() {
    _studentIdController.clear();
    _studentNameController.clear();
    _marksController.clear();
    _remarksController.clear();
    setState(() => _isAbsent = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Enter Marks', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state.isSuccess && state.event is EnterMarks) {
            toast('Marks entered successfully');
            _clearForm();
            context.read<ExamBloc>().add(FetchExamResults(widget.examId));
          }
          if (state.isFailed && state.event is EnterMarks) {
            toast(state.error ?? 'Failed to enter marks');
          }
        },
        builder: (context, state) {
          final exam = state.selectedExam;

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exam Info Header
                if (exam != null)
                  GlassyBackground(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.assignment,
                            color: AppColors.safetyBlue),
                        Space.w12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exam.name,
                                  style: AppStyles.medium.semiBold.white),
                              if (exam.subjectName != null)
                                Text(exam.subjectName!,
                                    style:
                                        AppStyles.small.regular.greyColor),
                            ],
                          ),
                        ),
                        Text('Max: ${exam.maxMarks}',
                            style: AppStyles.small.bold
                                .colored(AppColors.safetyBlue)),
                      ],
                    ),
                  ),
                Space.h20,

                // Mark Entry Form
                Text('Student Marks',
                    style: AppStyles.medium.semiBold.white),
                Space.h12,
                Form(
                  key: _formKey,
                  child: GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _studentIdController,
                          label: 'Student ID',
                          hint: 'Enter student UUID',
                          icon: Icons.person,
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Student ID is required'
                                  : null,
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _studentNameController,
                          label: 'Student Name (Optional)',
                          hint: 'Enter student name',
                          icon: Icons.badge,
                        ),
                        Space.h12,
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _marksController,
                                label: 'Marks Obtained',
                                hint: '0',
                                icon: Icons.grade,
                                keyboardType: TextInputType.number,
                                enabled: !_isAbsent,
                                validator: (v) {
                                  if (_isAbsent) return null;
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final marks = double.tryParse(v);
                                  if (marks == null) return 'Invalid';
                                  final max = int.tryParse(
                                          _maxMarksController.text) ??
                                      100;
                                  if (marks < 0 || marks > max) {
                                    return '0-$max';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                controller: _maxMarksController,
                                label: 'Max Marks',
                                hint: '100',
                                icon: Icons.looks_one,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  if (int.tryParse(v) == null) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Space.h12,
                        Row(
                          children: [
                            const Icon(Icons.event_busy,
                                size: 18, color: AppColors.greyColor),
                            Space.w8,
                            Text('Mark as Absent',
                                style: AppStyles.small.regular.white),
                            const Spacer(),
                            Switch(
                              value: _isAbsent,
                              onChanged: (v) =>
                                  setState(() => _isAbsent = v),
                              activeTrackColor: AppColors.safetyRed,
                            ),
                          ],
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _remarksController,
                          label: 'Remarks (Optional)',
                          hint: 'Any additional notes',
                          icon: Icons.note,
                          maxLines: 2,
                        ),
                        Space.h20,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                state.isLoading ? null : _submitMarks,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.safetyBlue,
                              padding: AppPadding.padSV14,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state.isLoading &&
                                    state.event is EnterMarks
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.whiteColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('Submit Marks',
                                    style: AppStyles.medium.semiBold.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Space.h20,

                // Recent Results
                if (state.examResults.isNotEmpty) ...[
                  Text(
                      'Entered Results (${state.examResults.length})',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  ...state.examResults.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GlassyBackground(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    r.studentName ?? r.studentId,
                                    style:
                                        AppStyles.small.regular.white),
                              ),
                              if (r.isAbsent)
                                Text('ABSENT',
                                    style: AppStyles.extraSmall.bold
                                        .colored(AppColors.safetyRed))
                              else
                                Text(
                                  '${r.marksObtained.toStringAsFixed(0)}/${r.maxMarks}',
                                  style: AppStyles.small.semiBold
                                      .colored(r.isPassed
                                          ? AppColors.safetyGreen
                                          : AppColors.safetyRed),
                                ),
                            ],
                          ),
                        ),
                      )),
                ],
                Space.h30,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      style: AppStyles.small.regular.white,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppColors.greyColor),
        labelStyle: AppStyles.small.regular.greyColor,
        hintStyle: AppStyles.small.regular
            .colored(AppColors.greyColor.withValues(alpha: 0.5)),
        filled: true,
        fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.whiteColor.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.whiteColor.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.safetyBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.safetyRed),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
