part of 'add_school_bloc.dart';

abstract class AddSchoolEvent extends BlocEvent {
  const AddSchoolEvent();
}

class AddNewSchool extends AddSchoolEvent {
  final AddSchoolRequest request;

  const AddNewSchool(this.request);
}
