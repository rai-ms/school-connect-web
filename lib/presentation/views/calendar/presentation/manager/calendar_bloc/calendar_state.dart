part of 'calendar_bloc.dart';

class CalendarState extends BlocEventState<List<AcademicEventResponse>> {
  final List<AcademicEventResponse> events;
  final List<AcademicEventResponse> upcomingEvents;
  final List<AcademicEventResponse> holidays;
  final AcademicEventResponse? selectedEvent;
  final DateTime? selectedDate;
  final int currentMonth;
  final int currentYear;
  final bool actionCompleted;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  CalendarState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.events = const [],
    this.upcomingEvents = const [],
    this.holidays = const [],
    this.selectedEvent,
    this.selectedDate,
    required this.currentMonth,
    required this.currentYear,
    this.actionCompleted = false,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
  });

  List<AcademicEventResponse> get eventsForSelectedDay {
    if (selectedDate == null) return [];
    return events.where((e) {
      final start = e.startDateTime;
      final end = e.endDateTime;
      final sel = selectedDate!;
      return !sel.isBefore(DateTime(start.year, start.month, start.day)) &&
          !sel.isAfter(DateTime(end.year, end.month, end.day));
    }).toList();
  }

  /// Returns a set of day numbers that have events in the current month
  Set<int> get daysWithEvents {
    final Set<int> days = {};
    for (final e in events) {
      final start = e.startDateTime;
      final end = e.endDateTime;
      // Iterate through each day of the event range
      for (var d = start;
          !d.isAfter(end);
          d = d.add(const Duration(days: 1))) {
        if (d.year == currentYear && d.month == currentMonth) {
          days.add(d.day);
        }
      }
    }
    return days;
  }

  @override
  CalendarState copyWith({
    BlocState? state,
    List<AcademicEventResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<AcademicEventResponse>? events,
    List<AcademicEventResponse>? upcomingEvents,
    List<AcademicEventResponse>? holidays,
    AcademicEventResponse? selectedEvent,
    DateTime? selectedDate,
    int? currentMonth,
    int? currentYear,
    bool? actionCompleted,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return CalendarState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      events: events ?? this.events,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      holidays: holidays ?? this.holidays,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
      actionCompleted: actionCompleted ?? false,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  CalendarState clear({BlocState? state, BlocEvent? event}) => CalendarState(
        state: state ?? super.state,
        event: event,
        currentMonth: currentMonth,
        currentYear: currentYear,
      );
}
