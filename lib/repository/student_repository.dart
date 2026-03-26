// lib/repository/student_repository.dart
import '../requestmodel/student_request_model.dart';
import '../responsemodel/StudentDetailsModel.dart';
import '../responsemodel/student_response_model.dart';
import '../services/student_service.dart';

class StudentRepository {
  final StudentService _service;

  StudentRepository(this._service);

  // Get all students
  Future<List<StudentDetailsModel>> getAllStudents() async {
    try {
      final response = await _service.getAllStudents();
      print('📦 Repository: Got ${response.data?.length ?? 0} students');
      return response.data ?? [];
    } catch (e) {
      print('❌ Repository error: $e');
      return [];
    }
  }

  // ✅ ADD THIS METHOD - Get student by ID
  Future<StudentDetailsModel?> getStudentById(String studentId) async {
    try {
      final response = await _service.getStudentById(studentId);
      return response.data?.first;
    } catch (e) {
      print('Error getting student by ID $studentId: $e');
      return null;
    }
  }

  // Add student
  Future<StudentResponseModel> addStudent(StudentRequestModel request) async {
    try {
      return await _service.addStudent(request);
    } catch (e) {
      print('Error adding student: $e');
      rethrow;
    }
  }
}