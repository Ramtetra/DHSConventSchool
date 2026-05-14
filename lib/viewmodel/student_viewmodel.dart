import 'package:dhs/providers/student_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../requestmodel/student_request_model.dart';

class StudentViewModel {
  final Ref ref;
  StudentViewModel(this.ref);

  Future<void> addStudent(StudentRequestModel request) async {
    await ref.read(addStudentProvider.notifier).addStudent(request);
  }
}

