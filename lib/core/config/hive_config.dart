import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/data/models/entry.dart";

class HiveConfig {
  static const String entryBox = "entries";

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(EntryAdapter());

    // Open boxes
    await Hive.openBox<Entry>(entryBox);
  }
}
