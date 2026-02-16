// ================= MAIN RESPONSE MODEL =================
class CountResponseModel {
  final bool success;
  final String message;
  final CountModel data;

  CountResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CountResponseModel.fromJson(Map<String, dynamic> json) {
    return CountResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CountModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// ================= DATA MODEL =================
class CountModel {
  final int totalStudents;
  final int totalTeachers;

  CountModel({
    required this.totalStudents,
    required this.totalTeachers,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
      totalStudents: json['totalStudents'] ?? 0,
      totalTeachers: json['totalTeachers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
    };
  }
}
