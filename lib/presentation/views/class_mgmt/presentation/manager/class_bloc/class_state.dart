part of 'class_bloc.dart';

class ClassState extends BlocEventState<List<SchoolClassResponse>> {
  final List<SchoolClassResponse> classes;
  final SchoolClassResponse? selectedClass;
  final List<SectionResponse> sections;
  final bool actionCompleted;

  const ClassState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.classes = const [],
    this.selectedClass,
    this.sections = const [],
    this.actionCompleted = false,
  });

  @override
  ClassState copyWith({
    BlocState? state,
    List<SchoolClassResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<SchoolClassResponse>? classes,
    SchoolClassResponse? selectedClass,
    List<SectionResponse>? sections,
    bool? actionCompleted,
  }) {
    return ClassState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      classes: classes ?? this.classes,
      selectedClass: selectedClass ?? this.selectedClass,
      sections: sections ?? this.sections,
      actionCompleted: actionCompleted ?? false,
    );
  }

  @override
  ClassState clear({BlocState? state, BlocEvent? event}) =>
      ClassState(state: state ?? super.state, event: event);
}
