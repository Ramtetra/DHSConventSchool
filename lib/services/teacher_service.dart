import 'package:dio/dio.dart';
import '../requestmodel/add_teacher_request.dart';
import '../responsemodel/add_teacher_response.dart';
import '../responsemodel/get_all_teacher_response.dart';

class TeacherService {
  final Dio _dio;
  TeacherService(this._dio);
  // ================================
  // ✅ ADD TEACHER
  // ================================
  Future<AddTeacherResponse> addTeacher(AddTeacherRequest request) async {
    try {
      final response = await _dio.post(
        '/api/admin/add-teacher',
        data: request.toJson(),
      );

      return AddTeacherResponse.fromJson(response.data);
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? 'Failed to add teacher';
      throw Exception(msg);
    }
  }

  // ================================
  // ✅ GET ALL TEACHERS
  // ================================

  Future<GetAllTeacherResponse> getAllTeachers() async {
    try {
      final response = await _dio.get('/api/Admin/GetAllTeacher');
      return GetAllTeacherResponse.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Get teachers failed';
      throw Exception(msg);
    }
  }

}
