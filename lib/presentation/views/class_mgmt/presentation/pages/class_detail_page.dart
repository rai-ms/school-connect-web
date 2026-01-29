import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/class_model.dart';
import '../manager/class_bloc/class_bloc.dart';

class ClassDetailPage extends StatefulWidget {
  final String classId;
  const ClassDetailPage({super.key, required this.classId});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClassBloc>().add(FetchClassById(widget.classId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Class Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSectionDialog,
        backgroundColor: AppColors.safetyGreen,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedClass == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final cls = state.selectedClass;
          if (cls == null) {
            return Center(
              child: Text('Class not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Class Info
              GlassyBackground(
                borderColor: AppColors.safetyBlue.withValues(alpha: 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.safetyBlue
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(cls.code,
                                style: AppStyles.large.bold
                                    .colored(AppColors.safetyBlue)),
                          ),
                        ),
                        Space.w12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cls.displayName,
                                  style: AppStyles.large.bold.white),
                              if (cls.description != null)
                                Text(cls.description!,
                                    style:
                                        AppStyles.small.regular.greyColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Space.h16,
                    Row(
                      children: [
                        _buildInfoChip(Icons.grid_view,
                            '${cls.sections.length} Sections'),
                        Space.w12,
                        _buildInfoChip(Icons.people,
                            'Capacity: ${cls.totalCapacity}'),
                      ],
                    ),
                  ],
                ),
              ),

              Space.h20,

              // Sections
              Text('Sections', style: AppStyles.semiMedium.bold.white),
              Space.h8,

              if (cls.sections.isEmpty)
                GlassyBackground(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox,
                            size: 32,
                            color: AppColors.greyColor
                                .withValues(alpha: 0.5)),
                        Space.h8,
                        Text('No sections yet',
                            style: AppStyles.small.regular.greyColor),
                      ],
                    ),
                  ),
                )
              else
                ...cls.sections.map(_buildSectionCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.safetyBlue),
          Space.w4,
          Text(label, style: AppStyles.extraSmall.regular.greyColor),
        ],
      ),
    );
  }

  Widget _buildSectionCard(SectionResponse section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassyBackground(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.safetyGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(section.name,
                    style: AppStyles.semiMedium.bold
                        .colored(AppColors.safetyGreen)),
              ),
            ),
            Space.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Section ${section.name}',
                      style: AppStyles.semiMedium.semiBold.white),
                  if (section.capacity != null)
                    Text('Capacity: ${section.capacity}',
                        style: AppStyles.small.regular.greyColor),
                ],
              ),
            ),
            if (section.classTeacherName != null)
              Row(
                children: [
                  Icon(Icons.person,
                      size: 14, color: AppColors.safetyBlue),
                  Space.w4,
                  Text(section.classTeacherName!,
                      style: AppStyles.extraSmall.regular
                          .colored(AppColors.safetyBlue)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showAddSectionDialog() {
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '40');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3A),
        title: Text('Add Section', style: AppStyles.medium.bold.white),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: AppStyles.small.regular.white,
              decoration: InputDecoration(
                labelText: 'Section Name (e.g., B)',
                labelStyle: AppStyles.small.regular.greyColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Space.h12,
            TextField(
              controller: capacityController,
              style: AppStyles.small.regular.white,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capacity',
                labelStyle: AppStyles.small.regular.greyColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppStyles.small.regular.greyColor),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              context.read<ClassBloc>().add(CreateSection(
                    CreateSectionRequest(
                      name: nameController.text.trim(),
                      capacity: int.tryParse(capacityController.text),
                      schoolClassId: widget.classId,
                    ),
                  ));
              // Refresh class details
              context
                  .read<ClassBloc>()
                  .add(FetchClassById(widget.classId));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyGreen),
            child: Text('Add', style: AppStyles.small.bold.white),
          ),
        ],
      ),
    );
  }
}
