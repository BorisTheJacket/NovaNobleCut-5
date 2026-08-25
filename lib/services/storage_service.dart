import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> savePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("SavedLink")) {
      await prefs.setString("SavedLink", path);
    }
  }
}
