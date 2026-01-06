
import 'package:student_management/core/utils/app_type_def.dart';
import '../../data/models/request/login_request.dart' show LoginRequest;

abstract class LoginRepository {

  DioResponse login({
    required LoginRequest payload
  });
  
  // Future<Either<Failure, void>> logout();
}
