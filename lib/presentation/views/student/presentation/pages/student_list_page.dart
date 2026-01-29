import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/student_model.dart';
import '../manager/student_bloc/student_bloc.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(const FetchStudents());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<StudentBloc>().state;
      if (state.hasMore && !state.isLoadingMore) {
        context.read<StudentBloc>().add(
              FetchStudents(page: state.currentPage + 1, loadMore: true),
            );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Students', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert, color: AppColors.whiteColor),
            tooltip: 'Bulk Operations',
            onPressed: () => context.push('/students/bulk-operations'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/students/add'),
        backgroundColor: AppColors.safetyBlue,
        child: const Icon(Icons.person_add, color: AppColors.whiteColor),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: AppPadding.padSH16,
            child: TextField(
              controller: _searchController,
              style: AppStyles.semiMedium.regular.white,
              decoration: InputDecoration(
                hintText: 'Search by name or roll number...',
                hintStyle: AppStyles.small.regular.greyColor,
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.greyColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.greyColor),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<StudentBloc>()
                              .add(const FetchStudents());
                        },
                      )
                    : null,
                filled: true,
                fillColor:
                    AppColors.whiteColor.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context
                      .read<StudentBloc>()
                      .add(SearchStudents(query.trim()));
                }
              },
            ),
          ),
          Space.h8,

          // Student List
          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state.isLoading && state.students.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.safetyBlue),
                  );
                }

                if (state.students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64,
                            color: AppColors.greyColor
                                .withValues(alpha: 0.5)),
                        Space.h16,
                        Text('No students found',
                            style: AppStyles.medium.regular.greyColor),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<StudentBloc>()
                        .add(const FetchStudents());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: AppPadding.padA16,
                    itemCount: state.students.length +
                        (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.students.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.safetyBlue,
                            ),
                          ),
                        );
                      }
                      return _buildStudentCard(state.students[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentResponse student) {
    final statusColor =
        student.isActive ? AppColors.safetyGreen : AppColors.greyColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/students/${student.id}'),
        child: GlassyBackground(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.safetyBlue.withValues(alpha: 0.15),
                backgroundImage: student.photoUrl != null
                    ? NetworkImage(student.photoUrl!)
                    : null,
                child: student.photoUrl == null
                    ? Text(student.initials,
                        style: AppStyles.semiMedium.bold
                            .colored(AppColors.safetyBlue))
                    : null,
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.fullName,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Row(
                      children: [
                        Text('Roll: ${student.rollNumber}',
                            style: AppStyles.small.regular.greyColor),
                        Space.w8,
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Space.w4,
                        Text(student.status,
                            style: AppStyles.extraSmall.regular
                                .colored(statusColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.greyColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
