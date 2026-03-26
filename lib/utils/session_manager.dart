// lib/utils/session_manager.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_session.dart';

// Export UserRole for easy access
export '../models/user_session.dart' show UserRole;

class SessionManager {
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserSession = "user_session";

  // Legacy keys for backward compatibility
  static const String _keyUserRole = "user_role";
  static const String _keyUserName = "user_name";
  static const String _keyUserEmail = "user_email";
  static const String _keyUserMobile = "user_mobile";
  static const String _keyUserAddress = "user_address";

  // Teacher-specific keys
  static const String _keyTeacherId = "teacher_id";
  static const String _keyGender = "gender";
  static const String _keyQualification = "qualification";
  static const String _keyExperience = "experience";

  // Student-specific keys
  static const String _keyStudentId = "student_id";
  static const String _keyDob = "dob";
  static const String _keyParentName = "parent_name";
  static const String _keyCDt = "c_dt";
  static const String _keyStudentClass = "student_class";
  static const String _keySection = "section";

  // ✅ Save complete session
  static Future<void> saveSession(UserSession userSession) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save as JSON for easy retrieval
      final jsonString = jsonEncode(userSession.toJson());
      await prefs.setString(_keyUserSession, jsonString);
      await prefs.setBool(_keyIsLoggedIn, true);

      // Also save individual fields for backward compatibility
      await prefs.setString(_keyUserRole, userSession.role.name);
      await prefs.setString(_keyUserName, userSession.name);
      await prefs.setString(_keyUserEmail, userSession.email);
      await prefs.setString(_keyUserMobile, userSession.mobile);
      await prefs.setString(_keyUserAddress, userSession.address);

      // Save role-specific fields
      if (userSession.role == UserRole.teacher) {
        if (userSession.teacherId != null) {
          await prefs.setString(_keyTeacherId, userSession.teacherId!);
        }
        if (userSession.gender != null) {
          await prefs.setString(_keyGender, userSession.gender!);
        }
        if (userSession.qualification != null) {
          await prefs.setString(_keyQualification, userSession.qualification!);
        }
        if (userSession.experience != null) {
          await prefs.setString(_keyExperience, userSession.experience!);
        }
      } else if (userSession.role == UserRole.student) {
        if (userSession.studentId != null) {
          await prefs.setString(_keyStudentId, userSession.studentId!);
        }
        if (userSession.dob != null) {
          await prefs.setString(_keyDob, userSession.dob!);
        }
        if (userSession.parentName != null) {
          await prefs.setString(_keyParentName, userSession.parentName!);
        }
        if (userSession.cDt != null) {
          await prefs.setString(_keyCDt, userSession.cDt!);
        }
        if (userSession.studentClass != null) {
          await prefs.setString(_keyStudentClass, userSession.studentClass!);
        }
        if (userSession.section != null) {
          await prefs.setString(_keySection, jsonEncode(userSession.section));
        }
      }

      print('Session saved successfully for role: ${userSession.role.name}');
    } catch (e) {
      print('Error saving session: $e');
      rethrow;
    }
  }

  // ✅ Get complete user session
  static Future<UserSession?> getUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_keyUserSession);

      if (sessionJson != null && sessionJson.isNotEmpty) {
        try {
          final Map<String, dynamic> json = jsonDecode(sessionJson);
          return UserSession.fromJson(json);
        } catch (e) {
          print('Error parsing session JSON: $e');
          // If JSON parsing fails, fall back to individual fields
          return await _getSessionFromIndividualFields();
        }
      }

      return await _getSessionFromIndividualFields();
    } catch (e) {
      print('Error getting user session: $e');
      return null;
    }
  }

  // Fallback method to get session from individual fields
  static Future<UserSession?> _getSessionFromIndividualFields() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final roleStr = prefs.getString(_keyUserRole);
      if (roleStr == null) return null;

      // Parse role string to enum
      UserRole role;
      switch (roleStr.toLowerCase()) {
        case 'admin':
          role = UserRole.admin;
          break;
        case 'teacher':
          role = UserRole.teacher;
          break;
        case 'student':
          role = UserRole.student;
          break;
        default:
          role = UserRole.student;
      }

      final name = prefs.getString(_keyUserName) ?? '';
      final email = prefs.getString(_keyUserEmail) ?? '';
      final mobile = prefs.getString(_keyUserMobile) ?? '';
      final address = prefs.getString(_keyUserAddress) ?? '';

      switch (role) {
        case UserRole.teacher:
          return UserSession(
            name: name,
            email: email,
            mobile: mobile,
            address: address,
            role: UserRole.teacher,
            teacherId: prefs.getString(_keyTeacherId),
            gender: prefs.getString(_keyGender),
            qualification: prefs.getString(_keyQualification),
            experience: prefs.getString(_keyExperience),
          );

        case UserRole.student:
          String? sectionJson = prefs.getString(_keySection);
          List<String>? section;
          if (sectionJson != null && sectionJson.isNotEmpty) {
            try {
              final decoded = jsonDecode(sectionJson);
              if (decoded is List) {
                section = List<String>.from(decoded.map((s) => s.toString()));
              }
            } catch (e) {
              print('Error parsing section JSON: $e');
              section = null;
            }
          }

          return UserSession(
            name: name,
            email: email,
            mobile: mobile,
            address: address,
            role: UserRole.student,
            studentId: prefs.getString(_keyStudentId),
            dob: prefs.getString(_keyDob),
            parentName: prefs.getString(_keyParentName),
            cDt: prefs.getString(_keyCDt),
            studentClass: prefs.getString(_keyStudentClass),
            section: section,
          );

        case UserRole.admin:
          return UserSession(
            name: name,
            email: email,
            mobile: mobile,
            address: address,
            role: UserRole.admin,
          );
      }
    } catch (e) {
      print('Error getting session from individual fields: $e');
      return null;
    }
  }

  // ✅ Get user role
  static Future<UserRole?> getUserRole() async {
    final session = await getUserSession();
    return session?.role;
  }

  // ✅ Get user name
  static Future<String?> getUserName() async {
    final session = await getUserSession();
    return session?.name;
  }

  // ✅ Get user email
  static Future<String?> getUserEmail() async {
    final session = await getUserSession();
    return session?.email;
  }

  // ✅ Get user mobile
  static Future<String?> getUserMobile() async {
    final session = await getUserSession();
    return session?.mobile;
  }

  // ✅ Get user address
  static Future<String?> getUserAddress() async {
    final session = await getUserSession();
    return session?.address;
  }

  // ✅ Teacher-specific getters
  static Future<String?> getTeacherId() async {
    final session = await getUserSession();
    return session?.teacherId;
  }

  static Future<String?> getTeacherGender() async {
    final session = await getUserSession();
    return session?.gender;
  }

  static Future<String?> getTeacherQualification() async {
    final session = await getUserSession();
    return session?.qualification;
  }

  static Future<String?> getTeacherExperience() async {
    final session = await getUserSession();
    return session?.experience;
  }

  // ✅ Student-specific getters
  static Future<String?> getStudentId() async {
    final session = await getUserSession();
    return session?.studentId;
  }

  static Future<String?> getStudentDob() async {
    final session = await getUserSession();
    return session?.dob;
  }

  static Future<String?> getStudentParentName() async {
    final session = await getUserSession();
    return session?.parentName;
  }

  static Future<String?> getStudentClass() async {
    final session = await getUserSession();
    return session?.studentClass;
  }

  static Future<List<String>?> getStudentSection() async {
    final session = await getUserSession();
    return session?.section;
  }

  // ✅ Check if logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      return false;
    }
  }

  // ✅ Logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}