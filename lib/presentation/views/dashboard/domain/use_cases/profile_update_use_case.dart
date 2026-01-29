import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/presentation/views/dashboard/domain/repositories/profile_repo.dart';
import '../../data/models/req/profile_update_req.dart';

@LazySingleton(env: ['dev'])
class ProfileUpdateUseCase extends UseCase<Response, ProfileUpdateRequest> {
  final ProfileRepo _repo;

  const ProfileUpdateUseCase(this._repo);

  @override
  Future<Response> call({required ProfileUpdateRequest params}) async {
    return await _repo.updateProfile(params);
  }
}
