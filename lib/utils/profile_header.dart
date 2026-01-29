import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final teacher;

  const ProfileHeader({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: teacher.avatarUrl.isNotEmpty
                  ? NetworkImage(teacher.avatarUrl)
                  : null,
              child: teacher.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(teacher.subject),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: teacher.classes
                        .map(
                          (c) => Chip(
                        label: Text(c, style: const TextStyle(fontSize: 12)),
                      ),
                    )
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
