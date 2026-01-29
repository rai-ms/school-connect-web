import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/teacher_model.dart';
import '../manager/teacher_bloc/teacher_bloc.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _qualificationController = TextEditingController();

  String _gender = 'MALE';
  String _employeeType = 'PERMANENT';
  DateTime? _dateOfBirth;
  DateTime _joiningDate = DateTime.now();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Add Teacher', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is CreateTeacher) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Teacher added successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is CreateTeacher) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to add teacher'),
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
                        _buildTextField(
                            _employeeIdController, 'Employee ID',
                            required: true),
                        Space.h12,
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  _firstNameController, 'First Name',
                                  required: true),
                            ),
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                  _lastNameController, 'Last Name',
                                  required: true),
                            ),
                          ],
                        ),
                        Space.h12,
                        _buildGenderSelector(),
                        Space.h12,
                        _buildDateField(
                          label: 'Date of Birth',
                          date: _dateOfBirth,
                          onTap: () => _pickDate(isDob: true),
                        ),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Contact', style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_emailController, 'Email',
                            required: true),
                        Space.h12,
                        _buildTextField(_phoneController, 'Phone',
                            required: true),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Professional',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _designationController, 'Designation',
                            required: true),
                        Space.h12,
                        _buildTextField(
                            _departmentController, 'Department'),
                        Space.h12,
                        _buildTextField(_qualificationController,
                            'Highest Qualification'),
                        Space.h12,
                        _buildEmployeeTypeSelector(),
                        Space.h12,
                        _buildDateField(
                          label: 'Joining Date',
                          date: _joiningDate,
                          onTap: () => _pickDate(isDob: false),
                        ),
                      ],
                    ),
                  ),

                  Space.h24,
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              state.event is CreateTeacher
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text('Add Teacher',
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
  }) {
    return TextFormField(
      controller: controller,
      style: AppStyles.semiMedium.regular.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.small.regular.greyColor,
        border: InputBorder.none,
      ),
      validator: required
          ? (v) => v == null || v.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Text('Gender', style: AppStyles.small.regular.greyColor),
        Space.w12,
        ...['MALE', 'FEMALE'].map((g) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(g),
              selected: _gender == g,
              onSelected: (selected) {
                if (selected) setState(() => _gender = g);
              },
              selectedColor: AppColors.safetyBlue,
              backgroundColor:
                  AppColors.whiteColor.withValues(alpha: 0.1),
              labelStyle: AppStyles.small.regular.white,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmployeeTypeSelector() {
    return Row(
      children: [
        Text('Type', style: AppStyles.small.regular.greyColor),
        Space.w12,
        ...['PERMANENT', 'CONTRACT'].map((t) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(t),
              selected: _employeeType == t,
              onSelected: (selected) {
                if (selected) setState(() => _employeeType = t);
              },
              selectedColor: AppColors.verdigris,
              backgroundColor:
                  AppColors.whiteColor.withValues(alpha: 0.1),
              labelStyle: AppStyles.small.regular.white,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppStyles.small.regular.greyColor,
          border: InputBorder.none,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 16, color: AppColors.safetyBlue),
            Space.w8,
            Text(
              date != null
                  ? DateFormat('dd MMM yyyy').format(date)
                  : 'Select date',
              style: date != null
                  ? AppStyles.semiMedium.regular.white
                  : AppStyles.semiMedium.regular.greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isDob}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isDob
          ? (_dateOfBirth ?? DateTime(now.year - 30))
          : _joiningDate,
      firstDate: DateTime(1960),
      lastDate: now,
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
        if (isDob) {
          _dateOfBirth = picked;
        } else {
          _joiningDate = picked;
        }
      });
    }
  }

  void _submitTeacher() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date of birth'),
          backgroundColor: AppColors.safetyLightRed,
        ),
      );
      return;
    }

    final request = CreateTeacherRequest(
      employeeId: _employeeIdController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      gender: _gender,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      joiningDate: DateFormat('yyyy-MM-dd').format(_joiningDate),
      employeeType: _employeeType,
      designation: _designationController.text.trim(),
      department: _departmentController.text.trim().isNotEmpty
          ? _departmentController.text.trim()
          : null,
      highestQualification:
          _qualificationController.text.trim().isNotEmpty
              ? _qualificationController.text.trim()
              : null,
    );

    context.read<TeacherBloc>().add(CreateTeacher(request));
  }
}
