import "package:hive/hive.dart";
part "entry.g.dart";

@HiveType(typeId: 0)
class Entry extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String mood;

  @HiveField(2)
  String moodEmoji;

  @HiveField(3)
  Map<String, String> activities;

  @HiveField(4)
  String titleJson;

  @HiveField(5)
  String textJson;

  Entry({ 
    required this.date, 
    required this.mood,
    required this.moodEmoji,
    required this.activities, 
    required this.titleJson, 
    required this.textJson
  });
}