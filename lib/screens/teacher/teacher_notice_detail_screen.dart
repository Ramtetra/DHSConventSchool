import 'package:flutter/material.dart';
import '../../models/notice_model.dart';

class TeacherNoticeDetailScreen extends StatelessWidget {
  final NoticeModel notice;

  const TeacherNoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final isImportant = notice.priority == NoticePriority.important;

    return Scaffold(
      appBar: AppBar(title: const Text('Notice Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isImportant
                          ? Icons.priority_high
                          : Icons.notifications,
                      color: isImportant ? Colors.red : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notice.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  'Posted by ${notice.postedBy} on '
                      '${notice.date.day}/${notice.date.month}/${notice.date.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const Divider(height: 24),

                Text(
                  notice.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
