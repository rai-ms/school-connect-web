part of 'timetable_bloc.dart';

class TimetableEvent extends BlocEvent {
  const TimetableEvent();
}

class FetchPeriods extends TimetableEvent {
  const FetchPeriods();
}

class FetchClassTimetable extends TimetableEvent {
  final String classId;
  const FetchClassTimetable(this.classId);
}

class FetchTeacherTimetable extends TimetableEvent {
  final String teacherId;
  const FetchTeacherTimetable(this.teacherId);
}

class FetchClassWeeklyTimetable extends TimetableEvent {
  final String classId;
  const FetchClassWeeklyTimetable(this.classId);
}

class FetchTeacherWeeklyTimetable extends TimetableEvent {
  final String teacherId;
  const FetchTeacherWeeklyTimetable(this.teacherId);
}

class CreatePeriod extends TimetableEvent {
  final PeriodRequest request;
  const CreatePeriod(this.request);
}

class CreateTimetableEntry extends TimetableEvent {
  final TimetableEntryRequest request;
  const CreateTimetableEntry(this.request);
}

class UpdateTimetableEntry extends TimetableEvent {
  final String entryId;
  final TimetableEntryRequest request;
  const UpdateTimetableEntry(this.entryId, this.request);
}

class DeleteTimetableEntry extends TimetableEvent {
  final String entryId;
  const DeleteTimetableEntry(this.entryId);
}
