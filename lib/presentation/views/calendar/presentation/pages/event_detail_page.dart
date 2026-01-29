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

class EventDetailPage extends StatefulWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(FetchEventById(widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Event Details', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state.selectedEvent == null) return const SizedBox();
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.whiteColor),
                color: AppColors.darkGunMetal,
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/calendar/add',
                        extra: state.selectedEvent);
                  } else if (value == 'delete') {
                    _showDeleteDialog(state.selectedEvent!);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit,
                            color: AppColors.safetyBlue, size: 18),
                        Space.w8,
                        Text('Edit',
                            style: AppStyles.semiMedium.regular.white),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete,
                            color: AppColors.safetyLightRed, size: 18),
                        Space.w8,
                        Text('Delete',
                            style: AppStyles.semiMedium.regular
                                .colored(AppColors.safetyLightRed)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is DeleteEvent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Event deleted successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed && state.event is DeleteEvent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to delete event'),
                backgroundColor: AppColors.safetyLightRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.selectedEvent == null) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final event = state.selectedEvent;
          if (event == null) {
            return Center(
              child: Text('Event not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          final color = _getEventTypeColor(event.eventType);

          return ListView(
            padding: AppPadding.padA16,
            children: [
              // Header
              GlassyBackground(
                borderColor: color.withValues(alpha: 0.3),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getEventTypeIcon(event.eventType),
                          color: color, size: 32),
                    ),
                    Space.h12,
                    Text(event.title,
                        style: AppStyles.large.bold.white,
                        textAlign: TextAlign.center),
                    Space.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.eventTypeLabel,
                            style: AppStyles.extraSmall.bold
                                .colored(color),
                          ),
                        ),
                        Space.w8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.safetyBlue
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.audienceLabel,
                            style: AppStyles.extraSmall.bold
                                .colored(AppColors.safetyBlue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Space.h16,

              // Date Information
              _buildSection('Date & Time', [
                _buildInfoRow('Start Date',
                    DateFormat('EEEE, MMM d, yyyy').format(event.startDateTime)),
                _buildInfoRow('End Date',
                    DateFormat('EEEE, MMM d, yyyy').format(event.endDateTime)),
                _buildInfoRow(
                    'All Day', event.isAllDay ? 'Yes' : 'No'),
                _buildInfoRow(
                    'Recurring', event.isRecurring ? 'Yes' : 'No'),
              ]),

              Space.h12,

              // Details
              _buildSection('Details', [
                if (event.description != null && event.description!.isNotEmpty)
                  _buildInfoRow('Description', event.description!),
                if (event.academicYear != null)
                  _buildInfoRow('Academic Year', event.academicYear!),
                _buildInfoRow('Audience', event.audienceLabel),
              ]),

              Space.h30,
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(AcademicEventResponse event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkGunMetal,
        title:
            Text('Delete Event', style: AppStyles.medium.bold.white),
        content: Text(
          'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
          style: AppStyles.semiMedium.regular.greyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppStyles.semiMedium.regular.greyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<CalendarBloc>()
                  .add(DeleteEvent(event.id));
            },
            child: Text('Delete',
                style: AppStyles.semiMedium.bold
                    .colored(AppColors.safetyLightRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final filteredChildren =
        children.where((w) => w is! SizedBox).toList();
    if (filteredChildren.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.semiMedium.bold.white),
        Space.h8,
        GlassyBackground(
          child: Column(children: filteredChildren),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppStyles.small.regular.greyColor),
          ),
          Expanded(
            child: Text(value, style: AppStyles.small.regular.white),
          ),
        ],
      ),
    );
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

  IconData _getEventTypeIcon(String type) {
    switch (type) {
      case 'HOLIDAY':
        return Icons.beach_access;
      case 'EXAM':
        return Icons.assignment;
      case 'MEETING':
        return Icons.groups;
      case 'ACTIVITY':
        return Icons.celebration;
      case 'CUSTOM':
        return Icons.event;
      default:
        return Icons.event;
    }
  }
}
