import 'package:injectable/injectable.dart';

import '../storage_contract/storage_contract.dart';

@singleton
class NoOpStorageStrategy implements StorageStrategy {
  const NoOpStorageStrategy();

  @override
  Future<void> write(String key, value) async {}

  @override
  Future<T?> read<T>(String key) async => null;

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> clear() async {}

  @override
  T? readSync<T>(String key) {
    // TODO: implement readSync
    throw UnimplementedError();
  }
}
