import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../storage_contract/storage_contract.dart';
import 'hive_capability.dart';

@Named('hive_storage')
@Singleton(as: StorageStrategy)
class HiveStorageStrategy implements StorageStrategy, HiveStorageCapabilities {
  Box? _box;

  HiveStorageStrategy();

  // Initialize Hive and optionally open a default box
  @PostConstruct()
  Future<void> init([String defaultBox = 'jalwa_box']) async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    await registerAdapters();

    await openBox(defaultBox);
  }

  @override
  Future<void> registerAdapters() async {
    // put adapters here
  }

  @override
  Future<void> openBox(String name) async {
    if (!Hive.isBoxOpen(name)) {
      _box = await Hive.openBox(name);
    } else {
      _box = Hive.box(name);
    }
  }

  @override
  bool isBoxOpen(String name) => Hive.isBoxOpen(name);

  @override
  Box getBox(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw Exception("Box '$name' is not open. Call openBox() first.");
    }
    return Hive.box(name);
  }

  // Set active box to use for StorageStrategy operations
  void useBox(String name) {
    _box = Hive.box(name);
  }

  Box get _currentBox {
    if (_box == null) {
      throw Exception("Hive box not opened. Call init() or openBox() first.");
    }
    return _box!;
  }

  // REQUIRED BY StorageStrategy

  @override
  Future<void> write(String key, dynamic value) async {
    await _currentBox.put(key, value);
  }

  @override
  Future<T?> read<T>(String key) async {
    return _currentBox.get(key) as T?;
  }

  @override
  T? readSync<T>(String key) {
    return _currentBox.get(key) as T?;
  }

  @override
  Future<void> delete(String key) async {
    await _currentBox.delete(key);
  }

  @override
  Future<void> clear() async {
    await _currentBox.clear();
  }
}
