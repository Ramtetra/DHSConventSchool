import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_model.dart';
import '../models/user_session.dart';
import '../network/dio_client.dart';
import '../repository/teacher_repository.dart';
import '../requestmodel/add_teacher_request.dart';
import '../services/teacher_service.dart';
import '../utils/session_manager.dart';

/// API
final teacherServiceProvider = Provider<TeacherService>((ref) {
  final dio = ref.read(dioProvider);
  return TeacherService(dio);
});

/// Repository
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final api = ref.read(teacherServiceProvider);
  return TeacherRepository(api);
});

/// GET LIST
final teacherListProvider = FutureProvider<List<TeacherModel>>((ref) async {
  final repo = ref.read(teacherRepositoryProvider);
  return repo.getAllTeachers();
});


final userProvider = FutureProvider<UserSession?>((ref) async {
  return await SessionManager.getUser();
});

/// ADD TEACHER (Command)
final addTeacherProvider =
FutureProvider.family<void, AddTeacherRequest>((ref, request) async {
  final repo = ref.read(teacherRepositoryProvider);
  await repo.addTeacher(request);

  // Refresh list after add
  ref.invalidate(teacherListProvider);
});
