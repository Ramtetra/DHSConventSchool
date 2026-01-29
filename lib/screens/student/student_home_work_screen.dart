import 'package:flutter/material.dart';
import '../../utils/home_work_card.dart';
import '../../utils/home_work_status.dart';

class StudentHomeworkScreen extends StatelessWidget {
  const StudentHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework"),
      ),

      body: Column(
        children: [

          /// Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                summaryCard("Pending", "3", Colors.orange),
                const SizedBox(width: 12),
                summaryCard("Submitted", "5", Colors.green),
              ],
            ),
          ),

          /// Homework List
          Expanded(
            child: ListView(
              children: [
                HomeworkCard(
                  subject: "Mathematics",
                  className: "Class 8-A",
                  title: "Solve chapter 5 problems",
                  teacher: "Mr. Sharma",
                  dueDate: "25 Jan",
                  status: HomeworkStatus.pending,
                ),

                HomeworkCard(
                  subject: "English",
                  className: "Class 7-B",
                  title: "Write an essay on Nature",
                  teacher: "Ms. Neha",
                  dueDate: "22 Jan",
                  status: HomeworkStatus.submitted,
                ),

                HomeworkCard(
                  subject: "Science",
                  className: "Class 5-B",
                  title: "Prepare lab notes",
                  teacher: "Dr. Verma",
                  dueDate: "20 Jan",
                  status: HomeworkStatus.late,
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget summaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(title),
          ],
        ),
      ),
    );
  }
}
