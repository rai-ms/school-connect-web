part of 'add_school_bloc.dart';

class AddSchoolState extends BlocEventState<AddNewSchoolResponse> {
  const AddSchoolState({
    super.data,
    super.error,
    super.state,
    super.event,
    super.statusCode,
  });

  @override
  AddSchoolState clear() => const AddSchoolState();

  @override
  AddSchoolState copyWith({
    AddNewSchoolResponse? data,
    String? error,
    BlocState? state,
    BlocEvent? event,
    int? statusCode,
  }) => AddSchoolState(
    data: data ?? this.data,
    error: error ?? this.error,
    state: state ?? this.state,
    event: event ?? this.event,
    statusCode: statusCode ?? this.statusCode,
  );
}
