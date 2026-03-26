class StudentRequestModel {
  final String studentName;
  final String parentName;
  final String dob;
  final String gender;
  final String mobile;
  final String email;
  final String password;
  final String address;
  final String classes;
  final List<String> section;
  final String imageBase64;

  StudentRequestModel({
    required this.studentName,
    required this.parentName,
    required this.dob,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.password,
    required this.address,
    required this.classes,
    required this.section,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentName": studentName,
      "parentName": parentName,
      "dob": dob,
      "gender": gender,
      "mobile": mobile,
      "email": email,
      "password": password,
      "address": address,
      "classes": classes,
      "section": section,
      "imageBase64": imageBase64,
    };
  }
}
