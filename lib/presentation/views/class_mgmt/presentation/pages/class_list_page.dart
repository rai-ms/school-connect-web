import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/class_model.dart';
import '../manager/class_bloc/class_bloc.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClassBloc>().add(const FetchAllClasses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Classes', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassDialog,
        backgroundColor: AppColors.safetyBlue,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: BlocConsumer<ClassBloc, ClassState>(
        listener: (context, state) {
          if (state.actionCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Class created successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.classes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (state.classes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.class_,
                      size: 64,
                      color: AppColors.greyColor.withValues(alpha: 0.5)),
                  Space.h16,
                  Text('No classes yet',
                      style: AppStyles.medium.regular.greyColor),
                  Space.h8,
                  Text('Tap + to add a class',
                      style: AppStyles.small.regular
                          .colored(AppColors.safetyBlue)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClassBloc>().add(const FetchAllClasses());
            },
            child: ListView.builder(
              padding: AppPadding.padA16,
              itemCount: state.classes.length,
              itemBuilder: (context, index) =>
                  _buildClassCard(state.classes[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClassCard(SchoolClassResponse cls) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/classes/${cls.id}'),
        child: GlassyBackground(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.safetyBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(cls.code,
                      style: AppStyles.semiMedium.bold
                          .colored(AppColors.safetyBlue)),
                ),
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cls.displayName,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Text(
                      '${cls.sections.length} section(s)',
                      style: AppStyles.small.regular.greyColor,
                    ),
                  ],
                ),
              ),
              if (cls.sections.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: cls.sections.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            AppColors.safetyGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(s.name,
                          style: AppStyles.extraSmall.bold
                              .colored(AppColors.safetyGreen)),
                    );
                  }).toList(),
                ),
              Space.w8,
              const Icon(Icons.chevron_right,
                  color: AppColors.greyColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddClassDialog() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3A),
        title: Text('Add Class', style: AppStyles.medium.bold.white),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              style: AppStyles.small.regular.white,
              decoration: InputDecoration(
                labelText: 'Code (e.g., 10)',
                labelStyle: AppStyles.small.regular.greyColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Space.h12,
            TextField(
              controller: nameController,
              style: AppStyles.small.regular.white,
              decoration: InputDecoration(
                labelText: 'Name (e.g., Class 10)',
                labelStyle: AppStyles.small.regular.greyColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Space.h12,
            TextField(
              controller: descController,
              style: AppStyles.small.regular.white,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
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
              if (codeController.text.trim().isEmpty ||
                  nameController.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(ctx);
              context.read<ClassBloc>().add(CreateSchoolClass(
                    CreateClassRequest(
                      code: codeController.text.trim(),
                      name: nameController.text.trim(),
                      description: descController.text.trim().isNotEmpty
                          ? descController.text.trim()
                          : null,
                      sections: [CreateSectionRequest(name: 'A')],
                    ),
                  ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyBlue),
            child: Text('Create', style: AppStyles.small.bold.white),
          ),
        ],
      ),
    );
  }
}
