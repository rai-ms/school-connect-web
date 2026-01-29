import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/academic_event_model.dart';
import '../manager/calendar_bloc/calendar_bloc.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context
        .read<CalendarBloc>()
        .add(FetchEventsByMonth(year: now.year, month: now.month));
    context.read<CalendarBloc>().add(SelectDay(now));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Academic Calendar', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/calendar/add'),
        backgroundColor: AppColors.safetyBlue,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Column(
            children: [
              // Month navigation header
              _buildMonthHeader(state),
              Space.h8,
              // Calendar grid
              _buildCalendarGrid(state),
              Space.h8,
              // Divider
              Divider(
                color: AppColors.whiteColor.withValues(alpha: 0.2),
                height: 1,
              ),
              Space.h8,
              // Events for selected day
              Expanded(child: _buildSelectedDayEvents(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMonthHeader(CalendarState state) {
    final monthName = DateFormat('MMMM yyyy')
        .format(DateTime(state.currentYear, state.currentMonth));
    return Padding(
      padding: AppPadding.padSH16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon:
                const Icon(Icons.chevron_left, color: AppColors.whiteColor),
            onPressed: () {
              context.read<CalendarBloc>().add(const ChangeMonth(-1));
            },
          ),
          Text(monthName, style: AppStyles.medium.bold.white),
          IconButton(
            icon: const Icon(Icons.chevron_right,
                color: AppColors.whiteColor),
            onPressed: () {
              context.read<CalendarBloc>().add(const ChangeMonth(1));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(CalendarState state) {
    final year = state.currentYear;
    final month = state.currentMonth;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday = 1, Sunday = 7
    final startWeekday = firstDay.weekday;

    final daysWithEvents = state.daysWithEvents;
    final today = DateTime.now();
    final selectedDate = state.selectedDate;

    // Build event type map for dot coloring
    final Map<int, Set<String>> dayEventTypes = {};
    for (final e in state.events) {
      final start = e.startDateTime;
      final end = e.endDateTime;
      for (var d = start;
          !d.isAfter(end);
          d = d.add(const Duration(days: 1))) {
        if (d.year == year && d.month == month) {
          dayEventTypes.putIfAbsent(d.day, () => {});
          dayEventTypes[d.day]!.add(e.eventType);
        }
      }
    }

    return Padding(
      padding: AppPadding.padSH16,
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(d,
                            style: AppStyles.extraSmall.regular.greyColor),
                      ),
                    ))
                .toList(),
          ),
          Space.h8,
          // Day cells
          ...List.generate(6, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayOfWeek) {
                final dayNumber =
                    weekIndex * 7 + dayOfWeek + 1 - (startWeekday - 1);

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox(width: 40, height: 44);
                }

                final isToday = today.year == year &&
                    today.month == month &&
                    today.day == dayNumber;
                final isSelected = selectedDate != null &&
                    selectedDate.year == year &&
                    selectedDate.month == month &&
                    selectedDate.day == dayNumber;
                final hasEvents = daysWithEvents.contains(dayNumber);
                final eventTypes = dayEventTypes[dayNumber] ?? {};

                return GestureDetector(
                  onTap: () {
                    context
                        .read<CalendarBloc>()
                        .add(SelectDay(DateTime(year, month, dayNumber)));
                  },
                  child: Container(
                    width: 40,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.safetyBlue
                          : isToday
                              ? AppColors.safetyBlue
                                  .withValues(alpha: 0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: AppColors.safetyBlue,
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: isSelected
                              ? AppStyles.small.bold.white
                              : AppStyles.small.regular.white,
                        ),
                        if (hasEvents)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildEventDots(eventTypes),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildEventDots(Set<String> eventTypes) {
    final dots = <Widget>[];
    final types = eventTypes.take(3).toList();
    for (final type in types) {
      dots.add(Container(
        width: 5,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: _getEventTypeColor(type),
          shape: BoxShape.circle,
        ),
      ));
    }
    return dots;
  }

  Widget _buildSelectedDayEvents(CalendarState state) {
    if (state.isLoading && state.events.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.safetyBlue),
      );
    }

    final selectedDate = state.selectedDate;
    final eventsForDay = state.eventsForSelectedDay;

    final dateLabel = selectedDate != null
        ? DateFormat('EEEE, MMM d, yyyy').format(selectedDate)
        : 'Select a day';

    return Padding(
      padding: AppPadding.padSH16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateLabel, style: AppStyles.semiMedium.bold.white),
          Space.h8,
          if (eventsForDay.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_available,
                        size: 48,
                        color:
                            AppColors.greyColor.withValues(alpha: 0.5)),
                    Space.h8,
                    Text('No events for this day',
                        style: AppStyles.small.regular.greyColor),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: eventsForDay.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(eventsForDay[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventCard(AcademicEventResponse event) {
    final color = _getEventTypeColor(event.eventType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.push('/calendar/${event.id}'),
        child: GlassyBackground(
          borderColor: color.withValues(alpha: 0.3),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: AppStyles.semiMedium.semiBold.white),
                    Space.h4,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.eventTypeLabel,
                            style: AppStyles.extraSmall.regular
                                .colored(color),
                          ),
                        ),
                        Space.w8,
                        Text(
                          _formatDateRange(event),
                          style: AppStyles.extraSmall.regular.greyColor,
                        ),
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

  String _formatDateRange(AcademicEventResponse event) {
    final start = event.startDateTime;
    final end = event.endDateTime;
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return DateFormat('MMM d').format(start);
    }
    return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d').format(end)}';
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'HOLIDAY':
        return AppColors.safetyLightRed;
      case 'EXAM':
        return AppColors.safetyOrange;
      case 'MEETING':
        return AppColors.safetyBlue;
      case 'ACTIVITY':
        return AppColors.safetyGreen;
      case 'CUSTOM':
        return AppColors.purple;
      default:
        return AppColors.safetyBlue;
    }
  }
}
