import 'package:flutter/material.dart';

import '../../utils/attendance_summary_card.dart';
import '../../utils/student_attendance_title.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  String selectedClass = "Class 8 A";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        //padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🏫 Class Selector
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedClass,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "Class 8 A",
                        child: Text("Class 8 A"),
                      ),
                      DropdownMenuItem(
                        value: "Class 9 B",
                        child: Text("Class 9 B"),
                      ),
                      DropdownMenuItem(
                        value: "Class 10 C",
                        child: Text("Class 10 C"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedClass = value!;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 Attendance Summary
            Row(
              children: const [
                AttendanceSummaryCard(
                  title: "Present",
                  count: "28",
                  color: Colors.green,
                ),
                AttendanceSummaryCard(
                  title: "Absent",
                  count: "4",
                  color: Colors.red,
                ),
                AttendanceSummaryCard(
                  title: "Leave",
                  count: "2",
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 👩‍🎓 Student List
            Text(
              "Student Attendance",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const StudentAttendanceTile(
              name: "Rahul Sharma",
              rollNo: "01",
            ),
            const StudentAttendanceTile(
              name: "Ananya Verma",
              rollNo: "02",
            ),
            const StudentAttendanceTile(
              name: "Rohit Singh",
              rollNo: "03",
            ),
            const StudentAttendanceTile(
              name: "Priya Patel",
              rollNo: "04",
            ),
          ],
        ),
      ),

      /// ✅ Submit Button
      bottomNavigationBar: Padding(
        //padding: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Submit Attendance",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
