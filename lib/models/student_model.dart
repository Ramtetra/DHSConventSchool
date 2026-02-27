enum PerformanceLevel { good, average, weak }

class StudentModel {
  final String id;
  final String name;
  final String className;
  final String rollNo;
  final String avatarUrl;
  final PerformanceLevel performance;

  // Full API Data
  final String dob;
  final String gender;
  final String mobile;
  final String email;
  final String address;
  final String parentName;
  final String role;
  final List<String> section;

  StudentModel({
    required this.id,
    required this.name,
    required this.className,
    required this.rollNo,
    required this.avatarUrl,
    required this.performance,
    required this.dob,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.address,
    required this.parentName,
    required this.role,
    required this.section,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['studentId'],
      name: json['studentName'],
      className: "Class ${json['classes']}",
      rollNo: json['studentId'], // Using studentId as RollNo
      avatarUrl: '',
      performance: PerformanceLevel.good,
      dob: json['dob'],
      gender: json['gender'],
      mobile: json['mobile'],
      email: json['email'],
      address: json['address'],
      parentName: json['parentName'],
      role: json['role'],
      section: List<String>.from(json['section']),
    );
  }
}