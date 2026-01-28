import 'package:dhs/screens/admin/splash_screen.dart';
import 'package:dhs/screens/student/student_dashboard_screen.dart';
import 'package:dhs/screens/teacher/teacher_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/session_manager.dart';
import '../auth/auth_provider.dart';
import 'admin_dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (password != '1234') {
      _error();
      return;
    }

    if (username == 'admin') {
      await SessionManager.saveLogin(UserRole.admin);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    }
    else if (username == 'teacher') {
      await SessionManager.saveLogin(UserRole.teacher);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
      );
    }
    else if (username == 'student') {
      await SessionManager.saveLogin(UserRole.student);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboardScreen()),
      );
    }
    else {
      _error();
    }
  }




  void _error() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid login credentials"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(Icons.school,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "DHS Convent School",
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Login to continue",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Email / Mobile",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("LOGIN",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        "Admin • Teacher • Student",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
