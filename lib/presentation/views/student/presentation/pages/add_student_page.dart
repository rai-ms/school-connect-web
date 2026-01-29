import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/student_model.dart';
import '../manager/student_bloc/student_bloc.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _rollNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _classIdController = TextEditingController();
  final _sectionIdController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherPhoneController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  String _gender = 'MALE';
  DateTime? _dateOfBirth;
  DateTime _admissionDate = DateTime.now();

  @override
  void dispose() {
    _rollNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _classIdController.dispose();
    _sectionIdController.dispose();
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _motherNameController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Add Student', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is CreateStudent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Student added successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is CreateStudent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to add student'),
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
                        _buildTextField(_rollNumberController, 'Roll Number',
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
                        _buildTextField(_emailController, 'Email'),
                        Space.h12,
                        _buildTextField(_phoneController, 'Phone'),
                        Space.h12,
                        _buildTextField(_addressController, 'Address',
                            maxLines: 2),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Academic', style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  _classIdController, 'Class ID',
                                  required: true),
                            ),
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                  _sectionIdController, 'Section ID',
                                  required: true),
                            ),
                          ],
                        ),
                        Space.h12,
                        _buildDateField(
                          label: 'Admission Date',
                          date: _admissionDate,
                          onTap: () => _pickDate(isDob: false),
                        ),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Parent Info',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _fatherNameController, "Father's Name"),
                        Space.h12,
                        _buildTextField(
                            _fatherPhoneController, "Father's Phone"),
                        Space.h12,
                        _buildTextField(
                            _motherNameController, "Mother's Name"),
                      ],
                    ),
                  ),

                  Space.h16,
                  Text('Emergency Contact',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _emergencyNameController, 'Contact Name'),
                        Space.h12,
                        _buildTextField(
                            _emergencyPhoneController, 'Contact Phone'),
                      ],
                    ),
                  ),

                  Space.h24,
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              state.event is CreateStudent
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text('Add Student',
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
  }) {
    return TextFormField(
      controller: controller,
      style: AppStyles.semiMedium.regular.white,
      maxLines: maxLines,
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
              backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
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
          ? (_dateOfBirth ?? DateTime(now.year - 10))
          : _admissionDate,
      firstDate: DateTime(2000),
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
          _admissionDate = picked;
        }
      });
    }
  }

  void _submitStudent() {
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

    final request = CreateStudentRequest(
      rollNumber: _rollNumberController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      gender: _gender,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      currentClassId: _classIdController.text.trim(),
      currentSectionId: _sectionIdController.text.trim(),
      admissionDate: DateFormat('yyyy-MM-dd').format(_admissionDate),
      fatherInfo: _fatherNameController.text.trim().isNotEmpty
          ? {
              'name': _fatherNameController.text.trim(),
              if (_fatherPhoneController.text.trim().isNotEmpty)
                'phone': _fatherPhoneController.text.trim(),
            }
          : null,
      motherInfo: _motherNameController.text.trim().isNotEmpty
          ? {'name': _motherNameController.text.trim()}
          : null,
      emergencyContact:
          _emergencyNameController.text.trim().isNotEmpty
              ? {
                  'name': _emergencyNameController.text.trim(),
                  'relation': 'Guardian',
                  if (_emergencyPhoneController.text.trim().isNotEmpty)
                    'phone': _emergencyPhoneController.text.trim(),
                }
              : null,
    );

    context.read<StudentBloc>().add(CreateStudent(request));
  }
}
