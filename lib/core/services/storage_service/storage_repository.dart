import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';

@lazySingleton
class StorageRepository {
  final StorageStrategy strategy;

  const StorageRepository(@Named('hive_storage') this.strategy);

  Future<void> save(String key, dynamic value) async {
    return strategy.write(key, value);
  }

  Future<T?> load<T>(String key) async {
    return strategy.read<T>(key);
  }

  T? loadSync<T>(String key) {
    return strategy.readSync<T>(key);
  }

  Future<void> delete(String key) async {
    return strategy.delete(key);
  }

  Future<void> clear() async {
    return strategy.clear();
  }
}
