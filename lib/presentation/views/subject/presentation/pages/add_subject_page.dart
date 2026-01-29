import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/subject_model.dart';
import '../manager/subject_bloc/subject_bloc.dart';

class AddSubjectPage extends StatefulWidget {
  final SubjectResponse? existingSubject;
  const AddSubjectPage({super.key, this.existingSubject});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _creditHoursController = TextEditingController();
  final _maxMarksController = TextEditingController();
  final _passingMarksController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _departmentController = TextEditingController();

  String _selectedType = 'CORE';
  bool _isActive = true;

  bool get isEditing => widget.existingSubject != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingSubject != null) {
      final subject = widget.existingSubject!;
      _nameController.text = subject.name;
      _codeController.text = subject.code;
      _descriptionController.text = subject.description ?? '';
      _selectedType = subject.type;
      _creditHoursController.text =
          subject.creditHours?.toString() ?? '';
      _maxMarksController.text = subject.maxMarks?.toString() ?? '';
      _passingMarksController.text =
          subject.passingMarks?.toString() ?? '';
      _academicYearController.text = subject.academicYear ?? '';
      _departmentController.text = subject.department ?? '';
      _isActive = subject.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _creditHoursController.dispose();
    _maxMarksController.dispose();
    _passingMarksController.dispose();
    _academicYearController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text(
          isEditing ? 'Edit Subject' : 'Add Subject',
          style: AppStyles.large.bold.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state.actionCompleted &&
              (state.event is CreateSubjectEvent ||
                  state.event is UpdateSubjectEvent)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing
                    ? 'Subject updated successfully'
                    : 'Subject added successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed &&
              (state.event is CreateSubjectEvent ||
                  state.event is UpdateSubjectEvent)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ??
                    'Failed to ${isEditing ? 'update' : 'add'} subject'),
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
                  Text('Basic Information',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_nameController, 'Subject Name',
                            required: true),
                        Space.h12,
                        _buildTextField(_codeController, 'Subject Code',
                            required: true,
                            hint: 'e.g., MATH101 (uppercase letters, numbers, underscores)'),
                        Space.h12,
                        _buildTextField(
                            _descriptionController, 'Description',
                            maxLines: 3),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Classification',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject Type',
                            style: AppStyles.small.regular.greyColor),
                        Space.h8,
                        _buildTypeSelector(),
                        Space.h12,
                        _buildTextField(
                            _departmentController, 'Department',
                            hint: 'e.g., Science, Arts'),
                        Space.h12,
                        _buildTextField(
                            _academicYearController, 'Academic Year',
                            hint: 'e.g., 2025-26'),
                        Space.h12,
                        _buildActiveSwitch(),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Academic Details',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _creditHoursController, 'Credit Hours',
                            keyboardType: TextInputType.number),
                        Space.h12,
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  _maxMarksController, 'Max Marks',
                                  keyboardType:
                                      TextInputType.number),
                            ),
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                  _passingMarksController,
                                  'Passing Marks',
                                  keyboardType:
                                      TextInputType.number),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Space.h24,
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitSubject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              (state.event is CreateSubjectEvent ||
                                  state.event is UpdateSubjectEvent)
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? 'Update Subject'
                                  : 'Add Subject',
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: AppStyles.semiMedium.regular.white,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.small.regular.greyColor,
        hintText: hint,
        hintStyle: AppStyles.extraSmall.regular.greyColor,
        border: InputBorder.none,
      ),
      validator: required
          ? (v) =>
              v == null || v.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTypeChip('Core', 'CORE'),
        _buildTypeChip('Elective', 'ELECTIVE'),
        _buildTypeChip('Extra Curricular', 'EXTRA_CURRICULAR'),
      ],
    );
  }

  Widget _buildTypeChip(String label, String type) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedType = type);
      },
      selectedColor: AppColors.safetyBlue,
      backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
      labelStyle: isSelected
          ? AppStyles.small.regular.white
          : AppStyles.small.regular.greyColor,
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Active', style: AppStyles.small.regular.greyColor),
        Switch(
          value: _isActive,
          onChanged: (val) => setState(() => _isActive = val),
          activeTrackColor: AppColors.safetyGreen.withValues(alpha: 0.5),
          activeThumbColor: AppColors.safetyGreen,
        ),
      ],
    );
  }

  void _submitSubject() {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateSubjectRequest(
      name: _nameController.text.trim(),
      code: _codeController.text.trim().toUpperCase(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      type: _selectedType,
      creditHours: _creditHoursController.text.trim().isNotEmpty
          ? int.tryParse(_creditHoursController.text.trim())
          : null,
      maxMarks: _maxMarksController.text.trim().isNotEmpty
          ? int.tryParse(_maxMarksController.text.trim())
          : null,
      passingMarks: _passingMarksController.text.trim().isNotEmpty
          ? int.tryParse(_passingMarksController.text.trim())
          : null,
      academicYear: _academicYearController.text.trim().isNotEmpty
          ? _academicYearController.text.trim()
          : null,
      department: _departmentController.text.trim().isNotEmpty
          ? _departmentController.text.trim()
          : null,
      isActive: _isActive,
    );

    if (isEditing) {
      context.read<SubjectBloc>().add(
            UpdateSubjectEvent(widget.existingSubject!.id, request),
          );
    } else {
      context.read<SubjectBloc>().add(CreateSubjectEvent(request));
    }
  }
}
