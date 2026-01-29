import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../core/utils/app_style.dart';
import '../../../core/utils/app_colors.dart';
import '../../widgets/customs/app_text_field.dart';
import '../../widgets/customs/silver_validation/silver_validation.dart';
import 'data/models/incident_report_model.dart';
import 'data/repositories/safety_repository.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ValidatedController _titleController;
  late final ValidatedController _descriptionController;

  String _selectedCategory = 'bullying';
  String _selectedSeverity = 'Medium';
  final List<String> _attachments = [];
  bool _isSubmitting = false;

  final List<String> _categories = [
    'bullying',
    'misconduct',
    'accident',
    'other',
  ];

  final List<String> _severityLevels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _titleController = ValidatedController(
      validation: Validation.string.description(),
    );
    _descriptionController = ValidatedController(
      validation: Validation.string.description(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addAttachment() {
    // TODO: Implement file picker
    setState(() {
      _attachments.add('attachment_${_attachments.length + 1}.pdf');
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = InjectorService.service.inject<SafetyRepository>();
      final request = IncidentReportRequest(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        severity: _selectedSeverity,
        occurredAt: DateTime.now(),
        attachments: _attachments.isNotEmpty ? _attachments : null,
      );

      await repository.createIncidentReport(request);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        context.snackBar(
          message: "Incident report submitted successfully",
          backgroundColor: AppColors.safetyOrange,
        );
        context.pop();
      }
    } catch (e) {
      Log.e("Failed to submit incident report: $e");
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        context.snackBar(
          message: "Failed to submit report. Please try again.",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
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
                          'Incident Details',
                          style: AppStyles.large.bold.white,
                        ),
                        const SizedBox(height: 16),

                        // Title Field
                        AppTextField(
                          hintText: 'Incident Title',
                          controller: _titleController,
                          maxLines: 1,
                          fieldColor: AppColors.darkCharcoal,
                          textStyle: AppStyles.medium.normal.white,
                          cursorColor: AppColors.whiteColor,
                          labelTextStyle: AppStyles.medium.normal.white,
                        ),
                        const SizedBox(height: 16),

                        // Description Field
                        AppTextField(
                          hintText: 'Description',
                          controller: _descriptionController,
                          maxLines: 4,
                          fieldColor: AppColors.darkCharcoal,
                          textStyle: AppStyles.medium.normal.white,
                          cursorColor: AppColors.whiteColor,
                          labelTextStyle: AppStyles.medium.normal.white,
                        ),
                        const SizedBox(height: 16),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.whiteColor,
                                width: 1,
                              ),
                            ),
                            fillColor: Colors.white,
                            enabled: true,
                          ),
                          dropdownColor: AppColors.darkCharcoal,
                          focusColor: AppColors.whiteColor,
                          autofocus: true,
                          isExpanded: true,
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              alignment: Alignment.topLeft,
                              value: category,
                              child: Text(
                                category.toUpperCase(), style: AppStyles.semiMedium.medium.white,),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Severity Selector
                        Text(
                          'Severity Level',
                          style: AppStyles.medium.bold.white,
                        ),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          groupValue: _selectedSeverity,
                          onChanged: (value) {
                            setState(() {
                              _selectedSeverity = value!;
                            });
                          },
                          child: Column(
                            children: _severityLevels
                                .map(
                                  (severity) => RadioListTile<String>(
                                    title: Text(
                                      severity,
                                      style: AppStyles.medium.regular.white,
                                    ),
                                    value: severity,
                                    activeColor: Colors.white,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // File Attachments
                        Row(
                          children: [
                            Text(
                              'Attachments',
                              style: AppStyles.medium.bold.white,
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _addAttachment,
                              icon: const Icon(Icons.attach_file),
                              label: const Text('Add File'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(85, 30),
                                backgroundColor: AppColors.darkCharcoal,
                                foregroundColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (_attachments.isNotEmpty) ...[
                          ...(_attachments.asMap().entries.map((entry) {
                            final index = entry.key;
                            final attachment = entry.value;
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.attachment),
                                title: Text(attachment),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeAttachment(index),
                                ),
                              ),
                            );
                          }).toList()),
                          const SizedBox(height: 16),
                        ],

                        // Action Buttons
                        ValidatedBuilder(
                          validations: [
                            _titleController,
                            _descriptionController,
                          ],
                          builder:
                              (context, isValidated, validation, validators) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => context.pop(),
                                        style: OutlinedButton.styleFrom(
                                          fixedSize: Size(60, 45),
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
                                        onPressed:
                                            (isValidated ?? true) &&
                                                !_isSubmitting
                                            ? _submitReport
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(60, 45),
                                          backgroundColor: AppColors.darkCharcoal,
                                          foregroundColor: AppColors.whiteColor,
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
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(AppColors.safetyOrange),
                                                ),
                                              )
                                            : const Text('Submit Report'),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
    );
  }
}
