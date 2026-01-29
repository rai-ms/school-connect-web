import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/academic_event_model.dart';
import '../../../data/repositories/academic_calendar_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

@injectable
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final AcademicCalendarRepository _repository;
  final StateRequestHandler _handler;

  CalendarBloc(this._repository, this._handler)
      : super(CalendarState(
          currentYear: DateTime.now().year,
          currentMonth: DateTime.now().month,
        )) {
    on<FetchEvents>(_onFetchEvents);
    on<FetchEventsByMonth>(_onFetchEventsByMonth);
    on<FetchUpcomingEvents>(_onFetchUpcomingEvents);
    on<FetchHolidays>(_onFetchHolidays);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<SelectDay>(_onSelectDay);
    on<ChangeMonth>(_onChangeMonth);
    on<FetchEventById>(_onFetchEventById);
  }

  FVoid _onFetchEvents(FetchEvents event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.getAllEvents(
          page: event.page,
          size: event.size,
        );
        emit(state.copyWith(
          state: state.success,
          events: result.content,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching calendar events: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching calendar events: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchEventsByMonth(
      FetchEventsByMonth event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(
          state: state.loading,
          event: event,
          currentYear: event.year,
          currentMonth: event.month,
        ));
        final result =
            await _repository.getEventsByMonth(event.year, event.month);
        emit(state.copyWith(
          state: state.success,
          events: result,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching month events: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching month events: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchUpcomingEvents(
      FetchUpcomingEvents event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.getUpcomingEvents(limit: event.limit);
        emit(state.copyWith(
          state: state.success,
          upcomingEvents: result,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching upcoming events: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching upcoming events: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchHolidays(
      FetchHolidays event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.getHolidays(event.academicYear);
        emit(state.copyWith(
          state: state.success,
          holidays: result,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching holidays: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching holidays: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateEvent(
      CreateEvent event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createEvent(event.request);
        final result = await _repository.getEventsByMonth(
            state.currentYear, state.currentMonth);
        emit(state.copyWith(
          state: state.success,
          events: result,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error creating event: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating event: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateEvent(
      UpdateEvent event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated =
            await _repository.updateEvent(event.eventId, event.request);
        final result = await _repository.getEventsByMonth(
            state.currentYear, state.currentMonth);
        emit(state.copyWith(
          state: state.success,
          events: result,
          selectedEvent: updated,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error updating event: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating event: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteEvent(
      DeleteEvent event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteEvent(event.eventId);
        final result = await _repository.getEventsByMonth(
            state.currentYear, state.currentMonth);
        emit(state.copyWith(
          state: state.success,
          events: result,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error deleting event: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting event: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSelectDay(SelectDay event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(selectedDate: event.date));
  }

  FVoid _onChangeMonth(
      ChangeMonth event, Emitter<CalendarState> emit) async {
    int newMonth = state.currentMonth + event.delta;
    int newYear = state.currentYear;
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }
    add(FetchEventsByMonth(year: newYear, month: newMonth));
  }

  FVoid _onFetchEventById(
      FetchEventById event, Emitter<CalendarState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.getEventById(event.eventId);
        emit(state.copyWith(
          state: state.success,
          selectedEvent: result,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching event: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching event: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
