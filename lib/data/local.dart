import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences sp;
  static Future initialize() async {
    sp = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return sp.getString(key);
  }

  static Future<bool> setString(String value, String key) async {
    return await sp.setString(key, value);
  }
}
