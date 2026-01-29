part of 'subject_bloc.dart';

class SubjectEvent extends BlocEvent {
  const SubjectEvent();
}

class FetchSubjects extends SubjectEvent {
  final int page;
  final int size;
  final bool loadMore;
  final String? search;
  const FetchSubjects({
    this.page = 0,
    this.size = 20,
    this.loadMore = false,
    this.search,
  });
}

class FetchSubjectById extends SubjectEvent {
  final String subjectId;
  const FetchSubjectById(this.subjectId);
}

class CreateSubjectEvent extends SubjectEvent {
  final CreateSubjectRequest request;
  const CreateSubjectEvent(this.request);
}

class UpdateSubjectEvent extends SubjectEvent {
  final String subjectId;
  final CreateSubjectRequest request;
  const UpdateSubjectEvent(this.subjectId, this.request);
}

class DeleteSubjectEvent extends SubjectEvent {
  final String subjectId;
  const DeleteSubjectEvent(this.subjectId);
}

class SearchSubjects extends SubjectEvent {
  final String query;
  const SearchSubjects(this.query);
}

class FetchSubjectsByClass extends SubjectEvent {
  final String classId;
  const FetchSubjectsByClass(this.classId);
}

class FetchSubjectsByTeacher extends SubjectEvent {
  final String teacherId;
  const FetchSubjectsByTeacher(this.teacherId);
}
