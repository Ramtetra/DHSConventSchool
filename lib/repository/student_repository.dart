
 import 'package:dhs/services/student_service.dart';

import '../requestmodel/student_request_model.dart';

class StudentRepository {
  final StudentService service;

  StudentRepository(this.service);

  Future<void> addStudent(StudentRequestModel request) async {
    await service.addStudent(request);

  }
 }