import 'package:shared_preferences/shared_preferences.dart';

class FileManager {
  static get context => null;
  // =============== Maintenance Settings ==================
  
  static Future saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future saveInteger(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future saveList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if(value == null) {
      return '';
    }
    return value;
  }

  static Future<int> readInteger(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(key);
    if(value == null) {
      return 0;
    }
    return value;
  }

  static Future<List<String>> readStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? value = prefs.getStringList(key);
    if(value == null) {
      return [];
    }
    return value;
  }
}
