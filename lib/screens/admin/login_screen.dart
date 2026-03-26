import 'package:dhs/screens/student/student_dashboard_screen.dart';
import 'package:dhs/screens/teacher/teacher_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/session_manager.dart';
import '../../models/user_session.dart';
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
  bool _obscurePassword = true;

  // ================= LOGIN FUNCTION =================
  Future<void> _login() async {
    final input = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (selectedRole == null) {
      _showMessage("Please select role", isError: true);
      return;
    }

    if (input.isEmpty) {
      _showMessage("Enter email or mobile", isError: true);
      return;
    }

    if (password.isEmpty) {
      _showMessage("Enter password", isError: true);
      return;
    }

    // ✅ Detect email or mobile
    bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input);
    bool isMobile = RegExp(r'^[0-9]{10}$').hasMatch(input);

    if (!isEmail && !isMobile) {
      _showMessage("Enter valid email or 10-digit mobile number", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ref.read(loginProvider({
        "email": input,
        "password": password,
        "role": selectedRole!
      }).future);

      if (!result.success) {
        _showMessage(result.message, isError: true);
        setState(() => isLoading = false);
        return;
      }

      // ✅ Get user data from response
      final userData = result.data;
      final apiRole = userData.role.toLowerCase();

      // ✅ Determine UserRole enum
      UserRole role;
      switch (apiRole) {
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
          _showMessage("Invalid role", isError: true);
          setState(() => isLoading = false);
          return;
      }

      // ✅ Create UserSession object with complete data
      final userSession = UserSession(
        name: userData.name,
        email: userData.email,
        mobile: userData.mobile,
        address: userData.address,
        role: role,
        // Common fields
        gender: userData.gender,
        rollNo: userData.rollNo,
        imagePath: userData.imagePath,
        // Admin fields
        adminId: userData.adminId,
        cDt: userData.cDt,
        uDt: userData.uDt,
        // Teacher fields
        teacherId: userData.teacherId,
        qualification: userData.qualification,
        experience: userData.experience,
        classes: userData.classes,
        subjects: userData.subjects,
        assignedClass: userData.assignedClass,
        // Student fields
        studentId: userData.studentId,
        dob: userData.dob,
        parentName: userData.parentName,
        studentClass: userData.studentClass,
        section: userData.section,
      );

      // ✅ Save session using SessionManager
      await SessionManager.saveSession(userSession);

      // ✅ Debug print to verify saved data
      print('=== Login Successful ===');
      print('Role: ${role.name}');
      print('Name: ${userData.name}');
      print('Email: ${userData.email}');
      print('Mobile: ${userData.mobile}');
      print('Address: ${userData.address}');
      print('Image Path: ${userData.imagePath}');

      if (role == UserRole.student) {
        print('Student ID: ${userData.studentId}');
        print('Class: ${userData.studentClass}');
        print('Section: ${userData.section}');
        print('Parent: ${userData.parentName}');
        print('DOB: ${userData.dob}');
      } else if (role == UserRole.teacher) {
        print('Teacher ID: ${userData.teacherId}');
        print('Gender: ${userData.gender}');
        print('Qualification: ${userData.qualification}');
        print('Experience: ${userData.experience}');
        print('Classes: ${userData.classes}');
        print('Subjects: ${userData.subjects}');
      } else if (role == UserRole.admin) {
        print('Admin ID: ${userData.adminId}');
        print('Created Date: ${userData.cDt}');
        print('Updated Date: ${userData.uDt}');
      }

      // ✅ Navigate to appropriate dashboard
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

      _showMessage("Welcome ${userData.name}!", isError: false);

    } catch (e) {
      print('Login error: $e');
      _showMessage("Login failed. Please try again.", isError: true);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= SNACKBAR =================
  void _showMessage(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
                        textInputAction: TextInputAction.next,
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
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(), // ✅ Fixed: onFieldSubmitted instead of onSubmitted
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
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
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}