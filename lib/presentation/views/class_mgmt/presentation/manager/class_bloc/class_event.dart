part of 'class_bloc.dart';

class ClassEvent extends BlocEvent {
  const ClassEvent();
}

class FetchAllClasses extends ClassEvent {
  const FetchAllClasses();
}

class FetchClassById extends ClassEvent {
  final String classId;
  const FetchClassById(this.classId);
}

class CreateSchoolClass extends ClassEvent {
  final CreateClassRequest request;
  const CreateSchoolClass(this.request);
}

class FetchSectionsByClass extends ClassEvent {
  final String classId;
  const FetchSectionsByClass(this.classId);
}

class CreateSection extends ClassEvent {
  final CreateSectionRequest request;
  const CreateSection(this.request);
}
