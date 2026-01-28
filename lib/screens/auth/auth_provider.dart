import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { admin, teacher, student, none }

class AuthState {
  final bool isLoggedIn;
  final UserRole role;

  AuthState({required this.isLoggedIn, required this.role});
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
      : super(AuthState(isLoggedIn: false, role: UserRole.none)) {
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (role != null) {
      state = AuthState(
        isLoggedIn: true,
        role: UserRole.values.firstWhere((e) => e.name == role),
      );
    }
  }

  Future<void> login(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role.name);

    state = AuthState(isLoggedIn: true, role: role);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    state = AuthState(isLoggedIn: false, role: UserRole.none);
  }
}
