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


/*
final userProvider = FutureProvider<UserSession?>((ref) async {
  return await SessionManager.getUserSession();
});
*/

// teacher_provider.dart

final userProvider = FutureProvider<TeacherModel?>((ref) async {
  final userSession = await SessionManager.getUserSession();

  if (userSession == null || !userSession.isTeacher) {
    return null;
  }

  // Convert UserSession to TeacherModel
  return TeacherModel(
    teacherId: userSession.teacherId ?? '',
    teacherName: userSession.name,
    email: userSession.email,
    mobile: userSession.mobile,
    address: userSession.address,
    gender: userSession.gender ?? '',
    qualification: userSession.qualification ?? '',
    experience: userSession.experience ?? '',
    imagePath: userSession.imagePath,
    classes: userSession.classes,
    subjects: userSession.subjects,
    assignedClass: userSession.assignedClass,
  );
});


/// ADD TEACHER (Command)
final addTeacherProvider =
FutureProvider.family<void, AddTeacherRequest>((ref, request) async {
  final repo = ref.read(teacherRepositoryProvider);
  await repo.addTeacher(request);

  // Refresh list after add
  ref.invalidate(teacherListProvider);
});
