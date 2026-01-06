import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/services/storage_service/secure_storage/secure_storage_keys.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';

@GenerateMocks([StorageStrategy])
import 'auth_storage_repo_test.mocks.dart';

void main() {
  late MockStorageStrategy mockStorageStrategy;
  late AuthStorageRepository authStorageRepository;

  setUp(() {
    mockStorageStrategy = MockStorageStrategy();
    authStorageRepository = AuthStorageRepository(mockStorageStrategy);
  });

  group('AuthStorageRepository', () {
    test('accessToken write calls strategy write with correct key', () async {
      await authStorageRepository.accessToken.write('token123');
      verify(
        mockStorageStrategy.write(SecureStorageKeys.kAccessToken, 'token123'),
      ).called(1);
    });

    test('accessToken read calls strategy read with correct key', () async {
      when(
        mockStorageStrategy.read<String>(SecureStorageKeys.kAccessToken),
      ).thenAnswer((_) async => 'token123');

      final result = await authStorageRepository.accessToken.read();

      expect(result, 'token123');
      verify(
        mockStorageStrategy.read<String>(SecureStorageKeys.kAccessToken),
      ).called(1);
    });

    test('userId delete calls strategy delete with correct key', () async {
      await authStorageRepository.userId.delete();
      verify(mockStorageStrategy.delete(SecureStorageKeys.kUserId)).called(1);
    });
  });
}
