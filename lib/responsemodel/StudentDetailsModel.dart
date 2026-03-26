// lib/responsemodel/StudentDetailsModel.dart
class StudentDetailsModel {
  final String? studentId;
  final String? studentName;
  final String? dob;
  final String? gender;
  final String? mobile;
  final String? email;
  final String? password;
  final String? imageBase64;
  final String? imagePath;
  final String? address;
  final String? parentName;
  final String? cDt;
  final String? uDt;
  final String? classes;
  final dynamic section;
  final String? role;

  StudentDetailsModel({
    this.studentId,
    this.studentName,
    this.dob,
    this.gender,
    this.mobile,
    this.email,
    this.password,
    this.imageBase64,
    this.imagePath,
    this.address,
    this.parentName,
    this.cDt,
    this.uDt,
    this.classes,
    this.section,
    this.role,
  });

  factory StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailsModel(
      studentId: json['studentId']?.toString(),
      studentName: json['studentName']?.toString(),
      dob: json['dob']?.toString(),
      gender: json['gender']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      imageBase64: json['imageBase64']?.toString(),
      imagePath: json['imagePath']?.toString(),
      address: json['address']?.toString(),
      parentName: json['parentName']?.toString(),
      cDt: json['cDt']?.toString(),
      uDt: json['uDt']?.toString(),
      classes: json['classes']?.toString(),
      section: json['section'],
      role: json['role']?.toString(),
    );
  }

  String get sectionString {
    if (section == null) return '';
    if (section is List) {
      return (section as List).join(', ');
    }
    return section.toString();
  }

  List<String> get sectionList {
    if (section == null) return [];
    if (section is List) {
      return List<String>.from(section);
    }
    return [section.toString()];
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'dob': dob,
      'gender': gender,
      'mobile': mobile,
      'email': email,
      'password': password,
      'imageBase64': imageBase64,
      'imagePath': imagePath,
      'address': address,
      'parentName': parentName,
      'cDt': cDt,
      'uDt': uDt,
      'classes': classes,
      'section': section,
      'role': role,
    };
  }
}