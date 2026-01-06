import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveStorageCapabilities {
  Future<void> openBox(String name);
  bool isBoxOpen(String name);
  Box getBox(String name);
  Future<void> registerAdapters();
}
