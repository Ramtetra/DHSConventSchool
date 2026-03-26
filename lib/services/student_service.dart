// lib/services/student_service.dart
import 'package:dio/dio.dart';

import '../requestmodel/student_request_model.dart';
import '../responsemodel/StudentDetailsModel.dart';
import '../responsemodel/student_response_model.dart';

class StudentService {
  final Dio dio;

  StudentService(this.dio);

  // ==================== ADD STUDENT ====================
  Future<StudentResponseModel> addStudent(StudentRequestModel model) async {
    try {
      final response = await dio.post(
        "/api/admin/add-student",
        data: model.toJson(),
      );
      return StudentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to add student';
      throw Exception(msg);
    }
  }

  // ==================== GET ALL STUDENTS ====================
  // Get all students
  Future<StudentResponseModel> getAllStudents() async {
    try {
      final response = await dio.get('/api/Admin/GetAllStudent');
      print('✅ API Response: ${response.statusCode}');
      return StudentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ API Error: ${e.message}');
      final msg = e.response?.data?['message'] ?? 'Failed to get students';
      throw Exception(msg);
    }
    }

  // ✅ ADD THIS METHOD - Get student by ID
  Future<StudentResponseModel> getStudentById(String studentId) async {
    try {
      final response = await dio.get('/api/student/$studentId');
      return StudentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to get student details';
      throw Exception(msg);
    }
  }

  // ==================== UPDATE STUDENT ====================
  Future<StudentResponseModel> updateStudent(String studentId, StudentRequestModel model) async {
    try {
      final response = await dio.put(
        '/api/student/$studentId',
        data: model.toJson(),
      );
      return StudentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to update student';
      throw Exception(msg);
    }
  }

  // ==================== DELETE STUDENT ====================
  Future<void> deleteStudent(String studentId) async {
    try {
      await dio.delete('/api/student/$studentId');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to delete student';
      throw Exception(msg);
    }
  }
}