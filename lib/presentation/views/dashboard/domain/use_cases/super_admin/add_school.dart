import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/super_admin/add_school_request.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/super_admin/add_school_repository.dart';

@singleton
class AddSchool implements UseCase<Response, AddSchoolRequest> {
  final AddSchoolRepository _repository;

  const AddSchool(this._repository);

  @override
  Future<Response> call({required AddSchoolRequest params}) async {
    return await _repository.addSchool(params);
  }
}
