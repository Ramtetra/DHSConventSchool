import 'package:dhs_convert_school/screens/student/student_attendance_screen.dart';
import 'package:dhs_convert_school/screens/student/student_home_work_screen.dart';
import 'package:dhs_convert_school/screens/student/student_time_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/stat_card.dart';
import '../../utils/future_title.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),

      // 🔥 NAVIGATION DRAWER
      drawer: _buildDrawer(context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👋 Student Header
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rahul Sharma",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Class 8 • Section A",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📊 Stats
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  StatCard(
                    title: "Attendance",
                    value: "92%",
                    icon: Icons.fact_check,
                  ),
                  StatCard(
                    title: "Homework",
                    value: "3 Due",
                    icon: Icons.book,
                  ),
                  StatCard(
                    title: "Exams",
                    value: "2 Upcoming",
                    icon: Icons.event,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧩 Features
            Text(
              "Quick Access",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FeatureTile(icon: Icons.schedule, label: "Timetable",  onTap: () {
                  Navigator.push(
                    context,
                     MaterialPageRoute(
                      builder: (_) => const StudentTimetableScreen(),
                    ),
                  );
                },),
                FeatureTile(
                  icon: Icons.check_circle,
                  label: "Attendance",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentAttendanceScreen(),
                      ),
                    );
                  },
                ),

                 FeatureTile(icon: Icons.menu_book, label: "Homework", onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (_) => const StudentHomeworkScreen(),
                     ),
                   );
                 },),
                 FeatureTile(icon: Icons.folder, label: "Study Material", onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (_) => const StudentDashboardScreen(),
                     ),
                   );
                 },),
                 FeatureTile(icon: Icons.event_note, label: "Exams", onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (_) => const StudentDashboardScreen(),
                     ),
                   );
                 },),
                 FeatureTile(icon: Icons.bar_chart, label: "Results", onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (_) => const StudentDashboardScreen(),
                     ),
                   );
                 },),
              ],
            ),

            const SizedBox(height: 24),

            // 📢 Updates
            Text(
              "Latest Updates",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Math homework due tomorrow"),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Unit test starts next week"),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // 📌 DRAWER UI
  // ==========================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [

          // 👤 PROFILE HEADER
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF3F51B5),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
            accountName: const Text("Rahul Sharma"),
            accountEmail: const Text("Class 8 • Section A"),
          ),

          _drawerItem(Icons.dashboard, "Dashboard", () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.schedule, "Timetable", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentTimetableScreen(),
              ),
            );
          }),
          _drawerItem(Icons.fact_check, "Attendance", () {}),
          _drawerItem(Icons.menu_book, "Homework", () {}),
          _drawerItem(Icons.folder, "Study Materials", () {}),
          _drawerItem(Icons.event_note, "Exam Schedule", () {}),
          _drawerItem(Icons.bar_chart, "Results", () {}),
          _drawerItem(Icons.person, "Profile", () {}),
          _drawerItem(Icons.logout_outlined, "Logout", () {}),

          const Spacer(),

          const Divider(),

          _drawerItem(Icons.logout, "Logout", () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
