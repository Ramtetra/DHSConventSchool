import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/teacher_provider.dart';
import '../requestmodel/add_teacher_request.dart';

class TeacherViewModel {
  final Ref ref;

  TeacherViewModel(this.ref);

  Future<void> addTeacher(AddTeacherRequest request) async {
    await ref.read(addTeacherProvider(request).future);
  }
}

final teacherViewModelProvider = Provider<TeacherViewModel>((ref) {
  return TeacherViewModel(ref);
});
