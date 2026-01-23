import 'package:dhs_convert_school/screens/admin/admin_dashboard.dart';
import 'package:dhs_convert_school/screens/admin/login_screen.dart';
import 'package:dhs_convert_school/screens/student/student_dashboard_screen.dart';
import 'package:dhs_convert_school/screens/student/student_time_table_screen.dart';
import 'package:dhs_convert_school/utils/time_table_card.dart';
import 'package:dhs_convert_school/screens/teacher/teacher_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import other screens when ready

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'DHSConvert',

      themeMode: ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF005B85),

        fontFamily: GoogleFonts.lato().fontFamily,
        textTheme: GoogleFonts.latoTextTheme(),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF005B85),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginScreen(),
        // Later usage
       '/admin': (context) => const AdminDashboardScreen(),
        '/teacher': (context) => const TeacherDashboardScreen(),
       '/student': (context) => const StudentDashboardScreen(),
        '/parent': (context) => const StudentTimetableScreen(),
      },
    );
  }
}
