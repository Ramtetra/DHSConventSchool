import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/summary_card.dart';

class StudentAttendanceScreen extends ConsumerStatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  ConsumerState<StudentAttendanceScreen> createState() =>
      StudentAttendanceScreenState();
}

class StudentAttendanceScreenState
    extends ConsumerState<StudentAttendanceScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 Student Info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  "Rahul Sharma",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Class 8 • Section A"),
              ),
            ),

            const SizedBox(height: 20),

            // 📊 Attendance Summary
            Row(
            children: [
            SummaryCard(title: "Present", value: "22", color: Colors.green),
            SummaryCard(title: "Absent", value: "3", color: Colors.red),
            SummaryCard(title: "Leave", value: "2", color: Colors.orange),
            ],
            ),

            const SizedBox(height: 24),

            // 📈 Percentage
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        value: 0.88,
                        strokeWidth: 8,
                        color: theme.primaryColor,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Attendance Percentage",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text("88%",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📅 History
            Text(
              "Attendance History",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            attendanceTile("01 Aug 2026", "Present", Colors.green),
            attendanceTile("02 Aug 2026", "Present", Colors.green),
            attendanceTile("03 Aug 2026", "Absent", Colors.red),
            attendanceTile("04 Aug 2026", "Leave", Colors.orange),
            attendanceTile("05 Aug 2026", "Present", Colors.green),
          ],
        ),
      ),
    );
  }
}
