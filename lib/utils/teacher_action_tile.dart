import 'package:flutter/material.dart';

class TeacherActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap; // 👈 add this

  const TeacherActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap, // 👈 required
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap, // 👈 use callback
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
