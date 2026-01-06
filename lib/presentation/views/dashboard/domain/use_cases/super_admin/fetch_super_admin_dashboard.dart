import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/no_param.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/super_admin/super_admin_repo.dart';

@singleton
class FetchSuperAdminDashboard extends UseCase<Response, NoParam> {
  final SuperAdminDashboardRepo _repo;

  const FetchSuperAdminDashboard(this._repo);

  @override
  Future<Response> call({required NoParam params}) async {
    return await _repo.fetchDashboard();
  }
}
