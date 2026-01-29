import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import 'class_item.dart';

class UpcomingClasses extends StatelessWidget {
  const UpcomingClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimetableBloc, TimetableState>(
      builder: (context, state) {
        if (state.isLoading) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.isFailed) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.whiteColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load classes',
                      style: AppStyles.semiMedium.regular.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Filter entries for today's day of week
        final today = DateTime.now();
        final dayName = _getDayOfWeek(today.weekday);
        final todayEntries = state.entries
            .where(
                (e) => e.dayOfWeek.toUpperCase() == dayName.toUpperCase())
            .toList();

        // Sort by period start time
        todayEntries.sort((a, b) {
          final aTime = a.period?.startTime ?? '';
          final bTime = b.period?.startTime ?? '';
          return aTime.compareTo(bTime);
        });

        if (todayEntries.isEmpty) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_available,
                        color: AppColors.whiteColor.withValues(alpha: 0.7),
                        size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No classes scheduled for today',
                      style: AppStyles.semiMedium.regular.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return GlassyBackground(
          child: Column(
            children: [
              ...todayEntries.asMap().entries.map((entry) {
                final timetableEntry = entry.value;
                final period = timetableEntry.period;
                final timeText = period != null
                    ? '${period.startTime}\n${period.endTime}'
                    : timetableEntry.dayOfWeek;
                final subjectText =
                    timetableEntry.subjectName ?? 'Unknown';
                final roomText = timetableEntry.room != null
                    ? (timetableEntry.room!.toLowerCase().contains('lab')
                        ? timetableEntry.room!
                        : 'Room ${timetableEntry.room}')
                    : '';

                return ClassItem(
                  time: timeText,
                  subject: subjectText,
                  room: roomText,
                  isLast: entry.key == todayEntries.length - 1,
                  onNotificationPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reminder set for $subjectText',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'MONDAY';
      case DateTime.tuesday:
        return 'TUESDAY';
      case DateTime.wednesday:
        return 'WEDNESDAY';
      case DateTime.thursday:
        return 'THURSDAY';
      case DateTime.friday:
        return 'FRIDAY';
      case DateTime.saturday:
        return 'SATURDAY';
      case DateTime.sunday:
        return 'SUNDAY';
      default:
        return 'MONDAY';
    }
  }
}
