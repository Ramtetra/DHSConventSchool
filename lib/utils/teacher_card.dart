import 'package:flutter/material.dart';
import '../models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherModel teacher;
  final VoidCallback onTap;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   // final isActive = teacher.status == TeacherStatus.active;
    final imageUrl = teacher.imagePath;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        // 🖼 PROFILE IMAGE
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
              ? NetworkImage(imageUrl) // ✅ FROM API
              : const AssetImage('assets/images/user.png')
          as ImageProvider, // ✅ DEFAULT IMAGE
        ),
        title: Text(
          teacher.teacherName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teacher.subjects.first),
            Text(teacher.email),
          ],
        ),
       /* trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(isActive ? 'Active' : 'Inactive'),
              backgroundColor:
              (isActive ? Colors.green : Colors.grey).withOpacity(0.15),
              labelStyle: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}
