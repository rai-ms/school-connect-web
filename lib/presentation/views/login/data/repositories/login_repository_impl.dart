import 'package:injectable/injectable.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import 'package:student_management/core/utils/app_type_def.dart';
import 'package:student_management/presentation/views/login/domain/repositories/login_repository.dart';

import '../../../../../core/services/api_service/api_dispatcher.dart';
import '../models/request/login_request.dart' show LoginRequest;

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final ApiDispatcher apiDispatcher;

  LoginRepositoryImpl(this.apiDispatcher);

  @override
  DioResponse login({required LoginRequest payload}) async {
    return await apiDispatcher(
      type: RequestType.post,
      endPoint: ApiEndPoint.login,
      body: payload.toJson(),
    );
  }
}
