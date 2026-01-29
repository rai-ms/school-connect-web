part of 'teacher_bloc.dart';

class TeacherEvent extends BlocEvent {
  const TeacherEvent();
}

class FetchTeachers extends TeacherEvent {
  const FetchTeachers();
}

class FetchTeacherById extends TeacherEvent {
  final String id;
  const FetchTeacherById(this.id);
}

class CreateTeacher extends TeacherEvent {
  final CreateTeacherRequest request;
  const CreateTeacher(this.request);
}

class UpdateTeacher extends TeacherEvent {
  final String id;
  final Map<String, dynamic> updates;
  const UpdateTeacher(this.id, this.updates);
}

class DeleteTeacher extends TeacherEvent {
  final String id;
  const DeleteTeacher(this.id);
}
