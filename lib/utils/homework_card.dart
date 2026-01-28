import 'package:dhs/utils/status_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _HomeworkCard extends StatelessWidget {
  final String subject;
  final String className;
  final String title;
  final String dueDate;
  final String status;

  const _HomeworkCard({
    required this.subject,
    required this.className,
    required this.title,
    required this.dueDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitted = status == 'Submitted';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Subject + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatusChip(
                  label: status,
                  color: isSubmitted ? Colors.green : Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Homework Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            /// Class & Due Date
            Row(
              children: [
                const Icon(Icons.group, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(className),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(dueDate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
