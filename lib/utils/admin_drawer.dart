import 'package:dhs/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/admin/admin_attendance_screen.dart';
import '../screens/admin/admin_fee_report_screen.dart';
import '../screens/admin/admin_teacher_list_screen.dart';
import '../screens/teacher/teacher_student_list_screen.dart';
import 'drawer_items.dart';
import 'logout_dialog.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: FutureBuilder(
        future: SessionManager.getUser(),
        builder: (context, snapshot) {

          String name = "Admin User";
          String email = "admin@school.com";

          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            name = user.name;
            email = user.email;
          }

          return Column(
            children: [

              // 👤 HEADER
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF005B85), Color(0xFF1976D2)],
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person, size: 36),
                ),
                accountName: Text(
                  name, // ✅ dynamic name
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  email, // ✅ dynamic email
                ),
              ),

              DrawerItem(
                icon: Icons.dashboard,
                title: "Dashboard",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              DrawerItem(
                icon: Icons.groups,
                title: "Students",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherStudentListScreen(),
                    ),
                  );
                },
              ),

              DrawerItem(
                icon: Icons.school,
                title: "Teachers",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminTeacherListScreen(),
                    ),
                  );
                },
              ),

              DrawerItem(
                icon: Icons.fact_check,
                title: "Attendance",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminAttendanceScreen(),
                    ),
                  );
                },
              ),

              DrawerItem(
                icon: Icons.payments,
                title: "Fee Report",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminFeeReportScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              DrawerItem(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    showLogoutDialog(context);
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}