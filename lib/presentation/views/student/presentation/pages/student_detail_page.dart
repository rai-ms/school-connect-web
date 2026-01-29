import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../manager/student_bloc/student_bloc.dart';

class StudentDetailPage extends StatefulWidget {
  final String studentId;
  const StudentDetailPage({super.key, required this.studentId});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(FetchStudentById(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Student Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedStudent == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final student = state.selectedStudent;
          if (student == null) {
            return Center(
              child: Text('Student not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Header
              GlassyBackground(
                borderColor: AppColors.safetyBlue.withValues(alpha: 0.3),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          AppColors.safetyBlue.withValues(alpha: 0.15),
                      backgroundImage: student.photoUrl != null
                          ? NetworkImage(student.photoUrl!)
                          : null,
                      child: student.photoUrl == null
                          ? Text(student.initials,
                              style: AppStyles.large.bold
                                  .colored(AppColors.safetyBlue))
                          : null,
                    ),
                    Space.h12,
                    Text(student.fullName,
                        style: AppStyles.large.bold.white),
                    Space.h4,
                    Text('Roll No: ${student.rollNumber}',
                        style: AppStyles.small.regular.greyColor),
                    Space.h8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (student.isActive
                                ? AppColors.safetyGreen
                                : AppColors.greyColor)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        student.status,
                        style: AppStyles.extraSmall.bold.colored(
                            student.isActive
                                ? AppColors.safetyGreen
                                : AppColors.greyColor),
                      ),
                    ),
                  ],
                ),
              ),

              Space.h16,

              // Personal Info
              _buildSection('Personal Information', [
                _buildInfoRow('Gender', student.gender),
                if (student.dateOfBirth != null)
                  _buildInfoRow('Date of Birth', student.dateOfBirth!),
                if (student.email != null)
                  _buildInfoRow('Email', student.email!),
                if (student.phone != null)
                  _buildInfoRow('Phone', student.phone!),
              ]),

              Space.h12,

              // Address
              if (student.address != null)
                _buildSection('Address', [
                  _buildInfoRow('Address', student.address!),
                  if (student.city != null)
                    _buildInfoRow('City', student.city!),
                  if (student.state != null)
                    _buildInfoRow('State', student.state!),
                  if (student.postalCode != null)
                    _buildInfoRow('Postal Code', student.postalCode!),
                ]),

              if (student.address != null) Space.h12,

              // Academic Info
              _buildSection('Academic Information', [
                if (student.admissionDate != null)
                  _buildInfoRow('Admission Date', student.admissionDate!),
              ]),

              Space.h12,

              // Parent Info
              if (student.fatherInfo != null)
                _buildSection('Father Information', [
                  _buildInfoRow(
                      'Name', student.fatherInfo!['name'] ?? '-'),
                  if (student.fatherInfo!['phone'] != null)
                    _buildInfoRow(
                        'Phone', student.fatherInfo!['phone']!),
                  if (student.fatherInfo!['occupation'] != null)
                    _buildInfoRow(
                        'Occupation', student.fatherInfo!['occupation']!),
                ]),

              if (student.motherInfo != null) ...[
                Space.h12,
                _buildSection('Mother Information', [
                  _buildInfoRow(
                      'Name', student.motherInfo!['name'] ?? '-'),
                  if (student.motherInfo!['phone'] != null)
                    _buildInfoRow(
                        'Phone', student.motherInfo!['phone']!),
                ]),
              ],

              Space.h30,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.semiMedium.bold.white),
        Space.h8,
        GlassyBackground(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppStyles.small.regular.greyColor),
          ),
          Expanded(
            child: Text(value, style: AppStyles.small.regular.white),
          ),
        ],
      ),
    );
  }
}
