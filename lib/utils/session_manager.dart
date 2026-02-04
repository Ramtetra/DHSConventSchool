import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { admin, teacher, student }

class SessionManager {
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserRole = "user_role";

  // Save login session
  static Future<void> saveLogin(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserRole, role.name);
  }

  // Check login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get role
  static Future<UserRole?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleStr = prefs.getString(_keyUserRole);
    if (roleStr == null) return null;
    return UserRole.values.firstWhere(
          (e) => e.name == roleStr,
      orElse: () => UserRole.student,
    );
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
