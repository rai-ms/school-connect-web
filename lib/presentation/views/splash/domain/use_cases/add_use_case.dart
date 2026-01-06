import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';

@lazySingleton
class AddUseCases extends UseCase<int, int> {
  @override
  Future<int> call({required int params}) async {
    return params + 1;
  }
}
