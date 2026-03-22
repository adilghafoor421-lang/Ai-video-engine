import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/script_model.dart';

class StorageService {
  static const String _apiKeyKey = 'anthropic_api_key';
  static const String _scriptsKey = 'saved_scripts';

  Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, key);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  Future<void> saveScript(ScriptModel script) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_scriptsKey) ?? [];
    existing.insert(0, jsonEncode(script.toJson()));
    if (existing.length > 50) existing.removeLast();
    await prefs.setStringList(_scriptsKey, existing);
  }

  Future<List<ScriptModel>> getAllScripts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_scriptsKey) ?? [];
    return data.map((s) => ScriptModel.fromJson(jsonDecode(s))).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scriptsKey);
  }
}
