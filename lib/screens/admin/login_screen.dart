import 'package:dhs/screens/student/student_dashboard_screen.dart';
import 'package:dhs/screens/teacher/teacher_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
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

  String? selectedRole;

  bool isLoading = false;

  // ================= LOGIN FUNCTION =================
  void _login() async {
    final input = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (selectedRole == null) {
      _showMessage("Please select role");
      return;
    }

    if (input.isEmpty) {
      _showMessage("Enter email or mobile");
      return;
    }

    if (password.isEmpty) {
      _showMessage("Enter password");
      return;
    }

    // ✅ Detect email or mobile
    bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input);
    bool isMobile = RegExp(r'^[0-9]{10}$').hasMatch(input);

    if (!isEmail && !isMobile) {
      _showMessage("Enter valid email or 10-digit mobile number");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ref.read(loginProvider({
        "email": input,   // ✅ ALWAYS PASS INPUT
        "password": password,
        "role": selectedRole!
      }).future);

      if (!result.success) {
        _showMessage(result.message);
        setState(() => isLoading = false);
        return;
      }

      // ✅ Role mapping
      String apiRole = result.data.role;

      UserRole role;
      switch (apiRole.toLowerCase()) {
        case "admin":
          role = UserRole.admin;
          break;
        case "teacher":
          role = UserRole.teacher;
          break;
        case "student":
          role = UserRole.student;
          break;
        default:
          _showMessage("Invalid role");
          setState(() => isLoading = false);
          return;
      }

      // ✅ Save session
      await SessionManager.saveLogin(
        role: role,
        name: result.data.name,
        email: result.data.email,
        mobile: result.data.mobile,
        address: result.data.address,
      );

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
    } catch (e) {
      _showMessage("Login failed");
    }

    setState(() => isLoading = false);
  }

  // ================= SNACKBAR =================
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

                      // ROLE DROPDOWN
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

                      // EMAIL / MOBILE
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email / Mobile",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PASSWORD
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

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
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