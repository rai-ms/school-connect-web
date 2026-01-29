import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../manager/teacher_bloc/teacher_bloc.dart';

class TeacherDetailPage extends StatefulWidget {
  final String teacherId;
  const TeacherDetailPage({super.key, required this.teacherId});

  @override
  State<TeacherDetailPage> createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(FetchTeacherById(widget.teacherId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Teacher Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedTeacher == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final teacher = state.selectedTeacher;
          if (teacher == null) {
            return Center(
              child: Text('Teacher not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Header
              GlassyBackground(
                borderColor: AppColors.verdigris.withValues(alpha: 0.3),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          AppColors.verdigris.withValues(alpha: 0.15),
                      backgroundImage: teacher.photoUrl != null
                          ? NetworkImage(teacher.photoUrl!)
                          : null,
                      child: teacher.photoUrl == null
                          ? Text(teacher.initials,
                              style: AppStyles.large.bold
                                  .colored(AppColors.verdigris))
                          : null,
                    ),
                    Space.h12,
                    Text(teacher.fullName,
                        style: AppStyles.large.bold.white),
                    Space.h4,
                    Text('Employee ID: ${teacher.employeeId}',
                        style: AppStyles.small.regular.greyColor),
                    if (teacher.designation != null) ...[
                      Space.h4,
                      Text(teacher.designation!,
                          style: AppStyles.small.regular
                              .colored(AppColors.verdigris)),
                    ],
                    Space.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: (teacher.isActive
                                    ? AppColors.safetyGreen
                                    : AppColors.greyColor)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            teacher.status,
                            style: AppStyles.extraSmall.bold.colored(
                                teacher.isActive
                                    ? AppColors.safetyGreen
                                    : AppColors.greyColor),
                          ),
                        ),
                        if (teacher.isClassTeacher) ...[
                          Space.w8,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.selectiveYellow
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Class Teacher',
                                style: AppStyles.extraSmall.bold.colored(
                                    AppColors.selectiveYellow)),
                          ),
                        ],
                      ],
                    ),
                    if (teacher.rating != null) ...[
                      Space.h8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(5, (i) {
                            return Icon(
                              i < teacher.rating!.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 18,
                              color: AppColors.selectiveYellow,
                            );
                          }),
                          Space.w4,
                          Text(
                            teacher.rating!.toStringAsFixed(1),
                            style: AppStyles.small.regular.greyColor,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              Space.h16,

              // Personal Info
              _buildSection('Personal Information', [
                _buildInfoRow('Gender', teacher.gender),
                if (teacher.dateOfBirth != null)
                  _buildInfoRow('Date of Birth', teacher.dateOfBirth!),
                if (teacher.email != null)
                  _buildInfoRow('Email', teacher.email!),
                if (teacher.phone != null)
                  _buildInfoRow('Phone', teacher.phone!),
              ]),

              Space.h12,

              // Professional Info
              _buildSection('Professional Information', [
                if (teacher.employeeType != null)
                  _buildInfoRow('Employee Type', teacher.employeeType!),
                if (teacher.department != null)
                  _buildInfoRow('Department', teacher.department!),
                if (teacher.joiningDate != null)
                  _buildInfoRow('Joining Date', teacher.joiningDate!),
                if (teacher.highestQualification != null)
                  _buildInfoRow(
                      'Qualification', teacher.highestQualification!),
                if (teacher.experienceYears != null)
                  _buildInfoRow('Experience',
                      '${teacher.experienceYears} years'),
              ]),

              if (teacher.subjects.isNotEmpty) ...[
                Space.h12,
                _buildSection('Subjects', [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: teacher.subjects.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.safetyBlue
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s,
                            style: AppStyles.small.regular
                                .colored(AppColors.safetyBlue)),
                      );
                    }).toList(),
                  ),
                ]),
              ],

              if (teacher.address != null) ...[
                Space.h12,
                _buildSection('Address', [
                  _buildInfoRow('Address', teacher.address!),
                  if (teacher.city != null)
                    _buildInfoRow('City', teacher.city!),
                  if (teacher.state != null)
                    _buildInfoRow('State', teacher.state!),
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
