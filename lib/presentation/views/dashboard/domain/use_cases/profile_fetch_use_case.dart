

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/profile_repo.dart';
import '../../data/models/req/profile_fetch_req.dart';

@LazySingleton(env: ['dev'])
class ProfileFetchUseCase extends UseCase<Response, ProfileFetchRequest>{

  final ProfileRepo _repo;

  const ProfileFetchUseCase(this._repo);

  @override
  Future<Response> call({required ProfileFetchRequest params}) async {
    return await _repo.fetchProfile(params);
  }
}