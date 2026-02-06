import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_model.dart';
import '../network/dio_client.dart';
import '../repository/teacher_repository.dart';
import '../requestmodel/add_teacher_request.dart';
import '../services/teacher_api_service.dart';

/// API
final teacherApiServiceProvider = Provider<TeacherApiService>((ref) {
  final dio = ref.read(dioProvider);
  return TeacherApiService(dio);
});

/// Repository
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final api = ref.read(teacherApiServiceProvider);
  return TeacherRepository(api);
});

/// GET LIST
final teacherListProvider = FutureProvider<List<TeacherModel>>((ref) async {
  final repo = ref.read(teacherRepositoryProvider);
  return repo.getAllTeachers();
});

/// ADD TEACHER (Command)
final addTeacherProvider =
FutureProvider.family<void, AddTeacherRequest>((ref, request) async {
  final repo = ref.read(teacherRepositoryProvider);
  await repo.addTeacher(request);

  // Refresh list after add
  ref.invalidate(teacherListProvider);
});
