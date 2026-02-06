enum TeacherStatus { active, inactive }

class TeacherModel {
  final String teacherId;
  final int employeeId;
  final String teacherName;
  final String qualification;
  final String experience;
  final String gender;
  final String mobile;
  final String email;
  final String? imageBase64;
  final String? imagePath;
  final String address;
  final List<String> classes;
  final List<String> subjects;
  final List<String> assignedClasses;

  TeacherModel({
    required this.teacherId,
    required this.employeeId,
    required this.teacherName,
    required this.qualification,
    required this.experience,
    required this.gender,
    required this.mobile,
    required this.email,
    this.imageBase64,
    this.imagePath,
    required this.address,
    required this.classes,
    required this.subjects,
    required this.assignedClasses,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacherId'] ?? '',
      employeeId: json['employeeId'] ?? 0,
      teacherName: json['teacherName'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? '',
      gender: json['gender'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      imageBase64: json['imageBase64'],
      imagePath: json['imagePath'],
      address: json['address'] ?? '',
      classes: List<String>.from(json['classes'] ?? []),
      subjects: List<String>.from(json['subjects'] ?? []),
      assignedClasses: List<String>.from(json['assignedClasses'] ?? []),
    );
  }
}


