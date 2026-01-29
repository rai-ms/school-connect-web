import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../core/utils/app_style.dart';
import '../../../core/utils/app_colors.dart';
import 'data/models/counseling_referral_model.dart';
import 'data/repositories/safety_repository.dart';

class CounselingReferralScreen extends StatefulWidget {
  const CounselingReferralScreen({super.key});

  @override
  State<CounselingReferralScreen> createState() =>
      _CounselingReferralScreenState();
}

class _CounselingReferralScreenState extends State<CounselingReferralScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String? _selectedStudent;
  String _selectedUrgency = 'Normal';
  bool _isSubmitting = false;

  // Dummy student data - TODO: Replace with API call
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'John Doe', 'grade': '10th Grade'},
    {'id': '2', 'name': 'Jane Smith', 'grade': '11th Grade'},
    {'id': '3', 'name': 'Mike Johnson', 'grade': '9th Grade'},
    {'id': '4', 'name': 'Sarah Wilson', 'grade': '12th Grade'},
    {'id': '5', 'name': 'Alex Brown', 'grade': '10th Grade'},
  ];

  final List<String> _urgencyLevels = ['Normal', 'Urgent'];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitReferral() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null) {
      context.snackBar(
        message: 'Please select a student',
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = InjectorService.service.inject<SafetyRepository>();
      final selectedStudentData = _students.firstWhere(
        (s) => s['id'] == _selectedStudent,
      );

      final request = CounselingReferralRequest(
        studentId: _selectedStudent!,
        studentName: selectedStudentData['name']!,
        classInfo: selectedStudentData['grade'],
        reason: _reasonController.text,
        urgency: _selectedUrgency,
      );

      await repository.createCounselingReferral(request);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        context.snackBar(
          message: 'Counseling referral submitted successfully',
          backgroundColor: Colors.green,
        );
        context.pop();
      }
    } catch (e) {
      Log.e("Failed to submit counseling referral: $e");
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        context.snackBar(
          message: 'Failed to submit referral. Please try again.',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counseling Referral'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.safetyBlue, AppColors.safetyDarkBlue],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassyBackground(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Referral Details',
                            style: AppStyles.large.bold.white,
                          ),
                          const SizedBox(height: 16),

                          // Student Selection
                          Text(
                            'Select Student',
                            style: AppStyles.medium.bold.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedStudent,
                              decoration: const InputDecoration(
                                labelText: 'Choose a student',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              items: _students.map((student) {
                                return DropdownMenuItem(
                                  value: student['id'],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        student['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        student['grade']!,
                                        style:
                                            AppStyles.small.regular.safetyGrey,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStudent = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Reason Field
                          TextFormField(
                            controller: _reasonController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Reason for Referral',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a reason';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Urgency Selector
                          Text(
                            'Urgency Level',
                            style: AppStyles.medium.bold.white,
                          ),
                          const SizedBox(height: 8),
                          RadioGroup<String>(
                            groupValue: _selectedUrgency,
                            onChanged: (value) {
                              setState(() {
                                _selectedUrgency = value!;
                              });
                            },
                            child: Column(
                              children: _urgencyLevels
                                  .map(
                                    (urgency) => RadioListTile<String>(
                                      title: Text(
                                        urgency,
                                        style: AppStyles.medium.regular.white,
                                      ),
                                      value: urgency,
                                      activeColor: AppColors.whiteColor,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Additional Notes
                          TextFormField(
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Additional Notes (Optional)',
                              border: OutlineInputBorder(),
                              fillColor: AppColors.whiteColor,
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.whiteColor,
                                    side: const BorderSide(
                                      color: AppColors.whiteColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : _submitReferral,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.whiteColor,
                                    foregroundColor: AppColors.safetyBlue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.safetyBlue,
                                                ),
                                          ),
                                        )
                                      : const Text('Submit Referral'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
