// lib/responsemodel/student_response_model.dart
import 'StudentDetailsModel.dart';

class StudentResponseModel {
  final bool success;
  final String message;
  final List<StudentDetailsModel>? data;

  StudentResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    List<StudentDetailsModel> students = [];

    if (json['data'] is List) {
      students = (json['data'] as List)
          .map((item) => StudentDetailsModel.fromJson(item))
          .toList();
    }

    return StudentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: students,
    );
  }
}