import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';

import '../../data/models/assignment_model.dart';
import '../manager/assignment_bloc/assignment_bloc.dart';

class CreateAssignmentPage extends StatefulWidget {
  final String? editAssignmentId;

  const CreateAssignmentPage({super.key, this.editAssignmentId});

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _classIdController = TextEditingController();
  final _sectionIdController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _subjectIdController = TextEditingController();
  final _maxMarksController = TextEditingController(text: '100');
  final _attachmentUrlController = TextEditingController();

  DateTime? _dueDate;
  DateTime? _assignedDate;
  String _selectedStatus = 'DRAFT';
  String _selectedType = 'HOMEWORK';

  bool get isEditing => widget.editAssignmentId != null;

  @override
  void initState() {
    super.initState();
    _assignedDate = DateTime.now();
    if (isEditing) {
      context
          .read<AssignmentBloc>()
          .add(FetchAssignmentById(widget.editAssignmentId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _classIdController.dispose();
    _sectionIdController.dispose();
    _teacherIdController.dispose();
    _subjectIdController.dispose();
    _maxMarksController.dispose();
    _attachmentUrlController.dispose();
    super.dispose();
  }

  void _populateForEdit(AssignmentResponse assignment) {
    _titleController.text = assignment.title;
    _descriptionController.text = assignment.description ?? '';
    _classIdController.text = assignment.classId ?? '';
    _sectionIdController.text = assignment.sectionId ?? '';
    _teacherIdController.text = assignment.teacherId ?? '';
    _subjectIdController.text = assignment.subjectId ?? '';
    _maxMarksController.text = '${assignment.maxMarks}';
    _attachmentUrlController.text = assignment.attachmentUrl ?? '';
    _selectedStatus = assignment.status;
    _selectedType = assignment.type;

    if (assignment.dueDate != null) {
      _dueDate = DateTime.tryParse(assignment.dueDate!);
    }
    if (assignment.assignedDate != null) {
      _assignedDate = DateTime.tryParse(assignment.assignedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text(
          isEditing ? 'Edit Assignment' : 'Create Assignment',
          style: AppStyles.large.bold.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state.isSuccess && state.actionCompleted) {
            if (state.event is CreateAssignment ||
                state.event is UpdateAssignment) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEditing
                      ? 'Assignment updated successfully'
                      : 'Assignment created successfully'),
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
          // Populate form for editing
          if (isEditing &&
              state.isSuccess &&
              state.event is FetchAssignmentById &&
              state.selectedAssignment != null) {
            _populateForEdit(state.selectedAssignment!);
          }
        },
        builder: (context, state) {
          if (isEditing &&
              state.isLoading &&
              state.event is FetchAssignmentById) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title *',
                    hint: 'Assignment title',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Title is required' : null,
                  ),
                  Space.h16,
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Assignment description',
                    maxLines: 3,
                  ),
                  Space.h16,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _classIdController,
                          label: 'Class ID *',
                          hint: 'Class ID',
                          validator: (v) => v == null || v.isEmpty
                              ? 'Class ID is required'
                              : null,
                        ),
                      ),
                      Space.w12,
                      Expanded(
                        child: _buildTextField(
                          controller: _sectionIdController,
                          label: 'Section ID',
                          hint: 'Section ID',
                        ),
                      ),
                    ],
                  ),
                  Space.h16,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _teacherIdController,
                          label: 'Teacher ID *',
                          hint: 'Teacher ID',
                          validator: (v) => v == null || v.isEmpty
                              ? 'Teacher ID is required'
                              : null,
                        ),
                      ),
                      Space.w12,
                      Expanded(
                        child: _buildTextField(
                          controller: _subjectIdController,
                          label: 'Subject ID',
                          hint: 'Subject ID',
                        ),
                      ),
                    ],
                  ),
                  Space.h16,
                  _buildTextField(
                    controller: _maxMarksController,
                    label: 'Max Marks',
                    hint: '100',
                    keyboardType: TextInputType.number,
                  ),
                  Space.h16,
                  // Due Date
                  _buildDatePicker(
                    label: 'Due Date *',
                    selectedDate: _dueDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now().add(
                            const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                            const Duration(days: 365)),
                      );
                      if (date != null) setState(() => _dueDate = date);
                    },
                  ),
                  Space.h16,
                  // Assigned Date
                  _buildDatePicker(
                    label: 'Assigned Date',
                    selectedDate: _assignedDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _assignedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(
                            const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _assignedDate = date);
                      }
                    },
                  ),
                  Space.h16,
                  // Type Dropdown
                  _buildDropdown(
                    label: 'Type',
                    value: _selectedType,
                    items: ['HOMEWORK', 'CLASSWORK', 'PROJECT'],
                    onChanged: (v) =>
                        setState(() => _selectedType = v!),
                  ),
                  Space.h16,
                  // Status Dropdown
                  _buildDropdown(
                    label: 'Status',
                    value: _selectedStatus,
                    items: ['DRAFT', 'PUBLISHED', 'CLOSED'],
                    onChanged: (v) =>
                        setState(() => _selectedStatus = v!),
                  ),
                  Space.h16,
                  _buildTextField(
                    controller: _attachmentUrlController,
                    label: 'Attachment URL',
                    hint: 'https://...',
                  ),
                  Space.h24,
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              (state.event is CreateAssignment ||
                                  state.event is UpdateAssignment)
                          ? const CircularProgressIndicator(
                              color: AppColors.whiteColor)
                          : Text(
                              isEditing
                                  ? 'Update Assignment'
                                  : 'Create Assignment',
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: AppColors.safetyRed,
        ),
      );
      return;
    }

    final dueDateStr =
        '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}';
    final assignedDateStr = _assignedDate != null
        ? '${_assignedDate!.year}-${_assignedDate!.month.toString().padLeft(2, '0')}-${_assignedDate!.day.toString().padLeft(2, '0')}'
        : null;

    if (isEditing) {
      context.read<AssignmentBloc>().add(
            UpdateAssignment(
              widget.editAssignmentId!,
              UpdateAssignmentRequest(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                classId: _classIdController.text.trim(),
                sectionId: _sectionIdController.text.trim().isNotEmpty
                    ? _sectionIdController.text.trim()
                    : null,
                subjectId: _subjectIdController.text.trim().isNotEmpty
                    ? _subjectIdController.text.trim()
                    : null,
                dueDate: dueDateStr,
                maxMarks: int.tryParse(_maxMarksController.text.trim()),
                attachmentUrl:
                    _attachmentUrlController.text.trim().isNotEmpty
                        ? _attachmentUrlController.text.trim()
                        : null,
                status: _selectedStatus,
                type: _selectedType,
              ),
            ),
          );
    } else {
      context.read<AssignmentBloc>().add(
            CreateAssignment(
              CreateAssignmentRequest(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                classId: _classIdController.text.trim(),
                sectionId: _sectionIdController.text.trim().isNotEmpty
                    ? _sectionIdController.text.trim()
                    : null,
                teacherId: _teacherIdController.text.trim(),
                subjectId: _subjectIdController.text.trim().isNotEmpty
                    ? _subjectIdController.text.trim()
                    : null,
                dueDate: dueDateStr,
                assignedDate: assignedDateStr,
                maxMarks: int.tryParse(_maxMarksController.text.trim()),
                attachmentUrl:
                    _attachmentUrlController.text.trim().isNotEmpty
                        ? _attachmentUrlController.text.trim()
                        : null,
                status: _selectedStatus,
                type: _selectedType,
              ),
            ),
          );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.small.medium.greyColor),
        Space.h8,
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppStyles.medium.regular.white,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.medium.regular.copyWith(
              color: AppColors.greyColor.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.whiteColor.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    final dateStr = selectedDate != null
        ? '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'
        : 'Select date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.small.medium.greyColor),
        Space.h8,
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateStr,
                    style: selectedDate != null
                        ? AppStyles.medium.regular.white
                        : AppStyles.medium.regular.copyWith(
                            color: AppColors.greyColor
                                .withValues(alpha: 0.5),
                          ),
                  ),
                ),
                const Icon(Icons.calendar_today,
                    size: 18, color: AppColors.greyColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.small.medium.greyColor),
        Space.h8,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.darkGunMetal,
              style: AppStyles.medium.regular.white,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
