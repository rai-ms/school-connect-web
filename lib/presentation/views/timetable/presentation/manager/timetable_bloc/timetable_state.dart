part of 'timetable_bloc.dart';

class TimetableState extends BlocEventState<List<TimetableEntryResponse>> {
  final List<PeriodResponse> periods;
  final List<TimetableEntryResponse> entries;
  final Map<String, List<TimetableEntryResponse>> weeklyTimetable;

  const TimetableState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.periods = const [],
    this.entries = const [],
    this.weeklyTimetable = const {},
  });

  @override
  TimetableState copyWith({
    BlocState? state,
    List<TimetableEntryResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<PeriodResponse>? periods,
    List<TimetableEntryResponse>? entries,
    Map<String, List<TimetableEntryResponse>>? weeklyTimetable,
  }) {
    return TimetableState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      periods: periods ?? this.periods,
      entries: entries ?? this.entries,
      weeklyTimetable: weeklyTimetable ?? this.weeklyTimetable,
    );
  }

  @override
  TimetableState clear({BlocState? state, BlocEvent? event}) =>
      TimetableState(state: state ?? super.state, event: event);
}
