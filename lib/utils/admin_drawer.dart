import 'package:dhs/screens/admin/admin_attendance_screen.dart';
import 'package:dhs/screens/admin/admin_fee_report_screen.dart';
import 'package:dhs/screens/admin/admin_teacher_list_screen.dart';
import 'package:dhs/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/admin/login_screen.dart';
import '../screens/teacher/teacher_student_list_screen.dart';
import 'drawer_items.dart';
import 'logout_dialog.dart';

class AdminDrawer extends ConsumerWidget   {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
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
            accountName: const Text(
              "Admin User",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("admin@school.com"),
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
              MaterialPageRoute(builder: (_) => const AdminTeacherListScreen()),
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
                    builder: (_) => const AdminFeeReportScreen(),),
              );
            },
          ),

          DrawerItem(
            icon: Icons.edit_note,
            title: "Exam Management",
            onTap: () {
              Navigator.pushNamed(context, "/examManagement");
            },
          ),

          const Divider(),

          DrawerItem(
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),

          DrawerItem(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              Navigator.pop(context); // close drawer
              // 🔥 Wait for drawer to close, then show dialog
              Future.delayed(const Duration(milliseconds: 300), () {
                showLogoutDialog(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
/*Future<void> showLogoutDialogAdmin(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                debugPrint('YES clicked');

                // Close dialog first
                Navigator.of(dialogContext, rootNavigator: true).pop();

                // 🔥 SAFETY DELAY
                await Future.delayed(const Duration(milliseconds: 100));

                // Clear session safely
                await SessionManager.logout();
                debugPrint('Session cleared');

                // ✅ Navigate to LoginScreen using dialogContext (always valid)
                Navigator.of(dialogContext, rootNavigator: true)
                    .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              } catch (e, stack) {
                debugPrint('LOGOUT ERROR: $e');
                debugPrint('STACK: $stack');
              }
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}*/


