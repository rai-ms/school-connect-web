import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/no_param.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/presentation/my_app/domain/repo/app_config_repo.dart';

@lazySingleton
class FetchAppConfigUseCase extends UseCase<Response, NoParam> {
  final AppConfigRepo _repo;

  const FetchAppConfigUseCase(this._repo);

  @override
  Future<Response> call({required NoParam params}) async {
    return await _repo.getAppConfig();
  }
}
