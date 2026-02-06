import 'package:dio/dio.dart';
import '../../models/teacher_model.dart';
import '../requestmodel/add_teacher_request.dart';
import '../services/teacher_api_service.dart';

class TeacherRepository {
  final TeacherApiService _api;

  TeacherRepository(this._api);

  Future<void> addTeacher(AddTeacherRequest request) async {
    await _api.addTeacher(request);
  }

  Future<List<TeacherModel>> getAllTeachers() async {
    final res = await _api.getAllTeachers();

    if (!res.success) {
      throw Exception(res.data);
    }

    return res.data; // ✅ NOW WORKS
  }
}
