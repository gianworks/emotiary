import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/models/entry.dart";

class EntryBox {
  static const String entries = "entries";

  static Future<void> initEntriesBox() async {
    Hive.registerAdapter(EntryAdapter());
    await Hive.openBox<Entry>(entries);
  }

  static Box<Entry> getEntriesBox() => Hive.box<Entry>(entries);
}
