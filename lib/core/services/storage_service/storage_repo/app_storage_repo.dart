import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/storage_service/hive_storage/hive_constants.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_item.dart';

@singleton
class AppStorageRepository {
  final StorageStrategy _storageStrategy;

  AppStorageRepository(@Named('hive_storage') this._storageStrategy);

  late final StorageItem<String> theme = StorageItem(
    AppStorageKey.themeKey,
    _storageStrategy,
  );
  late final StorageItem<String> lang = StorageItem(
    AppStorageKey.langKey,
    _storageStrategy,
  );
  late final StorageItem<String> defaultDashboardId = StorageItem(
    AppStorageKey.defaultDashboardId,
    _storageStrategy,
  );
  late final StorageItem<bool> onBoardingComplete = StorageItem(
    AppStorageKey.onBoardingComplete,
    _storageStrategy,
  );
  late final StorageItem<bool> isIntroCompleted = StorageItem(
    AppStorageKey.isIntroCompleted,
    _storageStrategy,
  );
}
