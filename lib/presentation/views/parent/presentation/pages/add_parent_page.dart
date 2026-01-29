import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/parent_model.dart';
import '../manager/parent_bloc/parent_bloc.dart';

class AddParentPage extends StatefulWidget {
  const AddParentPage({super.key});

  @override
  State<AddParentPage> createState() => _AddParentPageState();
}

class _AddParentPageState extends State<AddParentPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  final _educationController = TextEditingController();
  final _relationshipController = TextEditingController();

  String _parentType = 'FATHER';
  String _gender = 'MALE';
  bool _isPrimaryContact = false;
  bool _isEmergencyContact = false;

  static const List<String> _parentTypes = [
    'FATHER',
    'MOTHER',
    'GUARDIAN',
    'GRANDFATHER',
    'GRANDMOTHER',
    'UNCLE',
    'AUNT',
    'OTHER',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _educationController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Add Parent / Guardian',
            style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<ParentBloc, ParentState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is CreateParent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Parent added successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is CreateParent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to add parent'),
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
                  // Basic Information
                  Text('Basic Information',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
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
                        _buildParentTypeSelector(),
                        Space.h12,
                        _buildGenderSelector(),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Contact Information
                  Text('Contact Information',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_emailController, 'Email',
                            required: true),
                        Space.h12,
                        _buildTextField(_phoneController, 'Phone',
                            required: true),
                        Space.h12,
                        _buildTextField(
                            _alternatePhoneController, 'Alternate Phone'),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Address
                  Text('Address', style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_addressController, 'Address',
                            maxLines: 2),
                        Space.h12,
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  _cityController, 'City'),
                            ),
                            Space.w12,
                            Expanded(
                              child: _buildTextField(
                                  _stateController, 'State'),
                            ),
                          ],
                        ),
                        Space.h12,
                        _buildTextField(
                            _postalCodeController, 'Postal Code'),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Professional Information
                  Text('Professional Information',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _occupationController, 'Occupation'),
                        Space.h12,
                        _buildTextField(
                            _employerController, 'Employer'),
                        Space.h12,
                        _buildTextField(
                            _educationController, 'Education Level'),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Relationship & Preferences
                  Text('Relationship & Preferences',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_relationshipController,
                            'Relationship to Student'),
                        Space.h12,
                        _buildSwitchRow(
                          'Primary Contact',
                          _isPrimaryContact,
                          (value) =>
                              setState(() => _isPrimaryContact = value),
                        ),
                        Space.h8,
                        _buildSwitchRow(
                          'Emergency Contact',
                          _isEmergencyContact,
                          (value) =>
                              setState(() => _isEmergencyContact = value),
                        ),
                      ],
                    ),
                  ),

                  Space.h24,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitParent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              state.event is CreateParent
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text('Add Parent',
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
          ? (v) =>
              v == null || v.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildParentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parent Type', style: AppStyles.small.regular.greyColor),
        Space.h4,
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _parentTypes.map((type) {
            return ChoiceChip(
              label: Text(type[0] + type.substring(1).toLowerCase()),
              selected: _parentType == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _parentType = type;
                    if (type == 'FATHER' ||
                        type == 'GRANDFATHER' ||
                        type == 'UNCLE') {
                      _gender = 'MALE';
                    } else if (type == 'MOTHER' ||
                        type == 'GRANDMOTHER' ||
                        type == 'AUNT') {
                      _gender = 'FEMALE';
                    }
                  });
                }
              },
              selectedColor: AppColors.safetyBlue,
              backgroundColor:
                  AppColors.whiteColor.withValues(alpha: 0.1),
              labelStyle: AppStyles.small.regular.white,
            );
          }).toList(),
        ),
      ],
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

  Widget _buildSwitchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.semiMedium.regular.white),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.safetyBlue,
        ),
      ],
    );
  }

  void _submitParent() {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateParentRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      parentType: _parentType,
      gender: _gender,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      alternatePhone: _alternatePhoneController.text.trim().isNotEmpty
          ? _alternatePhoneController.text.trim()
          : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      city: _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : null,
      state: _stateController.text.trim().isNotEmpty
          ? _stateController.text.trim()
          : null,
      postalCode: _postalCodeController.text.trim().isNotEmpty
          ? _postalCodeController.text.trim()
          : null,
      occupation: _occupationController.text.trim().isNotEmpty
          ? _occupationController.text.trim()
          : null,
      employer: _employerController.text.trim().isNotEmpty
          ? _employerController.text.trim()
          : null,
      educationLevel: _educationController.text.trim().isNotEmpty
          ? _educationController.text.trim()
          : null,
      relationshipToStudent:
          _relationshipController.text.trim().isNotEmpty
              ? _relationshipController.text.trim()
              : null,
      isPrimaryContact: _isPrimaryContact,
      isEmergencyContact: _isEmergencyContact,
    );

    context.read<ParentBloc>().add(CreateParent(request));
  }
}
