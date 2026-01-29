import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/marks_entry_provider.dart';

class TeacherMarkEntryScreen extends ConsumerWidget {
  const TeacherMarkEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(marksEntryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Entry'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          /// 🏫 Class + Subject Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Class 6', 'Class 7', 'Class 8']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Math', 'Science', 'English']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),

          /// 🧮 Marks List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Student')),
                Expanded(child: Text('Roll')),
                Expanded(child: Text('Marks')),
              ],
            ),
          ),

          const Divider(),

          /// 🧑‍🎓 Marks Entry List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final s = students[index];

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(s.studentName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                        Expanded(child: Text(s.rollNo)),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                            s.marks == 0 ? '' : s.marks.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '0-100',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              final marks = int.tryParse(val) ?? 0;
                              ref
                                  .read(marksEntryProvider.notifier)
                                  .updateMarks(s.studentId, marks);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 💾 Submit Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Submit Marks'),
                onPressed: () {
                  ref.read(marksEntryProvider.notifier).submitMarks();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marks submitted successfully')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
