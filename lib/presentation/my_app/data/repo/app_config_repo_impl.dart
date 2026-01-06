import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/presentation/my_app/domain/repo/app_config_repo.dart';

import '../../../../core/services/api_service/api_dispatcher.dart';
import '../../../../core/utils/api_end_point.dart';

@LazySingleton(as: AppConfigRepo)
class AppConfigRepoImpl extends AppConfigRepo {
  final ApiDispatcher _dispatcher;

  AppConfigRepoImpl(this._dispatcher);

  @override
  Future<Response> getAppConfig() async {
    return await _dispatcher(
      type: RequestType.get,
      endPoint: ApiEndPoint.config,
    );
  }
}
