class AttendanceCount {
  final int totalCount;
  final int presentCount;
  final int absentCount;

  AttendanceCount({
    required this.totalCount,
    required this.presentCount,
    required this.absentCount,
  });

  factory AttendanceCount.fromJson(Map<String, dynamic> json) {
    return AttendanceCount(
      totalCount: json['totalCount'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'presentCount': presentCount,
      'absentCount': absentCount,
    };
  }
}

class AttendanceResponse {
  final bool success;
  final String message;
  final AttendanceCount? data;

  AttendanceResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data']['count'] != null
          ? AttendanceCount.fromJson(json['data']['count'])
          : null,
    );
  }
}