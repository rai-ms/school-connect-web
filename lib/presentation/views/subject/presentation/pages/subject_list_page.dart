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

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(const FetchSubjects());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<SubjectBloc>().state;
      if (state.hasMore && !state.isLoadingMore) {
        context.read<SubjectBloc>().add(
              FetchSubjects(page: state.currentPage + 1, loadMore: true),
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

  List<SubjectResponse> _applyTypeFilter(List<SubjectResponse> subjects) {
    if (_selectedTypeFilter == null) return subjects;
    return subjects
        .where((s) => s.type == _selectedTypeFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Subjects', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/subjects/add'),
        backgroundColor: AppColors.safetyBlue,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
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
                hintText: 'Search by name or code...',
                hintStyle: AppStyles.small.regular.greyColor,
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.greyColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.greyColor),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<SubjectBloc>()
                              .add(const FetchSubjects());
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context
                      .read<SubjectBloc>()
                      .add(SearchSubjects(query.trim()));
                }
              },
            ),
          ),
          Space.h8,

          // Type Filter Chips
          Padding(
            padding: AppPadding.padSH16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', null),
                  Space.w8,
                  _buildFilterChip('Core', 'CORE'),
                  Space.w8,
                  _buildFilterChip('Elective', 'ELECTIVE'),
                  Space.w8,
                  _buildFilterChip('Extra Curricular', 'EXTRA_CURRICULAR'),
                ],
              ),
            ),
          ),
          Space.h8,

          // Subject List
          Expanded(
            child: BlocBuilder<SubjectBloc, SubjectState>(
              builder: (context, state) {
                if (state.isLoading && state.subjects.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.safetyBlue),
                  );
                }

                final filteredSubjects = _applyTypeFilter(state.subjects);

                if (filteredSubjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_outlined,
                            size: 64,
                            color: AppColors.greyColor
                                .withValues(alpha: 0.5)),
                        Space.h16,
                        Text('No subjects found',
                            style: AppStyles.medium.regular.greyColor),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<SubjectBloc>()
                        .add(const FetchSubjects());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: AppPadding.padA16,
                    itemCount: filteredSubjects.length +
                        (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= filteredSubjects.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.safetyBlue,
                            ),
                          ),
                        );
                      }
                      return _buildSubjectCard(filteredSubjects[index]);
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

  Widget _buildFilterChip(String label, String? type) {
    final isSelected = _selectedTypeFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedTypeFilter = selected ? type : null;
        });
      },
      selectedColor: AppColors.safetyBlue,
      backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
      labelStyle: isSelected
          ? AppStyles.small.regular.white
          : AppStyles.small.regular.greyColor,
    );
  }

  Widget _buildSubjectCard(SubjectResponse subject) {
    final typeColor = _getTypeColor(subject.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/subjects/${subject.id}'),
        child: GlassyBackground(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: typeColor.withValues(alpha: 0.15),
                child: Text(subject.initials,
                    style:
                        AppStyles.semiMedium.bold.colored(typeColor)),
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Row(
                      children: [
                        Text(subject.code,
                            style: AppStyles.small.regular.greyColor),
                        Space.w8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            subject.typeLabel,
                            style: AppStyles.extraSmall.regular
                                .colored(typeColor),
                          ),
                        ),
                        if (subject.department != null) ...[
                          Space.w8,
                          Flexible(
                            child: Text(
                              subject.department!,
                              style: AppStyles.extraSmall.regular.greyColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (subject.creditHours != null)
                    Text('${subject.creditHours} hrs',
                        style: AppStyles.extraSmall.regular.greyColor),
                  Space.h4,
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: subject.isActive
                          ? AppColors.safetyGreen
                          : AppColors.greyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
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
