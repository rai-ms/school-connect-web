import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/assignment_model.dart';
import '../manager/assignment_bloc/assignment_bloc.dart';

class GradeSubmissionPage extends StatefulWidget {
  final String submissionId;

  const GradeSubmissionPage({super.key, required this.submissionId});

  @override
  State<GradeSubmissionPage> createState() => _GradeSubmissionPageState();
}

class _GradeSubmissionPageState extends State<GradeSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _marksController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Grade Submission', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state.isSuccess && state.actionCompleted) {
            if (state.event is GradeSubmission) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Submission graded successfully'),
                  backgroundColor: AppColors.safetyGreen,
                ),
              );
              context.pop();
            }
          }
          if (state.isFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'An error occurred'),
                backgroundColor: AppColors.safetyRed,
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
                  // Submission Info
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submission Details',
                            style: AppStyles.medium.bold.white),
                        Space.h12,
                        Row(
                          children: [
                            const Icon(Icons.person,
                                size: 16, color: AppColors.safetyBlue),
                            Space.w8,
                            Text(
                              'Submission ID: ${widget.submissionId}',
                              style: AppStyles.small.regular.copyWith(
                                color: AppColors.whiteColor
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Space.h24,

                  // Marks Field
                  Text('Marks Obtained *',
                      style: AppStyles.small.medium.greyColor),
                  Space.h8,
                  TextFormField(
                    controller: _marksController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Marks are required';
                      }
                      final marks = double.tryParse(value);
                      if (marks == null) return 'Enter a valid number';
                      if (marks < 0) return 'Marks cannot be negative';
                      return null;
                    },
                    style: AppStyles.medium.regular.white,
                    decoration: InputDecoration(
                      hintText: 'Enter marks',
                      hintStyle: AppStyles.medium.regular.copyWith(
                        color:
                            AppColors.greyColor.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor:
                          AppColors.whiteColor.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.grade,
                          color: AppColors.safetyOrange),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  Space.h24,

                  // Feedback Field
                  Text('Feedback',
                      style: AppStyles.small.medium.greyColor),
                  Space.h8,
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: AppStyles.medium.regular.white,
                    decoration: InputDecoration(
                      hintText: 'Write feedback for the student...',
                      hintStyle: AppStyles.medium.regular.copyWith(
                        color:
                            AppColors.greyColor.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor:
                          AppColors.whiteColor.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  Space.h30,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitGrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              state.event is GradeSubmission
                          ? const CircularProgressIndicator(
                              color: AppColors.whiteColor)
                          : Text(
                              'Submit Grade',
                              style: AppStyles.medium.bold.white,
                            ),
                    ),
                  ),
                  Space.h24,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitGrade() {
    if (!_formKey.currentState!.validate()) return;

    final marks = double.parse(_marksController.text.trim());
    final feedback = _feedbackController.text.trim().isNotEmpty
        ? _feedbackController.text.trim()
        : null;

    context.read<AssignmentBloc>().add(
          GradeSubmission(
            widget.submissionId,
            GradeSubmissionRequest(
              marksObtained: marks,
              feedback: feedback,
            ),
          ),
        );
  }
}
