import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_headers.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/profile_fetch_req.dart';

import '../../../../../core/services/api_service/api_dispatcher.dart';
import '../../../../../core/utils/api_end_point.dart';
import '../../domain/repositories/profile_repo.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImpl extends ProfileRepo {
  final ApiDispatcher _dispatcher;
  const ProfileRepoImpl(this._dispatcher);

  @override
  Future<Response> fetchProfile(ProfileFetchRequest req) async {
    return await _dispatcher(
      type: RequestType.get,
      options: APIHeaders.bearerOnlyHeader(req.token),
      endPoint: ApiEndPoint.profile(req.userId),
    );
  }
}
