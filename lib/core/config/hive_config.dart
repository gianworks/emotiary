import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/data/models/entry.dart";

class HiveConfig {
  static const String usernameBox = "username";
  static const String entriesBox = "entries";

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(EntryAdapter());

    // Open boxes
    await Hive.openBox<String>(usernameBox);
    await Hive.openBox<Entry>(entriesBox);
  }
}
