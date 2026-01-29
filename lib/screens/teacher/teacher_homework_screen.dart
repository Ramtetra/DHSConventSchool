import 'package:flutter/material.dart';

import '../../utils/home_work_card.dart';
import '../../utils/home_work_status.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  final List<Map<String, dynamic>> homeworkList = [
    {
      'subject': 'Mathematics',
      'className': 'Class 8-A',
      'title': 'Algebra Practice',
      'teacher': 'Mr. Sharma',
      'dueDate': '12 Feb 2026',
      'status': HomeworkStatus.pending,
    },
    {
      'subject': 'Science',
      'className': 'Class 7-B',
      'title': 'Human Digestive System',
      'teacher': 'Ms. Neha',
      'dueDate': '10 Feb 2026',
      'status': HomeworkStatus.submitted,
    },
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Add Homework Screen
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Homework"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: homeworkList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final hw = homeworkList[index];
            return HomeworkCard(
              subject: hw['subject'],
              className: hw['className'],
              title: hw['title'],
              teacher: hw['teacher'],
              dueDate: hw['dueDate'],
              status: hw['status'],
            );
          },
        ),
      ),
    );
  }
}
