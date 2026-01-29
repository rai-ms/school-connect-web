import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/exam_model.dart';
import '../manager/exam_bloc/exam_bloc.dart';

class ExamListPage extends StatefulWidget {
  const ExamListPage({super.key});

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final bloc = context.read<ExamBloc>();
    bloc.add(const FetchExams());
    bloc.add(const FetchUpcomingExams());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Exams', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.safetyBlue,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.greyColor,
          tabs: const [
            Tab(text: 'All Exams'),
            Tab(text: 'Upcoming'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RoutesName.createExam),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state.isLoading &&
              (state.event is FetchExams ||
                  state.event is FetchUpcomingExams)) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildExamList(state.exams, 'No exams found'),
              _buildExamList(state.upcomingExams, 'No upcoming exams'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExamList(List<ExamResponse> exams, String emptyMessage) {
    if (exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64, color: AppColors.greyColor.withValues(alpha: 0.5)),
            Space.h16,
            Text(emptyMessage, style: AppStyles.medium.regular.greyColor),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ExamBloc>().add(const FetchExams());
        context.read<ExamBloc>().add(const FetchUpcomingExams());
      },
      child: ListView.builder(
        padding: AppPadding.padA16,
        itemCount: exams.length,
        itemBuilder: (context, index) => _buildExamCard(exams[index]),
      ),
    );
  }

  Widget _buildExamCard(ExamResponse exam) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassyBackground(
        child: InkWell(
          onTap: () => context.pushNamed(
            RoutesName.examDetails,
            pathParameters: {'examId': exam.id},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exam.name,
                      style: AppStyles.medium.semiBold.white,
                    ),
                  ),
                  _buildStatusChip(exam.status),
                ],
              ),
              Space.h8,
              if (exam.subjectName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.book_outlined,
                          size: 14, color: AppColors.safetyLightBlue),
                      Space.w6,
                      Text(exam.subjectName!,
                          style: AppStyles.small.regular.colored(
                              AppColors.safetyLightBlue)),
                    ],
                  ),
                ),
              if (exam.examType != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.category_outlined,
                          size: 14, color: AppColors.safetyLightOrange),
                      Space.w6,
                      Text(exam.examType!.name,
                          style: AppStyles.small.regular.colored(
                              AppColors.safetyLightOrange)),
                    ],
                  ),
                ),
              Space.h8,
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: AppColors.greyColor),
                  Space.w6,
                  Text(
                    exam.examDate ?? 'TBD',
                    style: AppStyles.small.regular.greyColor,
                  ),
                  if (exam.startTime != null) ...[
                    Space.w12,
                    const Icon(Icons.access_time,
                        size: 14, color: AppColors.greyColor),
                    Space.w6,
                    Text(
                      '${exam.startTime}${exam.endTime != null ? ' - ${exam.endTime}' : ''}',
                      style: AppStyles.small.regular.greyColor,
                    ),
                  ],
                ],
              ),
              Space.h8,
              Row(
                children: [
                  _buildInfoChip(
                      Icons.grade, 'Max: ${exam.maxMarks}', AppColors.safetyBlue),
                  Space.w8,
                  _buildInfoChip(Icons.check_circle_outline,
                      'Pass: ${exam.passingMarks}', AppColors.safetyGreen),
                  if (exam.room != null) ...[
                    Space.w8,
                    _buildInfoChip(
                        Icons.room, exam.room!, AppColors.safetyOrange),
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
      case 'SCHEDULED':
        color = AppColors.safetyBlue;
        break;
      case 'IN_PROGRESS':
        color = AppColors.safetyOrange;
        break;
      case 'COMPLETED':
        color = AppColors.safetyGreen;
        break;
      case 'CANCELLED':
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
        status.replaceAll('_', ' '),
        style: AppStyles.extraSmall.medium.colored(color),
      ),
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
