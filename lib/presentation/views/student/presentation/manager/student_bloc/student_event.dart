part of 'student_bloc.dart';

class StudentEvent extends BlocEvent {
  const StudentEvent();
}

class FetchStudents extends StudentEvent {
  final int page;
  final int size;
  final bool loadMore;
  final String? classId;
  final String? search;
  const FetchStudents({
    this.page = 0,
    this.size = 20,
    this.loadMore = false,
    this.classId,
    this.search,
  });
}

class FetchStudentById extends StudentEvent {
  final String studentId;
  const FetchStudentById(this.studentId);
}

class CreateStudent extends StudentEvent {
  final CreateStudentRequest request;
  const CreateStudent(this.request);
}

class UpdateStudent extends StudentEvent {
  final String studentId;
  final Map<String, dynamic> updates;
  const UpdateStudent(this.studentId, this.updates);
}

class DeleteStudent extends StudentEvent {
  final String studentId;
  const DeleteStudent(this.studentId);
}

class SearchStudents extends StudentEvent {
  final String query;
  const SearchStudents(this.query);
}

class FetchStudentStatistics extends StudentEvent {
  const FetchStudentStatistics();
}

class FetchStudentsByClass extends StudentEvent {
  final String classId;
  const FetchStudentsByClass(this.classId);
}

class ExportStudents extends StudentEvent {
  final String? classId;
  final String? sectionId;
  final String? status;
  const ExportStudents({this.classId, this.sectionId, this.status});
}

class ImportStudents extends StudentEvent {
  final String filePath;
  final String? classId;
  const ImportStudents({required this.filePath, this.classId});
}

class DownloadImportTemplate extends StudentEvent {
  const DownloadImportTemplate();
}
