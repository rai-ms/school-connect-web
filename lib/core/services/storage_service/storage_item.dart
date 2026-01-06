import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';

class StorageItem<T> {
  final String key;
  final StorageStrategy _storageStrategy;

  const StorageItem(this.key, this._storageStrategy);

  Future<void> write(T value) => _storageStrategy.write(key, value);

  Future<T?> read() => _storageStrategy.read<T>(key);

  T? call() => _storageStrategy.readSync<T>(key);

  Future<void> delete() => _storageStrategy.delete(key);
}
