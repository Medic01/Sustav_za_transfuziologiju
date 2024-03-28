import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const userIdKey = 'user_id';

  late final String userId;
  late final SharedPreferences preferences;

  Future<void> setUserId(String userId) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString(userIdKey, userId);
  }

  Future<String?> getUserId() async {
    preferences = await SharedPreferences.getInstance();

    String? userId;
    userId = preferences.getString(userIdKey);

    return userId;
  }

// TODO -> set this on logout
  clearAll() async {
    preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  setUserLoggedIn(bool bool) {}
}
