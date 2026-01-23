import 'package:flutter/material.dart';

import 'home_work_status.dart';

class HomeworkCard extends StatelessWidget {
  final String subject;
  final String title;
  final String teacher;
  final String dueDate;
  final HomeworkStatus status;

  const HomeworkCard({
    super.key,
    required this.subject,
    required this.title,
    required this.teacher,
    required this.dueDate,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case HomeworkStatus.submitted:
        return Colors.green;
      case HomeworkStatus.late:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String get statusText {
    switch (status) {
      case HomeworkStatus.submitted:
        return "Submitted";
      case HomeworkStatus.late:
        return "Late";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Subject + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subject,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(statusText),
                  backgroundColor: statusColor.withOpacity(0.15),
                  labelStyle: TextStyle(color: statusColor),
                )
              ],
            ),

            const SizedBox(height: 8),

            /// Homework Title
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 6),

            /// Teacher
            Text(
              "By $teacher",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 12),

            /// Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text("Due: $dueDate"),
                  ],
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    status == HomeworkStatus.submitted
                        ? "View"
                        : "Submit",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
