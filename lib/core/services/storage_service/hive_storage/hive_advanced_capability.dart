import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_management/core/services/storage_service/hive_storage/hive_capability.dart';

abstract class HiveAdvancedCapabilities extends HiveStorageCapabilities {
  Future<void> compact(String boxName);
  Stream<BoxEvent> watch(String boxName);
}
