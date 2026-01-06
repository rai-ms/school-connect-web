abstract class StorageStrategy {
  const StorageStrategy();

  Future<void> write(String key, dynamic value);
  Future<T?> read<T>(String key);

  /// Synchronously read a value from storage.
  /// Throws [UnimplementedError] by default.
  T? readSync<T>(String key);

  Future<void> delete(String key);
  Future<void> clear();
}
