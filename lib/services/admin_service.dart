import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../responsemodel/count_model.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final dio = ref.read(dioProvider);
  return AdminService(dio);
});

class AdminService {
  final Dio _dio;

  AdminService(this._dio);

  Future<CountModel> getCounts() async {
    try {
      final response =
      await _dio.get("/api/Admin/CountAllTeacherStudent");

      final data = response.data;

      if (data["success"] == true) {
        return CountModel.fromJson(data["data"]);
      } else {
        throw Exception(data["message"]);
      }
    } catch (e) {
      throw Exception("Failed to fetch count: $e");
    }
  }
}
