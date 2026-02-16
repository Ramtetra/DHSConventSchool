import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../requestmodel/student_request_model.dart';
import '../responsemodel/student_response_model.dart';

final studentServiceProvider = Provider<StudentService>((ref) {
  final dio = ref.read(dioProvider);
  return StudentService(dio);
});

class StudentService {
  final Dio dio;
  StudentService(this.dio);

  Future<StudentResponseModel> addStudent(StudentRequestModel model) async {
    final response = await dio.post(
      "/api/admin/add-student",
      data: model.toJson(),
    );
    return StudentResponseModel.fromJson(response.data);
  }

  Future<StudentResponseModel> getAllStudent() async {
    try {
      final response = await dio.get('/api/Admin/GetAllStudent');
      return StudentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? 'Get teachers failed';
      throw Exception(msg);
    }
  }
}
