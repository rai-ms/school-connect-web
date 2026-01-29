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

class SubjectDetailPage extends StatefulWidget {
  final String subjectId;
  const SubjectDetailPage({super.key, required this.subjectId});

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(FetchSubjectById(widget.subjectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Subject Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          BlocBuilder<SubjectBloc, SubjectState>(
            builder: (context, state) {
              if (state.selectedSubject == null) return const SizedBox();
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.whiteColor),
                color: AppColors.darkGunMetal,
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/subjects/add',
                        extra: state.selectedSubject);
                  } else if (value == 'delete') {
                    _showDeleteDialog(state.selectedSubject!);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit,
                            color: AppColors.safetyBlue, size: 18),
                        Space.w8,
                        Text('Edit',
                            style: AppStyles.semiMedium.regular.white),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete,
                            color: AppColors.safetyLightRed, size: 18),
                        Space.w8,
                        Text('Delete',
                            style: AppStyles.semiMedium.regular
                                .colored(AppColors.safetyLightRed)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state.actionCompleted &&
              state.event is DeleteSubjectEvent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subject deleted successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is DeleteSubjectEvent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.error ?? 'Failed to delete subject'),
                backgroundColor: AppColors.safetyLightRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.selectedSubject == null) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.safetyBlue),
            );
          }

          final subject = state.selectedSubject;
          if (subject == null) {
            return Center(
              child: Text('Subject not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          final typeColor = _getTypeColor(subject.type);

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Header
              GlassyBackground(
                borderColor: typeColor.withValues(alpha: 0.3),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: typeColor.withValues(alpha: 0.15),
                      child: Text(subject.initials,
                          style:
                              AppStyles.large.bold.colored(typeColor)),
                    ),
                    Space.h12,
                    Text(subject.name,
                        style: AppStyles.large.bold.white),
                    Space.h4,
                    Text(subject.code,
                        style: AppStyles.small.regular.greyColor),
                    Space.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subject.typeLabel,
                            style: AppStyles.extraSmall.bold
                                .colored(typeColor),
                          ),
                        ),
                        Space.w8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: (subject.isActive
                                    ? AppColors.safetyGreen
                                    : AppColors.greyColor)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subject.isActive ? 'Active' : 'Inactive',
                            style: AppStyles.extraSmall.bold.colored(
                                subject.isActive
                                    ? AppColors.safetyGreen
                                    : AppColors.greyColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Space.h16,

              // Basic Information
              _buildSection('Basic Information', [
                if (subject.description != null)
                  _buildInfoRow('Description', subject.description!),
                if (subject.department != null)
                  _buildInfoRow('Department', subject.department!),
                if (subject.academicYear != null)
                  _buildInfoRow('Academic Year', subject.academicYear!),
              ]),

              Space.h12,

              // Academic Details
              _buildSection('Academic Details', [
                if (subject.creditHours != null)
                  _buildInfoRow(
                      'Credit Hours', '${subject.creditHours}'),
                if (subject.maxMarks != null)
                  _buildInfoRow('Max Marks', '${subject.maxMarks}'),
                if (subject.passingMarks != null)
                  _buildInfoRow(
                      'Passing Marks', '${subject.passingMarks}'),
              ]),

              if (subject.prerequisites.isNotEmpty) ...[
                Space.h12,
                _buildSection('Prerequisites', [
                  ...subject.prerequisites
                      .map((p) => _buildInfoRow('', p)),
                ]),
              ],

              if (subject.learningObjectives.isNotEmpty) ...[
                Space.h12,
                _buildSection('Learning Objectives', [
                  ...subject.learningObjectives.asMap().entries.map(
                        (entry) => _buildInfoRow(
                            '${entry.key + 1}.', entry.value),
                      ),
                ]),
              ],

              Space.h30,
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(SubjectResponse subject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkGunMetal,
        title: Text('Delete Subject',
            style: AppStyles.medium.bold.white),
        content: Text(
          'Are you sure you want to delete "${subject.name}"? This action cannot be undone.',
          style: AppStyles.semiMedium.regular.greyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppStyles.semiMedium.regular.greyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<SubjectBloc>()
                  .add(DeleteSubjectEvent(subject.id));
            },
            child: Text('Delete',
                style: AppStyles.semiMedium.bold
                    .colored(AppColors.safetyLightRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final filteredChildren =
        children.where((w) => w is! SizedBox).toList();
    if (filteredChildren.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.semiMedium.bold.white),
        Space.h8,
        GlassyBackground(
          child: Column(children: filteredChildren),
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
          if (label.isNotEmpty)
            SizedBox(
              width: 120,
              child:
                  Text(label, style: AppStyles.small.regular.greyColor),
            ),
          Expanded(
            child: Text(value, style: AppStyles.small.regular.white),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'CORE':
        return AppColors.safetyBlue;
      case 'ELECTIVE':
        return AppColors.selectiveYellow;
      case 'EXTRA_CURRICULAR':
        return AppColors.greenCyan;
      default:
        return AppColors.safetyBlue;
    }
  }
}
