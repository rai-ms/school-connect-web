import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_headers.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/super_admin/super_admin_repo.dart';

import '../../../../../../core/services/api_service/api_dispatcher.dart';

@Singleton(as: SuperAdminDashboardRepo)
class SuperAdminDashboardRepoImpl extends SuperAdminDashboardRepo {
  final ApiDispatcher _apiDispatcher;
  final AuthStorageRepository _storageService;

  const SuperAdminDashboardRepoImpl(this._apiDispatcher, this._storageService);

  @override
  Future<Response> fetchDashboard() async {
    final String? token = _storageService.accessToken();
    return await _apiDispatcher.call(
      type: RequestType.get,
      options: APIHeaders.bearerOnlyHeader(token),
      endPoint: ApiEndPoint.getAllUsers,
    );
  }
}
