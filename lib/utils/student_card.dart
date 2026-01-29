import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'performance_extension.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final perf = student.performance;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: student.avatarUrl.isNotEmpty
              ? NetworkImage(student.avatarUrl)
              : null,
          child: student.avatarUrl.isEmpty
              ? Text(student.name[0])
              : null,
        ),
        title: Text(student.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${student.className} • Roll No: ${student.rollNo}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(perf.icon, size: 16, color: perf.color),
                const SizedBox(width: 4),
                Text(
                  perf.label,
                  style: TextStyle(color: perf.color),
                ),
              ],
            )
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
