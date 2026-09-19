import 'package:shared_preferences/shared_preferences.dart';

class ApiUrlStorage {
  static const _key = 'api_base_url';
  static const _defaultUrl = 'http://172.20.10.8:5000';

  static Future<String> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? _defaultUrl;
  }

  static Future<void> saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, url);
  }
}
