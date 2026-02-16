import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/student_repository.dart';
import '../requestmodel/student_request_model.dart';
import '../responsemodel/student_response_model.dart';
import '../services/student_service.dart';

final addStudentProvider =
StateNotifierProvider<AddStudentNotifier,
    AsyncValue<StudentResponseModel?>>((ref) {
  final service = ref.read(studentServiceProvider);
  return AddStudentNotifier(service);
});

class AddStudentNotifier
    extends StateNotifier<AsyncValue<StudentResponseModel?>> {

  final StudentService service;

  AddStudentNotifier(this.service)
      : super(const AsyncValue.data(null));

  Future<void> addStudent(StudentRequestModel model) async {
    try {
      state = const AsyncValue.loading();

      final result = await service.addStudent(model);

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
