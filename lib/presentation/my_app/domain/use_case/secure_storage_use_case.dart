import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';

import '../../../../core/services/storage_service/storage_contract/storage_contract.dart';

@singleton
class SecureStorageUseCase extends AsyncUseCase<StorageStrategy?, String> {
  final StorageStrategy _storageStrategy;

  SecureStorageUseCase(
    @Named('secure_storage') this._storageStrategy,
  );

  @override
  StorageStrategy call({required String params}) {
    return _storageStrategy;
  }
}
