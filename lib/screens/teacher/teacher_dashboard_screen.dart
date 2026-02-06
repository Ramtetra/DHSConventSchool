import 'package:dhs/screens/teacher/teacher_attendance_screen.dart';
import 'package:dhs/screens/teacher/teacher_homework_screen.dart';
import 'package:dhs/screens/teacher/teacher_mark_entry_screen.dart';
import 'package:dhs/screens/teacher/teacher_notice_screen.dart';
import 'package:dhs/screens/teacher/teacher_profile_screen.dart';
import 'package:dhs/screens/teacher/teacher_student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/class_title.dart';
import '../../utils/teacher_action_tile.dart';
import '../../utils/teacher_drawer.dart';
import '../../utils/teacher_state_card.dart';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});
  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),

      // ✅ Drawer
      drawer: const TeacherDrawer(),

      body: SingleChildScrollView(
       // padding: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👤 Teacher Profile Card
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
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Anita Sharma",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Maths • Class 8–10",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 Today Summary
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TeacherStatCard(
                    title: "Classes",
                    value: "5 Today",
                    icon: Icons.class_,
                  ),
                  TeacherStatCard(
                    title: "Attendance",
                    value: "2 Pending",
                    icon: Icons.fact_check,
                  ),
                  TeacherStatCard(
                    title: "Homework",
                    value: "3 Review",
                    icon: Icons.menu_book,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ⚡ Quick Actions
            Text(
              "Quick Actions",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:  [
                TeacherActionTile(icon: Icons.check_circle, label: "Attendance", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherAttendanceScreen(),
                    ),
                  );
                },),
                TeacherActionTile(icon: Icons.upload_file, label: "Homework",onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherHomeworkScreen(),
                    ),
                  );
                },),
                TeacherActionTile(icon: Icons.people, label: "Students",onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherStudentListScreen(),
                    ),
                  );
                },),
                TeacherActionTile(icon: Icons.edit_note, label: "Marks Entry",onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherMarkEntryScreen(),
                    ),
                  );
                },),
                TeacherActionTile(icon: Icons.notifications, label: "Notices",onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherNoticeScreen(),
                    ),
                  );
                },),
                TeacherActionTile(icon: Icons.person, label: "Profile",onTap: () {
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherProfileScreen(),
                    ),
                  );*/
                },),
              ],
            ),

            const SizedBox(height: 24),

            /// 🏫 My Classes
            Text(
              "My Classes",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const ClassTile(className: "Class 8 A"),
            const ClassTile(className: "Class 9 B"),
            const ClassTile(className: "Class 10 C"),
          ],
        ),
      ),
    );
  }
}
