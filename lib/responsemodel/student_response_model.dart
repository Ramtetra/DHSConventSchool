
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
    return StudentResponseModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => StudentDetailsModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
