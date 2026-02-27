import 'package:flutter/material.dart';
import '../responsemodel/StudentDetailsModel.dart';

class StudentCard extends StatelessWidget {
  final StudentDetailsModel student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,

        /// Avatar
        leading: CircleAvatar(
          radius: 24,
          backgroundImage:
          student.imagePath != null &&
              student.imagePath!.isNotEmpty
              ? NetworkImage(student.imagePath!)
              : null,
          child: (student.imagePath == null ||
              student.imagePath!.isEmpty)
              ? Text(
            student.studentName.isNotEmpty
                ? student.studentName[0]
                .toUpperCase()
                : '?',
          )
              : null,
        ),

        /// Name
        title: Text(
          student.studentName,
          style: const TextStyle(
              fontWeight: FontWeight.w600),
        ),

        /// Class + Roll
        subtitle: Text(
          'Class ${student.classes} • Roll No: ${student.studentId}',
        ),

        trailing:
        const Icon(Icons.chevron_right),
      ),
    );
  }
}