class AddTeacherResponse {
  final bool success;
  final String message;
  final TeacherData? data;

  AddTeacherResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddTeacherResponse.fromJson(Map<String, dynamic> json) {
    return AddTeacherResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TeacherData.fromJson(json['data'])
          : null,
    );
  }
}

class TeacherData {
  final String userId;
  final String name;
  final String email;
  final String mobile;

  TeacherData({
    required this.userId,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}
