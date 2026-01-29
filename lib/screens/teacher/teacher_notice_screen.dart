import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notice_model.dart';
import '../../providers/notice_provider.dart';
import 'teacher_notice_detail_screen.dart';
import 'teacher_add_notice_screen.dart';

class TeacherNoticeScreen extends ConsumerWidget {
  const TeacherNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(noticeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Notice'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TeacherAddNoticeScreen(),
            ),
          );
        },
      ),

      body: notices.isEmpty
          ? const Center(child: Text('No notices available'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notices[index];
          final isImportant = n.priority == NoticePriority.important;

          return Card(
            elevation: isImportant ? 3 : 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                isImportant ? Colors.red : Colors.blue,
                child: Icon(
                  isImportant
                      ? Icons.priority_high
                      : Icons.notifications,
                  color: Colors.white,
                ),
              ),
              title: Text(
                n.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${n.postedBy} • ${_formatDate(n.date)}',
              ),
              trailing: isImportant
                  ? const Chip(
                label: Text('IMPORTANT'),
                backgroundColor: Colors.redAccent,
                labelStyle: TextStyle(color: Colors.white),
              )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TeacherNoticeDetailScreen(notice: n),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
