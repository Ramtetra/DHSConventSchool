import 'package:flutter/material.dart';

import 'home_work_status.dart';

class HomeworkStatusChip extends StatelessWidget {
  final HomeworkStatus status;

  const HomeworkStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case HomeworkStatus.submitted:
        return Colors.green;
      case HomeworkStatus.late:
        return Colors.red;
      case HomeworkStatus.pending:
      return Colors.orange;
    }
  }

  IconData get _icon {
    switch (status) {
      case HomeworkStatus.submitted:
        return Icons.check_circle;
      case HomeworkStatus.late:
        return Icons.warning_amber_rounded;
      case HomeworkStatus.pending:
      return Icons.schedule;
    }
  }

  String get _text {
    switch (status) {
      case HomeworkStatus.submitted:
        return "Submitted";
      case HomeworkStatus.late:
        return "Late";
      case HomeworkStatus.pending:
      return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: _color),
          const SizedBox(width: 6),
          Text(
            _text,
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
