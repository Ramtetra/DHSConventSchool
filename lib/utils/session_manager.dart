import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/auth_provider.dart';

class SessionManager {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserRole = 'user_role';

  static Future<void> saveLogin(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserRole, role.name); // admin / teacher / student
  }


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<UserRole?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleStr = prefs.getString(_keyUserRole);
    if (roleStr == null) return null;
    return UserRole.values.firstWhere((e) => e.name == roleStr);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
