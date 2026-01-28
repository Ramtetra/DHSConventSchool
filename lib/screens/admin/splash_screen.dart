import 'package:flutter/material.dart';
import 'package:dhs/utils/session_manager.dart';
import '../admin/admin_dashboard.dart';
import '../teacher/teacher_dashboard_screen.dart';
import '../student/student_dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await SessionManager.isLoggedIn();
    final role = await SessionManager.getRole();

    if (!mounted) return;

    Widget target;

    if (!isLoggedIn) {
      target = const LoginScreen();
    } else {
      switch (role) {
        case 'admin':
          target = const AdminDashboardScreen();
          break;
        case 'teacher':
          target = const TeacherDashboardScreen();
          break;
        case 'student':
          target = const StudentDashboardScreen();
          break;
        default:
          target = const LoginScreen();
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005B85),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 90,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                'DHS',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digital School System',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
