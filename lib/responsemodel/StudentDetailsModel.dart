class StudentDetailsModel {
  final String studentId;
  final String studentName;
  final String dob;
  final String gender;
  final String mobile;
  final String email;
  final String password;
  final String? imageBase64;
  final String? imagePath;
  final String address;
  final String parentName;
  final String cDt;
  final String? uDt;
  final String classes;
  final List<String> section;
  final String role;

  StudentDetailsModel({
    required this.studentId,
    required this.studentName,
    required this.dob,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.password,
    this.imageBase64,
    this.imagePath,
    required this.address,
    required this.parentName,
    required this.cDt,
    this.uDt,
    required this.classes,
    required this.section,
    required this.role,
  });

  factory StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailsModel(
      studentId: json['student_Id'] ?? json['studentId'] ?? '',
      studentName: json['student_Name'] ?? json['studentName'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      imageBase64: json['imageBase64'],
      imagePath: json['imagePath'],
      address: json['address'] ?? '',
      parentName: json['parentName'] ?? '',
      cDt: json['cDt'] ?? '',
      uDt: json['uDt'],
      classes: json['classes'] ?? '',
      section: json['section'] != null
          ? List<String>.from(json['section'])
          : [],
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "student_Id": studentId,   // ✅ keep consistent with API
      "student_Name": studentName,
      "dob": dob,
      "gender": gender,
      "mobile": mobile,
      "email": email,
      "password": password,
      "imageBase64": imageBase64,
      "imagePath": imagePath,
      "address": address,
      "parentName": parentName,
      "cDt": cDt,
      "uDt": uDt,
      "classes": classes,
      "section": section,
      "role": role,
    };
  }
}