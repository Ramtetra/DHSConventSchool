import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notice_model.dart';
import '../../providers/notice_provider.dart';

class TeacherAddNoticeScreen extends ConsumerStatefulWidget {
  const TeacherAddNoticeScreen({super.key});

  @override
  ConsumerState<TeacherAddNoticeScreen> createState() =>
      _TeacherAddNoticeScreenState();
}

class _TeacherAddNoticeScreenState
    extends ConsumerState<TeacherAddNoticeScreen> {
  final _titleCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  NoticePriority _priority = NoticePriority.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Notice')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _msgCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            /// Priority Selector
            DropdownButtonFormField<NoticePriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: NoticePriority.normal,
                  child: Text('Normal'),
                ),
                DropdownMenuItem(
                  value: NoticePriority.important,
                  child: Text('Important'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _priority = val);
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Publish Notice'),
                onPressed: () {
                  if (_titleCtrl.text.isEmpty ||
                      _msgCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fill all fields')),
                    );
                    return;
                  }

                  final notice = NoticeModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleCtrl.text,
                    message: _msgCtrl.text,
                    postedBy: 'Teacher',
                    date: DateTime.now(),
                    priority: _priority,
                  );

                  ref.read(noticeProvider.notifier).addNotice(notice);

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
