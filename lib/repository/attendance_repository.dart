import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../models/attendance_model/attendance_count.dart';


class AttendanceRepository {
  final Dio dio;

  AttendanceRepository(this.dio);

  Future<AttendanceCountModel> getAttendanceCount() async {
    try {
      final response = await dio.get(ApiEndpoints.attendanceCount);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return AttendanceCountModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Unknown error");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}