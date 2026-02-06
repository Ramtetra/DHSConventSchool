
import '../models/teacher_model.dart';

class GetAllTeacherResponse {
  final bool success;
  final String message;
  final List<TeacherModel> data;

  GetAllTeacherResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetAllTeacherResponse.fromJson(Map<String, dynamic> json) {
    return GetAllTeacherResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => TeacherModel.fromJson(e))
          .toList(),
    );
  }
}
