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

class AddEventPage extends StatefulWidget {
  final AcademicEventResponse? existingEvent;
  const AddEventPage({super.key, this.existingEvent});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _academicYearController = TextEditingController();

  String _selectedEventType = 'HOLIDAY';
  String _selectedAudience = 'ALL';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isAllDay = true;

  bool get isEditing => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingEvent != null) {
      final event = widget.existingEvent!;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _selectedEventType = event.eventType;
      _selectedAudience = event.targetAudience;
      _startDate = event.startDateTime;
      _endDate = event.endDateTime;
      _isAllDay = event.isAllDay;
      _academicYearController.text = event.academicYear ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text(
          isEditing ? 'Edit Event' : 'Add Event',
          style: AppStyles.large.bold.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state.actionCompleted &&
              (state.event is CreateEvent ||
                  state.event is UpdateEvent)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing
                    ? 'Event updated successfully'
                    : 'Event added successfully'),
                backgroundColor: AppColors.safetyGreen,
              ),
            );
            context.pop();
          }
          if (state.isFailed &&
              (state.event is CreateEvent ||
                  state.event is UpdateEvent)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ??
                    'Failed to ${isEditing ? 'update' : 'add'} event'),
                backgroundColor: AppColors.safetyLightRed,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  Text('Basic Information',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(_titleController, 'Event Title',
                            required: true),
                        Space.h12,
                        _buildTextField(
                            _descriptionController, 'Description',
                            maxLines: 3),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Event Type
                  Text('Event Type',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEventTypeSelector(),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Dates
                  Text('Dates',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildDatePicker('Start Date', _startDate,
                            (date) {
                          setState(() {
                            _startDate = date;
                            if (_endDate.isBefore(_startDate)) {
                              _endDate = _startDate;
                            }
                          });
                        }),
                        Space.h12,
                        _buildDatePicker('End Date', _endDate, (date) {
                          setState(() => _endDate = date);
                        }),
                        Space.h12,
                        _buildAllDaySwitch(),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Audience
                  Text('Target Audience',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAudienceSelector(),
                      ],
                    ),
                  ),

                  Space.h16,

                  // Additional
                  Text('Additional',
                      style: AppStyles.semiMedium.bold.white),
                  Space.h8,
                  GlassyBackground(
                    child: Column(
                      children: [
                        _buildTextField(
                            _academicYearController, 'Academic Year',
                            hint: 'e.g., 2024-2025'),
                      ],
                    ),
                  ),

                  Space.h24,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              (state.event is CreateEvent ||
                                  state.event is UpdateEvent)
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              isEditing ? 'Update Event' : 'Add Event',
                              style: AppStyles.semiMedium.bold.white),
                    ),
                  ),
                  Space.h20,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      style: AppStyles.semiMedium.regular.white,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.small.regular.greyColor,
        hintText: hint,
        hintStyle: AppStyles.extraSmall.regular.greyColor,
        border: InputBorder.none,
      ),
      validator: required
          ? (v) =>
              v == null || v.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildEventTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTypeChip('Holiday', 'HOLIDAY', AppColors.safetyLightRed),
        _buildTypeChip('Exam', 'EXAM', AppColors.safetyOrange),
        _buildTypeChip('Meeting', 'MEETING', AppColors.safetyBlue),
        _buildTypeChip('Activity', 'ACTIVITY', AppColors.safetyGreen),
        _buildTypeChip('Custom', 'CUSTOM', AppColors.purple),
      ],
    );
  }

  Widget _buildTypeChip(String label, String type, Color color) {
    final isSelected = _selectedEventType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedEventType = type);
      },
      selectedColor: color,
      backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
      labelStyle: isSelected
          ? AppStyles.small.regular.white
          : AppStyles.small.regular.greyColor,
    );
  }

  Widget _buildAudienceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildAudienceChip('Everyone', 'ALL'),
        _buildAudienceChip('Students', 'STUDENTS'),
        _buildAudienceChip('Teachers', 'TEACHERS'),
        _buildAudienceChip('Parents', 'PARENTS'),
      ],
    );
  }

  Widget _buildAudienceChip(String label, String audience) {
    final isSelected = _selectedAudience == audience;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedAudience = audience);
      },
      selectedColor: AppColors.safetyBlue,
      backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
      labelStyle: isSelected
          ? AppStyles.small.regular.white
          : AppStyles.small.regular.greyColor,
    );
  }

  Widget _buildDatePicker(
      String label, DateTime date, ValueChanged<DateTime> onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.safetyBlue,
                  onPrimary: AppColors.whiteColor,
                  surface: AppColors.darkGunMetal,
                  onSurface: AppColors.whiteColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppStyles.small.regular.greyColor),
              Space.h4,
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(date),
                style: AppStyles.semiMedium.regular.white,
              ),
            ],
          ),
          const Icon(Icons.calendar_today,
              color: AppColors.greyColor, size: 20),
        ],
      ),
    );
  }

  Widget _buildAllDaySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('All Day', style: AppStyles.small.regular.greyColor),
        Switch(
          value: _isAllDay,
          onChanged: (val) => setState(() => _isAllDay = val),
          activeTrackColor:
              AppColors.safetyGreen.withValues(alpha: 0.5),
          activeThumbColor: AppColors.safetyGreen,
        ),
      ],
    );
  }

  void _submitEvent() {
    if (!_formKey.currentState!.validate()) return;

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date'),
          backgroundColor: AppColors.safetyLightRed,
        ),
      );
      return;
    }

    final request = CreateAcademicEventRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      eventType: _selectedEventType,
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate),
      isAllDay: _isAllDay,
      isRecurring: false,
      targetAudience: _selectedAudience,
      academicYear: _academicYearController.text.trim().isNotEmpty
          ? _academicYearController.text.trim()
          : null,
    );

    if (isEditing) {
      context
          .read<CalendarBloc>()
          .add(UpdateEvent(widget.existingEvent!.id, request));
    } else {
      context.read<CalendarBloc>().add(CreateEvent(request));
    }
  }
}
