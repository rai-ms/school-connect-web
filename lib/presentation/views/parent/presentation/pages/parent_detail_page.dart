import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../manager/parent_bloc/parent_bloc.dart';

class ParentDetailPage extends StatefulWidget {
  final String parentId;
  const ParentDetailPage({super.key, required this.parentId});

  @override
  State<ParentDetailPage> createState() => _ParentDetailPageState();
}

class _ParentDetailPageState extends State<ParentDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(FetchParentById(widget.parentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Parent Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<ParentBloc, ParentState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedParent == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final parent = state.selectedParent;
          if (parent == null) {
            return Center(
              child: Text('Parent not found',
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
                      backgroundImage: parent.photoUrl != null
                          ? NetworkImage(parent.photoUrl!)
                          : null,
                      child: parent.photoUrl == null
                          ? Text(parent.initials,
                              style: AppStyles.large.bold
                                  .colored(AppColors.safetyBlue))
                          : null,
                    ),
                    Space.h12,
                    Text(parent.fullName,
                        style: AppStyles.large.bold.white),
                    Space.h4,
                    Text(parent.parentTypeDisplay,
                        style: AppStyles.small.regular.greyColor),
                    Space.h8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (parent.isActive
                                ? AppColors.safetyGreen
                                : AppColors.greyColor)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        parent.status,
                        style: AppStyles.extraSmall.bold.colored(
                            parent.isActive
                                ? AppColors.safetyGreen
                                : AppColors.greyColor),
                      ),
                    ),
                  ],
                ),
              ),

              Space.h16,

              // Contact Info
              _buildSection('Contact Information', [
                _buildInfoRow('Email', parent.email),
                if (parent.phone != null)
                  _buildInfoRow('Phone', parent.phone!),
                if (parent.alternatePhone != null)
                  _buildInfoRow('Alternate Phone', parent.alternatePhone!),
                if (parent.workPhone != null)
                  _buildInfoRow('Work Phone', parent.workPhone!),
              ]),

              Space.h12,

              // Personal Info
              _buildSection('Personal Information', [
                if (parent.gender != null)
                  _buildInfoRow('Gender', parent.gender!),
                if (parent.dateOfBirth != null)
                  _buildInfoRow('Date of Birth', parent.dateOfBirth!),
                if (parent.relationshipToStudent != null)
                  _buildInfoRow(
                      'Relationship', parent.relationshipToStudent!),
              ]),

              Space.h12,

              // Address
              if (parent.address != null) ...[
                _buildSection('Address', [
                  _buildInfoRow('Address', parent.address!),
                  if (parent.city != null)
                    _buildInfoRow('City', parent.city!),
                  if (parent.state != null)
                    _buildInfoRow('State', parent.state!),
                  if (parent.country != null)
                    _buildInfoRow('Country', parent.country!),
                  if (parent.postalCode != null)
                    _buildInfoRow('Postal Code', parent.postalCode!),
                ]),
                Space.h12,
              ],

              // Professional Info
              if (parent.occupation != null ||
                  parent.employer != null) ...[
                _buildSection('Professional Information', [
                  if (parent.occupation != null)
                    _buildInfoRow('Occupation', parent.occupation!),
                  if (parent.employer != null)
                    _buildInfoRow('Employer', parent.employer!),
                  if (parent.educationLevel != null)
                    _buildInfoRow(
                        'Education', parent.educationLevel!),
                ]),
                Space.h12,
              ],

              // Communication Preferences
              _buildSection('Preferences', [
                _buildInfoRow('Primary Contact',
                    parent.isPrimaryContact ? 'Yes' : 'No'),
                _buildInfoRow('Emergency Contact',
                    parent.isEmergencyContact ? 'Yes' : 'No'),
                _buildInfoRow('Can Pickup Child',
                    parent.canPickupChild ? 'Yes' : 'No'),
                _buildInfoRow('Portal Access',
                    parent.portalAccessEnabled ? 'Enabled' : 'Disabled'),
              ]),

              Space.h12,

              // Linked Students
              if (parent.linkedStudents.isNotEmpty) ...[
                _buildSection(
                  'Linked Students',
                  parent.linkedStudents.map((student) {
                    return _buildInfoRow(
                      student.fullName,
                      'Roll: ${student.rollNumber ?? '-'} (${student.relationship ?? '-'})',
                    );
                  }).toList(),
                ),
                Space.h12,
              ],

              // Notes
              if (parent.notes != null) ...[
                _buildSection('Notes', [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(parent.notes!,
                        style: AppStyles.small.regular.white),
                  ),
                ]),
                Space.h12,
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
            width: 130,
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
