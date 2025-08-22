import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Create a singleton instance (only one instance will exist)
  static final PreferencesService _instance = PreferencesService._internal();

  // Private named constructor to prevent creating new instances
  PreferencesService._internal();

  // Ensure the same instance is always returned
  factory PreferencesService() => _instance;

  // SharedPreferences instance used to store/retrieve data
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences (must be called in main before using this service)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _entriesData = "entries_data";

  Future<void> addEntry(Map entry) async {
    final String? entriesData = _prefs?.getString(_entriesData);
    List<dynamic> entries = entriesData != null ? jsonDecode(entriesData) : [];
    entries.add(entry);

    await _prefs?.setString(_entriesData, jsonEncode(entries));
  }

   Future<void> deleteEntry(Map entry) async {
    final String? entriesData = _prefs?.getString(_entriesData);
    if (entriesData == null) return;
    List<dynamic> entries = jsonDecode(entriesData);
    entries.removeWhere((item) => item["id"] == entry["id"]);

    await _prefs?.setString(_entriesData, jsonEncode(entries));
  }

  List<dynamic> getEntries() {
    final String? entriesData = _prefs?.getString(_entriesData);
    List<dynamic> entries = entriesData != null ? jsonDecode(entriesData) : [];
    return entries;
  }

  void deleteEntries() async {
    await _prefs?.remove(_entriesData);
  }

}
