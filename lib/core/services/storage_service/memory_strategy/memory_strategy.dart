import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';

@Named('memory_storage')
@singleton
class MemoryStorageStrategy implements StorageStrategy {
  final Map<String, dynamic> _map;

  MemoryStorageStrategy() : _map = {};

  @override
  Future<void> write(String key, value) async {
    _map[key] = value;
  }

  @override
  Future<T?> read<T>(String key) async {
    return _map[key] as T?;
  }

  @override
  Future<void> delete(String key) async {
    _map.remove(key);
  }

  @override
  Future<void> clear() async {
    _map.clear();
  }

  @override
  T? readSync<T>(String key) {
    // TODO: implement readSync
    throw UnimplementedError();
  }
}
