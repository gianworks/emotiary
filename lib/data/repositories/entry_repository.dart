import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/data/models/entry.dart";
import "package:emotiary/core/config/hive_config.dart";

class EntryRepository {
  static final Box<Entry> _box = Hive.box<Entry>(HiveConfig.entriesBox);

  static List<Entry> getAll() => _box.values.toList();
  static Future<void> add(Entry entry) async => await _box.add(entry);
  static Future<void> deleteAll() async => await _box.clear();
}
