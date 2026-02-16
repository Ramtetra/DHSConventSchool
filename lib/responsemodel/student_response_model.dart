class StudentResponseModel {
  final bool success;
  final String message;
  final String? studentId;
  final String? studentName;
  final String? mobile;

  StudentResponseModel({
    required this.success,
    required this.message,
    this.studentId,
    this.studentName,
    this.mobile,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentResponseModel(
      success: json["success"],
      message: json["message"],
      studentId: json["data"]?["student_Id"],
      studentName: json["data"]?["student_Name"],
      mobile: json["data"]?["mobile"],
    );
  }
}
