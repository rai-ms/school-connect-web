import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/core/utils/toast.dart' show toast;
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/exam_model.dart';
import '../../data/models/exam_type_model.dart';
import '../manager/exam_bloc/exam_bloc.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({super.key});

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _classIdController = TextEditingController();
  final _sectionController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _maxMarksController = TextEditingController(text: '100');
  final _passingMarksController = TextEditingController(text: '33');
  final _roomController = TextEditingController();
  final _instructionsController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  ExamTypeResponse? _selectedExamType;

  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(const FetchExamTypes());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _classIdController.dispose();
    _sectionController.dispose();
    _subjectNameController.dispose();
    _maxMarksController.dispose();
    _passingMarksController.dispose();
    _roomController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitExam() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExamType == null) {
      toast('Please select an exam type');
      return;
    }

    final request = ExamRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      examTypeId: _selectedExamType!.id,
      classId: _classIdController.text.trim(),
      section: _sectionController.text.trim().isEmpty
          ? null
          : _sectionController.text.trim(),
      subjectName: _subjectNameController.text.trim().isEmpty
          ? null
          : _subjectNameController.text.trim(),
      examDate: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      startTime: _startTime != null
          ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
      endTime: _endTime != null
          ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
      maxMarks: int.parse(_maxMarksController.text.trim()),
      passingMarks: int.tryParse(_passingMarksController.text.trim()),
      room: _roomController.text.trim().isEmpty
          ? null
          : _roomController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
    );

    context.read<ExamBloc>().add(CreateExam(request));
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) {
      setState(() => _startTime = time);
    }
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (time != null) {
      setState(() => _endTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Schedule Exam', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state.isSuccess && state.event is CreateExam) {
            toast('Exam scheduled successfully');
            context.pop();
          }
          if (state.isFailed && state.event is CreateExam) {
            toast(state.error ?? 'Failed to create exam');
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
                  // Basic Info
                  Text('Basic Information',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Exam Name',
                          hint: 'e.g., Mid-Term Mathematics',
                          icon: Icons.assignment,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Exam name is required'
                              : null,
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description (Optional)',
                          hint: 'Brief description of the exam',
                          icon: Icons.description,
                          maxLines: 2,
                        ),
                        Space.h12,
                        // Exam Type Dropdown
                        DropdownButtonFormField<ExamTypeResponse>(
                          initialValue: _selectedExamType,
                          decoration: _inputDecoration(
                              'Exam Type', Icons.category),
                          dropdownColor: AppColors.backgroundImageColor,
                          style: AppStyles.small.regular.white,
                          items: state.examTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type.name),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedExamType = v),
                          validator: (v) =>
                              v == null ? 'Select exam type' : null,
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _subjectNameController,
                          label: 'Subject (Optional)',
                          hint: 'e.g., Mathematics',
                          icon: Icons.book,
                        ),
                      ],
                    ),
                  ),
                  Space.h20,

                  // Class Info
                  Text('Class Details',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _classIdController,
                          label: 'Class ID',
                          hint: 'Enter class UUID',
                          icon: Icons.class_,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Class ID is required'
                              : null,
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _sectionController,
                          label: 'Section (Optional)',
                          hint: 'e.g., A, B, C',
                          icon: Icons.group,
                        ),
                      ],
                    ),
                  ),
                  Space.h20,

                  // Schedule
                  Text('Schedule',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        // Date Picker
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: _inputDecoration(
                                'Exam Date', Icons.calendar_today),
                            child: Text(
                              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: AppStyles.small.regular.white,
                            ),
                          ),
                        ),
                        Space.h12,
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _pickStartTime,
                                child: InputDecorator(
                                  decoration: _inputDecoration(
                                      'Start Time', Icons.access_time),
                                  child: Text(
                                    _startTime?.format(context) ??
                                        'Not set',
                                    style: AppStyles.small.regular.white,
                                  ),
                                ),
                              ),
                            ),
                            Space.w12,
                            Expanded(
                              child: InkWell(
                                onTap: _pickEndTime,
                                child: InputDecorator(
                                  decoration: _inputDecoration(
                                      'End Time', Icons.access_time),
                                  child: Text(
                                    _endTime?.format(context) ?? 'Not set',
                                    style: AppStyles.small.regular.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Space.h20,

                  // Marks & Room
                  Text('Marks & Venue',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _maxMarksController,
                                label: 'Max Marks',
                                hint: '100',
                                icon: Icons.grade,
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
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                controller: _passingMarksController,
                                label: 'Passing Marks',
                                hint: '33',
                                icon: Icons.check_circle_outline,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        Space.h12,
                        _buildTextField(
                          controller: _roomController,
                          label: 'Room/Hall (Optional)',
                          hint: 'e.g., Room 101',
                          icon: Icons.room,
                        ),
                      ],
                    ),
                  ),
                  Space.h20,

                  // Instructions
                  Text('Instructions',
                      style: AppStyles.medium.semiBold.white),
                  Space.h8,
                  GlassyBackground(
                    child: _buildTextField(
                      controller: _instructionsController,
                      label: 'Instructions (Optional)',
                      hint: 'Any special instructions for the exam',
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                  ),
                  Space.h24,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading && state.event is CreateExam
                              ? null
                              : _submitExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        padding: AppPadding.padSV16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading && state.event is CreateExam
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('Schedule Exam',
                              style: AppStyles.medium.semiBold.white),
                    ),
                  ),
                  Space.h30,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18, color: AppColors.greyColor),
      labelStyle: AppStyles.small.regular.greyColor,
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
