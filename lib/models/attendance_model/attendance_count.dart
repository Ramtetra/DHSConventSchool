class AttendanceCountModel {
  final int totalCount;
  final int presentCount;
  final int absentCount;

  AttendanceCountModel({
    required this.totalCount,
    required this.presentCount,
    required this.absentCount,
  });

  factory AttendanceCountModel.fromJson(Map<String, dynamic> json) {
    final count = json['data']['count'];

    return AttendanceCountModel(
      totalCount: count['totalCount'] ?? 0,
      presentCount: count['presentCount'] ?? 0,
      absentCount: count['absentCount'] ?? 0,
    );
  }
}