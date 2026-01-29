import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart' show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/timetable_entry_model.dart';
import '../manager/timetable_bloc/timetable_bloc.dart';

class TimetablePage extends StatefulWidget {
  final String classId;
  final String? teacherId;
  final bool isTeacherView;

  const TimetablePage({
    super.key,
    required this.classId,
    this.teacherId,
    this.isTeacherView = false,
  });

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  static const List<String> _days = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'
  ];

  static const List<String> _shortDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];

  int _selectedDayIndex = 0;
  bool _isWeeklyView = false;

  @override
  void initState() {
    super.initState();
    // Set current day as default
    final now = DateTime.now();
    _selectedDayIndex = (now.weekday - 1).clamp(0, 5);

    final bloc = context.read<TimetableBloc>();
    bloc.add(const FetchPeriods());
    if (widget.isTeacherView && widget.teacherId != null) {
      bloc.add(FetchTeacherWeeklyTimetable(widget.teacherId!));
    } else {
      bloc.add(FetchClassWeeklyTimetable(widget.classId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text(
          widget.isTeacherView ? 'My Timetable' : 'Class Timetable',
          style: AppStyles.large.bold.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isWeeklyView = !_isWeeklyView),
            icon: Icon(
              _isWeeklyView ? Icons.view_day : Icons.view_week,
              color: AppColors.whiteColor,
            ),
            tooltip: _isWeeklyView ? 'Day View' : 'Week View',
          ),
        ],
      ),
      body: BlocBuilder<TimetableBloc, TimetableState>(
        builder: (context, state) {
          if (state.isLoading && state.weeklyTimetable.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (_isWeeklyView) {
            return _buildWeeklyView(state);
          }
          return _buildDayView(state);
        },
      ),
    );
  }

  Widget _buildDayView(TimetableState state) {
    return Column(
      children: [
        // Day Selector
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedDayIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(_shortDays[index]),
                  selected: isSelected,
                  selectedColor: AppColors.safetyBlue,
                  backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
                  labelStyle: isSelected
                      ? AppStyles.small.semiBold.white
                      : AppStyles.small.regular.greyColor,
                  onSelected: (_) => setState(() => _selectedDayIndex = index),
                ),
              );
            },
          ),
        ),
        Space.h12,
        // Day Entries
        Expanded(
          child: _buildDayEntries(
            state.weeklyTimetable[_days[_selectedDayIndex]] ?? [],
            state.periods,
          ),
        ),
      ],
    );
  }

  Widget _buildDayEntries(
      List<TimetableEntryResponse> entries, List periods) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy,
                size: 64,
                color: AppColors.greyColor.withValues(alpha: 0.5)),
            Space.h16,
            Text('No classes scheduled',
                style: AppStyles.medium.regular.greyColor),
            Space.h4,
            Text(_days[_selectedDayIndex],
                style: AppStyles.small.regular
                    .colored(AppColors.safetyBlue)),
          ],
        ),
      );
    }

    // Sort by period number
    final sorted = List<TimetableEntryResponse>.from(entries)
      ..sort((a, b) =>
          (a.period?.periodNumber ?? 0).compareTo(b.period?.periodNumber ?? 0));

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.isTeacherView && widget.teacherId != null) {
          context
              .read<TimetableBloc>()
              .add(FetchTeacherWeeklyTimetable(widget.teacherId!));
        } else {
          context
              .read<TimetableBloc>()
              .add(FetchClassWeeklyTimetable(widget.classId));
        }
      },
      child: ListView.builder(
        padding: AppPadding.padA16,
        itemCount: sorted.length,
        itemBuilder: (context, index) => _buildEntryCard(sorted[index]),
      ),
    );
  }

  Widget _buildEntryCard(TimetableEntryResponse entry) {
    final period = entry.period;
    final isBreak = period?.isBreak ?? false;
    final color = isBreak ? AppColors.safetyOrange : _getSubjectColor(entry.subjectName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassyBackground(
        borderColor: color.withValues(alpha: 0.3),
        child: Row(
          children: [
            // Period Number & Time
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  if (period != null) ...[
                    Text(
                      isBreak ? 'Break' : 'P${period.periodNumber}',
                      style: AppStyles.small.bold.colored(color),
                    ),
                    Space.h4,
                    Text(
                      period.startTime.substring(0, 5),
                      style: AppStyles.extraSmall.regular.greyColor,
                    ),
                    Text(
                      period.endTime.substring(0, 5),
                      style: AppStyles.extraSmall.regular.greyColor,
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 2,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            // Entry Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBreak ? 'Break' : (entry.subjectName ?? 'Subject'),
                    style: AppStyles.semiMedium.semiBold.white,
                  ),
                  if (!isBreak) ...[
                    if (entry.teacherName != null) ...[
                      Space.h4,
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 14, color: AppColors.safetyLightBlue),
                          Space.w4,
                          Text(entry.teacherName!,
                              style: AppStyles.extraSmall.regular
                                  .colored(AppColors.safetyLightBlue)),
                        ],
                      ),
                    ],
                    if (entry.room != null) ...[
                      Space.h4,
                      Row(
                        children: [
                          const Icon(Icons.room_outlined,
                              size: 14, color: AppColors.safetyLightOrange),
                          Space.w4,
                          Text(entry.room!,
                              style: AppStyles.extraSmall.regular
                                  .colored(AppColors.safetyLightOrange)),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyView(TimetableState state) {
    return SingleChildScrollView(
      padding: AppPadding.padA12,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_days.length, (dayIndex) {
            final dayEntries =
                state.weeklyTimetable[_days[dayIndex]] ?? [];
            final sorted = List<TimetableEntryResponse>.from(dayEntries)
              ..sort((a, b) => (a.period?.periodNumber ?? 0)
                  .compareTo(b.period?.periodNumber ?? 0));

            return Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  // Day Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.safetyBlue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _shortDays[dayIndex],
                      textAlign: TextAlign.center,
                      style: AppStyles.small.bold.white,
                    ),
                  ),
                  Space.h8,
                  // Period entries
                  if (sorted.isEmpty)
                    Padding(
                      padding: AppPadding.padSV12,
                      child: Text('--',
                          style: AppStyles.small.regular.greyColor),
                    )
                  else
                    ...sorted.map((entry) => _buildWeeklyCell(entry)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWeeklyCell(TimetableEntryResponse entry) {
    final isBreak = entry.period?.isBreak ?? false;
    final color = isBreak ? AppColors.safetyOrange : _getSubjectColor(entry.subjectName);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.period != null)
            Text(
              entry.period!.startTime.substring(0, 5),
              style: AppStyles.extraSmall.regular.greyColor,
            ),
          Text(
            isBreak ? 'Break' : (entry.subjectName ?? '-'),
            style: AppStyles.extraSmall.semiBold.colored(color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isBreak && entry.room != null)
            Text(entry.room!,
                style: AppStyles.extraSmall.regular.greyColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Color _getSubjectColor(String? subject) {
    if (subject == null) return AppColors.safetyBlue;
    final hash = subject.hashCode;
    final colors = [
      AppColors.safetyBlue,
      AppColors.safetyGreen,
      AppColors.verdigris,
      AppColors.safetyOrange,
      AppColors.purple,
      AppColors.greenCyan,
      AppColors.selectiveYellow,
      AppColors.safetyLightRed,
    ];
    return colors[hash.abs() % colors.length];
  }
}
