import '../../models/teacher_model.dart';
import '../requestmodel/add_teacher_request.dart';
import '../services/teacher_service.dart';

class TeacherRepository {
  final TeacherService teacherService;

  TeacherRepository(this.teacherService);

  Future<void> addTeacher(AddTeacherRequest request) async {
    await teacherService.addTeacher(request);
  }

  Future<List<TeacherModel>> getAllTeachers() async {
    final res = await teacherService.getAllTeachers();

    if (!res.success) {
      throw Exception(res.data);
    }

    return res.data; // ✅ NOW WORKS
  }
}
