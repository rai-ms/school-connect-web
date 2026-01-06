import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import 'package:student_management/core/services/api_service/api_headers.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/super_admin/add_school_request.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/super_admin/add_school_repository.dart';

import '../../../../../../core/services/storage_service/storage_repo/auth_storage_repo.dart';

@LazySingleton(as: AddSchoolRepository)
class AddSchoolRepositoryImpl implements AddSchoolRepository {
  final ApiDispatcher _apiDispatcher;
  final AuthStorageRepository _storageService;

  const AddSchoolRepositoryImpl(this._apiDispatcher, this._storageService);

  @override
  Future<Response> addSchool(AddSchoolRequest request) async {
    return await _apiDispatcher(
      type: RequestType.post,
      options: APIHeaders.bearerOnlyHeader(_storageService.accessToken()),
      endPoint: ApiEndPoint.addSchool,
      body: request.toJson(),
    );
  }
}
