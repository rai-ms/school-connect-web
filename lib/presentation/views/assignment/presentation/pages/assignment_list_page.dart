import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/assignment_model.dart';
import '../manager/assignment_bloc/assignment_bloc.dart';

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({super.key});

  @override
  State<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'ALL';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AssignmentBloc>().add(const FetchAssignments());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AssignmentResponse> _filterAssignments(
      List<AssignmentResponse> assignments) {
    var filtered = assignments;

    if (_selectedFilter != 'ALL') {
      filtered = filtered.where((a) => a.status == _selectedFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<AssignmentResponse> _filterByType(
      List<AssignmentResponse> assignments, String type) {
    if (type == 'ALL') return assignments;
    return assignments.where((a) => a.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Assignments', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.safetyBlue,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.greyColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Homework'),
            Tab(text: 'Projects'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.push(RoutesName.createAssignment),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppStyles.medium.regular.white,
              decoration: InputDecoration(
                hintText: 'Search assignments...',
                hintStyle: AppStyles.medium.regular.greyColor,
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.greyColor),
                filled: true,
                fillColor: AppColors.whiteColor.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['ALL', 'DRAFT', 'PUBLISHED', 'CLOSED']
                  .map((filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            filter == 'ALL' ? 'All Status' : filter,
                            style: AppStyles.small.medium.copyWith(
                              color: _selectedFilter == filter
                                  ? AppColors.whiteColor
                                  : AppColors.greyColor,
                            ),
                          ),
                          selected: _selectedFilter == filter,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = filter),
                          selectedColor: AppColors.safetyBlue,
                          backgroundColor:
                              AppColors.whiteColor.withValues(alpha: 0.1),
                          checkmarkColor: AppColors.whiteColor,
                          side: BorderSide.none,
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Content
          Expanded(
            child: BlocBuilder<AssignmentBloc, AssignmentState>(
              builder: (context, state) {
                if (state.isLoading && state.event is FetchAssignments) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.safetyBlue),
                  );
                }

                final allFiltered = _filterAssignments(state.assignments);

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAssignmentList(allFiltered, 'No assignments found'),
                    _buildAssignmentList(
                        _filterByType(allFiltered, 'HOMEWORK'),
                        'No homework found'),
                    _buildAssignmentList(
                        _filterByType(allFiltered, 'PROJECT'),
                        'No projects found'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentList(
      List<AssignmentResponse> assignments, String emptyMessage) {
    if (assignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64,
                color: AppColors.greyColor.withValues(alpha: 0.5)),
            Space.h16,
            Text(emptyMessage, style: AppStyles.medium.regular.greyColor),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AssignmentBloc>().add(const FetchAssignments());
      },
      child: ListView.builder(
        padding: AppPadding.padA16,
        itemCount: assignments.length,
        itemBuilder: (context, index) =>
            _buildAssignmentCard(assignments[index]),
      ),
    );
  }

  Widget _buildAssignmentCard(AssignmentResponse assignment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassyBackground(
        child: InkWell(
          onTap: () => context.push(
            RoutesName.assignmentDetails
                .replaceFirst(':assignmentId', assignment.id),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: AppStyles.medium.semiBold.white,
                    ),
                  ),
                  _buildStatusChip(assignment.status),
                ],
              ),
              Space.h8,
              if (assignment.description != null &&
                  assignment.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    assignment.description!,
                    style: AppStyles.small.regular.copyWith(
                      color: AppColors.whiteColor.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Row(
                children: [
                  _buildTypeChip(assignment.type),
                  Space.w8,
                  const Icon(Icons.calendar_today,
                      size: 14, color: AppColors.greyColor),
                  Space.w6,
                  Text(
                    'Due: ${assignment.dueDate ?? 'TBD'}',
                    style: AppStyles.small.regular.copyWith(
                      color: assignment.isOverdue
                          ? AppColors.safetyRed
                          : AppColors.greyColor,
                    ),
                  ),
                ],
              ),
              Space.h8,
              Row(
                children: [
                  _buildInfoChip(Icons.grade, 'Max: ${assignment.maxMarks}',
                      AppColors.safetyBlue),
                  if (assignment.assignedDate != null) ...[
                    Space.w8,
                    _buildInfoChip(Icons.date_range,
                        'Assigned: ${assignment.assignedDate}', AppColors.safetyGreen),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'DRAFT':
        color = AppColors.greyColor;
        break;
      case 'PUBLISHED':
        color = AppColors.safetyGreen;
        break;
      case 'CLOSED':
        color = AppColors.safetyRed;
        break;
      default:
        color = AppColors.greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: AppStyles.extraSmall.medium.colored(color),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    Color color;
    IconData icon;
    switch (type.toUpperCase()) {
      case 'HOMEWORK':
        color = AppColors.safetyBlue;
        icon = Icons.home_work;
        break;
      case 'CLASSWORK':
        color = AppColors.safetyOrange;
        icon = Icons.class_;
        break;
      case 'PROJECT':
        color = AppColors.purple;
        icon = Icons.folder_special;
        break;
      default:
        color = AppColors.greyColor;
        icon = Icons.assignment;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(type, style: AppStyles.extraSmall.medium.colored(color)),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppStyles.extraSmall.regular.colored(color)),
      ],
    );
  }
}
