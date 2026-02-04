import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../requestmodel/add_teacher_request.dart';
import '../responsemodel/add_teacher_response.dart';

class TeacherApiService {
  final Dio _dio = DioClient.dio;

  Future<AddTeacherResponse> addTeacher(AddTeacherRequest request) async {
    try {
      final response = await _dio.post(
        '/api/admin/add-teacher',
        data: request.toJson(),
      );

      return AddTeacherResponse.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Something went wrong';
      throw Exception(msg);
    }
  }
}
