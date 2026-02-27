
 import 'package:dhs/services/student_service.dart';
import '../requestmodel/student_request_model.dart';
import '../responsemodel/StudentDetailsModel.dart';

class StudentRepository {
  final StudentService service;

  StudentRepository(this.service);

  Future<void> addStudent(StudentRequestModel request) async {
    await service.addStudent(request);

  }

  Future<List<StudentDetailsModel>> getAllStudents() async {
    final res = await service.getAllStudent();

    if (!res.success) {
      throw Exception(res.data);
    }

    return res.data; // ✅ NOW WORKS
  }

 }