import "package:emotiary/models/entry.dart";
import "package:emotiary/boxes/entry_box.dart";

class EntryRepository {
  static List<Entry> getAllEntries() => EntryBox.getEntriesBox().values.toList();
  
  static Future<void> addEntry(Entry entry) async => await EntryBox.getEntriesBox().add(entry);
  static Future<void> deleteEntry(int key) async => await EntryBox.getEntriesBox().delete(key);
}
