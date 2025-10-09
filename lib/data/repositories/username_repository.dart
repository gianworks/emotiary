import "package:hive_flutter/hive_flutter.dart";
import "package:emotiary/core/config/hive_config.dart";

class UsernameRepository {
  static const _usernameKey = "username";
  static final Box<String> _box = Hive.box<String>(HiveConfig.usernameBox);

  static String getUsername() => _box.get(_usernameKey) ?? "User";
  static Future<void> saveUsername(String username) async => await _box.put(_usernameKey, username);
  static bool hasUsername() => _box.containsKey(_usernameKey);
}
