import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_session.dart';

enum UserRole { admin, teacher, student }

class SessionManager {
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserRole = "user_role";
  static const String _keyUserName = "user_name";
  static const String _keyUserEmail = "user_email";
  static const String _keyUserMobile = "user_mobile";
  static const String _keyUserAddress = "user_address";

  // ✅ Save login session
  static Future<void> saveLogin({
    required UserRole role,
    required String name,
    required String email,
    required String mobile,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserRole, role.name);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserMobile, mobile);
    await prefs.setString(_keyUserAddress, address);
  }

  // ================= GETTERS =================

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserMobile);
  }


  static Future<String?> getUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserAddress);
  }

  static Future<UserRole?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleStr = prefs.getString(_keyUserRole);

    if (roleStr == null) return null;

    return UserRole.values.firstWhere(
          (e) => e.name == roleStr,
      orElse: () => UserRole.student,
    );
  }

  static Future<UserSession?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final mobile = prefs.getString(_keyUserMobile);
    final address = prefs.getString(_keyUserAddress);
    final role = prefs.getString(_keyUserRole);


    return UserSession(
      name: name ?? "",
      email: email ?? "",
      mobile: mobile ?? "",
      address: address ?? "",
      role: role ?? "",
    );
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}