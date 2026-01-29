import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/mark_entry_model.dart';

final marksEntryProvider =
StateNotifierProvider<MarksEntryNotifier, List<MarkEntryModel>>(
      (ref) => MarksEntryNotifier(),
);

class MarksEntryNotifier extends StateNotifier<List<MarkEntryModel>> {
  MarksEntryNotifier() : super([]) {
    loadDummyStudents();
  }

  void loadDummyStudents() {
    state = [
      MarkEntryModel(studentId: '1', studentName: 'Aarav Sharma', rollNo: '12'),
      MarkEntryModel(studentId: '2', studentName: 'Neha Verma', rollNo: '05'),
      MarkEntryModel(studentId: '3', studentName: 'Rohit Kumar', rollNo: '21'),
    ];
  }

  void updateMarks(String studentId, int marks) {
    state = [
      for (final s in state)
        if (s.studentId == studentId)
          MarkEntryModel(
            studentId: s.studentId,
            studentName: s.studentName,
            rollNo: s.rollNo,
            marks: marks,
          )
        else
          s,
    ];
  }

  void submitMarks() {
    // 🔗 TODO: API call here
    for (final s in state) {
      print('Submit: ${s.studentName} = ${s.marks}');
    }
  }
}
