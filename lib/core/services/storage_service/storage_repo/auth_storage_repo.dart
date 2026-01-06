import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/storage_service/secure_storage/secure_storage_keys.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_item.dart';

@singleton
class AuthStorageRepository {
  final StorageStrategy _storageStrategy;

  AuthStorageRepository(@Named('secure_storage') this._storageStrategy);

  late final StorageItem<String> secretKeyCipher = StorageItem(
    SecureStorageKeys.kSecretKeyCipher,
    _storageStrategy,
  );

  late final StorageItem<String> accessToken = StorageItem(
    SecureStorageKeys.kAccessToken,
    _storageStrategy,
  );

  late final StorageItem<String> refreshToken = StorageItem(
    SecureStorageKeys.kRefreshToken,
    _storageStrategy,
  );

  late final StorageItem<String> userId = StorageItem(
    SecureStorageKeys.kUserId,
    _storageStrategy,
  );

  late final StorageItem<String> rememberMe = StorageItem(
    SecureStorageKeys.kRememberMe,
    _storageStrategy,
  );

  late final StorageItem<String> userIdRemember = StorageItem(
    SecureStorageKeys.kUserIdRemember,
    _storageStrategy,
  );

  late final StorageItem<String> userPasswordRemember = StorageItem(
    SecureStorageKeys.kUserPasswordRemember,
    _storageStrategy,
  );

  Future<void> clearAuthData() async {
    await Future.wait([
      accessToken.delete(),
      refreshToken.delete(),
      userId.delete(),
    ]);
  }
}
