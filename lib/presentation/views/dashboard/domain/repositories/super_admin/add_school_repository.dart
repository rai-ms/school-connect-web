import 'package:dio/dio.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/super_admin/add_school_request.dart';


abstract class AddSchoolRepository {

  const AddSchoolRepository();

  Future<Response> addSchool(AddSchoolRequest request);
}
