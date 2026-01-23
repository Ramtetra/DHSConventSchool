import 'package:flutter/material.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [

          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blue],
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 36),
            ),
            accountName: const Text("Anita Sharma"),
            accountEmail: const Text("Maths Teacher"),
          ),

          _DrawerItem(Icons.dashboard, "Dashboard", () {
            Navigator.pop(context);
          }),
          _DrawerItem(Icons.check_circle, "Attendance", () {}),
          _DrawerItem(Icons.menu_book, "Homework", () {}),
          _DrawerItem(Icons.edit_note, "Marks Entry", () {}),
          _DrawerItem(Icons.people, "My Classes", () {}),
          const Divider(),
          _DrawerItem(Icons.settings, "Settings", () {}),
          _DrawerItem(Icons.logout, "Logout", () {}, color: Colors.red),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem(this.icon, this.title, this.onTap, {this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.black87),
      ),
      onTap: onTap,
    );
  }
}
