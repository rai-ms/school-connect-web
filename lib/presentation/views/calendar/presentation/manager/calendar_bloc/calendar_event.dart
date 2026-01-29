part of 'calendar_bloc.dart';

class CalendarEvent extends BlocEvent {
  const CalendarEvent();
}

class FetchEvents extends CalendarEvent {
  final int page;
  final int size;
  const FetchEvents({this.page = 0, this.size = 50});
}

class FetchEventsByMonth extends CalendarEvent {
  final int year;
  final int month;
  const FetchEventsByMonth({required this.year, required this.month});
}

class FetchUpcomingEvents extends CalendarEvent {
  final int limit;
  const FetchUpcomingEvents({this.limit = 10});
}

class FetchHolidays extends CalendarEvent {
  final String academicYear;
  const FetchHolidays({required this.academicYear});
}

class CreateEvent extends CalendarEvent {
  final CreateAcademicEventRequest request;
  const CreateEvent(this.request);
}

class UpdateEvent extends CalendarEvent {
  final String eventId;
  final CreateAcademicEventRequest request;
  const UpdateEvent(this.eventId, this.request);
}

class DeleteEvent extends CalendarEvent {
  final String eventId;
  const DeleteEvent(this.eventId);
}

class SelectDay extends CalendarEvent {
  final DateTime date;
  const SelectDay(this.date);
}

class ChangeMonth extends CalendarEvent {
  final int delta; // +1 for next, -1 for previous
  const ChangeMonth(this.delta);
}

class FetchEventById extends CalendarEvent {
  final String eventId;
  const FetchEventById(this.eventId);
}
