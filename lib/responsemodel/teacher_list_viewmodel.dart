import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_model.dart';
import '../repository/teacher_repository.dart';


class TeacherListViewModel
    extends StateNotifier<AsyncValue<List<TeacherModel>>> {
  final TeacherRepository _repository;

  TeacherListViewModel(this._repository)
      : super(const AsyncValue.loading()) {
    loadTeachers();
  }

  Future<void> loadTeachers() async {
    try {
      state = const AsyncValue.loading();
      final teachers = await _repository.getAllTeachers();
      state = AsyncValue.data(teachers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadTeachers();
  }
}
