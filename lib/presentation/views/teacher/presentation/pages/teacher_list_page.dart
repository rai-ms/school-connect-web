import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/teacher_model.dart';
import '../manager/teacher_bloc/teacher_bloc.dart';

class TeacherListPage extends StatefulWidget {
  const TeacherListPage({super.key});

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(const FetchTeachers());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TeacherBloc>().state;
      if (state.hasMore && !state.isLoadingMore) {
        context.read<TeacherBloc>().add(
              FetchTeachers(page: state.currentPage + 1, loadMore: true),
            );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Teachers', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/teachers/add'),
        backgroundColor: AppColors.safetyBlue,
        child: const Icon(Icons.person_add, color: AppColors.whiteColor),
      ),
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state.isLoading && state.teachers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (state.teachers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined,
                      size: 64,
                      color: AppColors.greyColor.withValues(alpha: 0.5)),
                  Space.h16,
                  Text('No teachers found',
                      style: AppStyles.medium.regular.greyColor),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TeacherBloc>().add(const FetchTeachers());
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: AppPadding.padA16,
              itemCount:
                  state.teachers.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.teachers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.safetyBlue,
                      ),
                    ),
                  );
                }
                return _buildTeacherCard(state.teachers[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeacherCard(TeacherResponse teacher) {
    final statusColor =
        teacher.isActive ? AppColors.safetyGreen : AppColors.greyColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/teachers/${teacher.id}'),
        child: GlassyBackground(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.verdigris.withValues(alpha: 0.15),
                backgroundImage: teacher.photoUrl != null
                    ? NetworkImage(teacher.photoUrl!)
                    : null,
                child: teacher.photoUrl == null
                    ? Text(teacher.initials,
                        style: AppStyles.semiMedium.bold
                            .colored(AppColors.verdigris))
                    : null,
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teacher.fullName,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Row(
                      children: [
                        if (teacher.designation != null) ...[
                          Text(teacher.designation!,
                              style: AppStyles.small.regular.greyColor),
                          Space.w8,
                        ],
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Space.w4,
                        Text(teacher.status,
                            style: AppStyles.extraSmall.regular
                                .colored(statusColor)),
                      ],
                    ),
                    if (teacher.subjects.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          teacher.subjects.join(', '),
                          style: AppStyles.extraSmall.regular
                              .colored(AppColors.safetyBlue),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              if (teacher.isClassTeacher)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.selectiveYellow
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('CT',
                      style: AppStyles.extraSmall.bold
                          .colored(AppColors.selectiveYellow)),
                ),
              Space.w4,
              const Icon(Icons.chevron_right,
                  color: AppColors.greyColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
