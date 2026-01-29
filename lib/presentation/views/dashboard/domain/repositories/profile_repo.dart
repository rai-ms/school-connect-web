

import 'package:dio/dio.dart';
import '../../data/models/req/profile_fetch_req.dart';
import '../../data/models/req/profile_update_req.dart';

abstract class ProfileRepo {

  const ProfileRepo();

  Future<Response> fetchProfile(ProfileFetchRequest req);

  Future<Response> updateProfile(ProfileUpdateRequest req);
}