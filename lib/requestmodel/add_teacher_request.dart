class AddTeacherRequest {
  final String teacherName;
  final String qualification;
  final String experience;
  final String gender;
  final String mobile;
  final String email;
  final String password;
  final String address;
  final List<String> classes;
  final List<String> subjects;
  final List<String> assignedClasses;
  final String imageBase64;

  AddTeacherRequest({
    required this.teacherName,
    required this.qualification,
    required this.experience,
    required this.gender,
    required this.mobile,
    required this.email,
    required this.password,
    required this.address,
    required this.classes,
    required this.subjects,
    required this.assignedClasses,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      "teacherName": teacherName,
      "qualification": qualification,
      "experience": experience,
      "gender": gender,
      "mobile": mobile,
      "email": email,
      "Password": password, // ⚠ API expects capital P
      "address": address,
      "classes": classes,
      "subjects": subjects,
      "assignedClasses": assignedClasses,
      "imageBase64": imageBase64,
    };
  }
}
