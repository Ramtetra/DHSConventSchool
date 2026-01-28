import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/auth/auth_provider.dart';
import 'drawer_items.dart';

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
              Navigator.pushNamed(context, "/studentList");
            },
          ),

          DrawerItem(
            icon: Icons.school,
            title: "Teachers",
            onTap: () {
              Navigator.pushNamed(context, "/teacherList");
            },
          ),

          DrawerItem(
            icon: Icons.fact_check,
            title: "Attendance",
            onTap: () {
              Navigator.pushNamed(context, "/attendanceReport");
            },
          ),

          DrawerItem(
            icon: Icons.payments,
            title: "Fee Report",
            onTap: () {
              Navigator.pushNamed(context, "/feeReport");
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
            color: Colors.red,
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
