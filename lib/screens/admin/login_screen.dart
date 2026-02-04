import 'package:dhs/screens/student/student_dashboard_screen.dart';
import 'package:dhs/screens/teacher/teacher_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/session_manager.dart';
import 'admin_dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ Role dropdown state
  String? selectedRole; // admin, teacher, student

  void _login() async {
    final password = passwordController.text.trim();

    if (selectedRole == null) {
      _showMessage("Please select role");
      return;
    }

    if (password != '1234') {
      _showMessage("Invalid password");
      return;
    }

    // ✅ Convert String to UserRole enum
    UserRole role;

    switch (selectedRole) {
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
        _showMessage("Invalid role selected");
        return;
    }

    // ✅ SAVE SESSION (NOW CORRECT TYPE)
    await SessionManager.saveLogin(role);

    // ✅ Navigate
    Widget targetScreen;

    switch (role) {
      case UserRole.admin:
        targetScreen = const AdminDashboardScreen();
        break;
      case UserRole.teacher:
        targetScreen = const TeacherDashboardScreen();
        break;
      case UserRole.student:
        targetScreen = const StudentDashboardScreen();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
          (route) => false,
    );
  }



  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ================= UI =================
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

                      // ✅ ROLE DROPDOWN
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: "Login As",
                          prefixIcon: const Icon(Icons.person_pin),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "admin", child: Text("Admin")),
                          DropdownMenuItem(
                              value: "teacher", child: Text("Teacher")),
                          DropdownMenuItem(
                              value: "student", child: Text("Student")),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedRole = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Email / Mobile",
                          prefixIcon:
                          const Icon(Icons.person_outline),
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
                          prefixIcon:
                          const Icon(Icons.lock_outline),
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
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 16),
                          ),
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
