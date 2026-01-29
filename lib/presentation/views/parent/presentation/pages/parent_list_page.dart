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

class ParentListPage extends StatefulWidget {
  const ParentListPage({super.key});

  @override
  State<ParentListPage> createState() => _ParentListPageState();
}

class _ParentListPageState extends State<ParentListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(const FetchParents());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ParentBloc>().state;
      if (state.hasMore && !state.isLoadingMore) {
        context.read<ParentBloc>().add(
              FetchParents(page: state.currentPage + 1, loadMore: true),
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
        title: Text('Parents / Guardians', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/parents/add'),
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
                hintText: 'Search by name, email, or phone...',
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
                              .read<ParentBloc>()
                              .add(const FetchParents());
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
                      .read<ParentBloc>()
                      .add(SearchParents(query.trim()));
                }
              },
            ),
          ),
          Space.h8,

          // Parent List
          Expanded(
            child: BlocBuilder<ParentBloc, ParentState>(
              builder: (context, state) {
                if (state.isLoading && state.parents.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.safetyBlue),
                  );
                }

                if (state.parents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.family_restroom,
                            size: 64,
                            color: AppColors.greyColor
                                .withValues(alpha: 0.5)),
                        Space.h16,
                        Text('No parents found',
                            style: AppStyles.medium.regular.greyColor),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ParentBloc>()
                        .add(const FetchParents());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: AppPadding.padA16,
                    itemCount: state.parents.length +
                        (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.parents.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.safetyBlue,
                            ),
                          ),
                        );
                      }
                      return _buildParentCard(state.parents[index]);
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

  Widget _buildParentCard(ParentResponse parent) {
    final statusColor =
        parent.isActive ? AppColors.safetyGreen : AppColors.greyColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/parents/${parent.id}'),
        child: GlassyBackground(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.safetyBlue.withValues(alpha: 0.15),
                backgroundImage: parent.photoUrl != null
                    ? NetworkImage(parent.photoUrl!)
                    : null,
                child: parent.photoUrl == null
                    ? Text(parent.initials,
                        style: AppStyles.semiMedium.bold
                            .colored(AppColors.safetyBlue))
                    : null,
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parent.fullName,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Row(
                      children: [
                        Text(parent.parentTypeDisplay,
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
                        Text(parent.status,
                            style: AppStyles.extraSmall.regular
                                .colored(statusColor)),
                        if (parent.linkedStudents.isNotEmpty) ...[
                          Space.w8,
                          Icon(Icons.link,
                              size: 14,
                              color: AppColors.greyColor
                                  .withValues(alpha: 0.7)),
                          Space.w4,
                          Text(
                              '${parent.linkedStudents.length} student${parent.linkedStudents.length > 1 ? 's' : ''}',
                              style: AppStyles.extraSmall.regular
                                  .greyColor),
                        ],
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
