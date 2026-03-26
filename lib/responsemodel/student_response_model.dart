
import 'StudentDetailsModel.dart';

class StudentResponseModel {
  final bool success;
  final String message;
  final List<StudentDetailsModel> data;

  StudentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    List<StudentDetailsModel> list = [];

    if (json['data'] is List) {
      list = (json['data'] as List)
          .map((e) => StudentDetailsModel.fromJson(e))
          .toList();
    } else if (json['data'] is Map) {
      list = [StudentDetailsModel.fromJson(json['data'])];
    }

    return StudentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: list,
    );
  }
}
