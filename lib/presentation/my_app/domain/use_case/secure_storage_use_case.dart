import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_use_case/use_case.dart';
import 'package:student_management/core/services/storage_service/secure_storage/secure_storage_strategy.dart';
import 'package:student_management/core/services/storage_service/storage_repository.dart';

import '../../../../core/services/storage_service/storage_contract/storage_contract.dart';

@singleton
class SecureStorageUseCase extends AsyncUseCase<StorageStrategy?, String> {
  final StorageRepository repository;

  SecureStorageUseCase()
    : repository = const StorageRepository(SecureStorageStrategy());

  @override
  StorageStrategy call({required String params}) {
    return repository.strategy;
  }
}
