// lib/models/login_response.dart

class LoginResponse {
  final bool success;
  final String message;
  final UserData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  // Common fields for all roles
  final String name;
  final String email;
  final String mobile;
  final String role;
  final String address;
  final String? imagePath;

  // Admin-specific fields
  final String? adminId;
  final String? cDt; // Created date
  final String? uDt; // Updated date

  // Teacher-specific fields
  final String? teacherId;
  final String? gender;
  final String? qualification;
  final String? experience;
  final List<String>? classes;
  final List<String>? subjects;
  final dynamic assignedClass;

  // Student-specific fields
  final String? studentId;
  final String? dob;
  final String? parentName;
  final String? studentClass;
  final dynamic section; // Can be List<String> or String
  final String? rollNo;

  UserData({
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.address,
    this.imagePath,
    // Admin fields
    this.adminId,
    this.cDt,
    this.uDt,
    // Teacher fields
    this.teacherId,
    this.gender,
    this.qualification,
    this.experience,
    this.classes,
    this.subjects,
    this.assignedClass,
    // Student fields
    this.studentId,
    this.dob,
    this.parentName,
    this.studentClass,
    this.section,
    this.rollNo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    // Parse role to determine which fields to extract
    final role = json['role']?.toString().toLowerCase() ?? '';

    return UserData(
      // Common fields
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      role: role,
      address: json['address']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),

      // Admin fields
      adminId: json['adminId']?.toString(),
      cDt: json['cDt']?.toString(),
      uDt: json['uDt']?.toString(),

      // Teacher fields
      teacherId: json['teacherID']?.toString(),
      gender: json['gender']?.toString(),
      qualification: json['qualification']?.toString(),
      experience: json['experience']?.toString(),
      classes: json['classes'] != null
          ? List<String>.from(json['classes'].map((c) => c.toString()))
          : null,
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'].map((s) => s.toString()))
          : null,
      assignedClass: json['assignedClass'],

      // Student fields
      studentId: json['studentId']?.toString(),
      dob: json['dob']?.toString(),
      parentName: json['parentName']?.toString(),
      studentClass: json['class']?.toString(),
      section: json['section'],
      rollNo: json['rollNo']?.toString(),
    );
  }

  // Helper getters to check role
  bool get isAdmin => role == 'admin';
  bool get isTeacher => role == 'teacher';
  bool get isStudent => role == 'student';

  // Helper getter for section as string
  String get sectionString {
    if (section == null) return '';
    if (section is List) {
      return (section as List).join(', ');
    }
    return section.toString();
  }

  // Helper getter for section as list
  List<String>? get sectionList {
    if (section is List) {
      return List<String>.from(section);
    }
    return null;
  }

  // Helper getter for classes as string
  String get classesString {
    if (classes == null || classes!.isEmpty) return '';
    return classes!.join(', ');
  }

  // Helper getter for subjects as string
  String get subjectsString {
    if (subjects == null || subjects!.isEmpty) return '';
    return subjects!.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': role,
      'address': address,
      'imagePath': imagePath,
      'adminId': adminId,
      'cDt': cDt,
      'uDt': uDt,
      'teacherID': teacherId,
      'gender': gender,
      'qualification': qualification,
      'experience': experience,
      'classes': classes,
      'subjects': subjects,
      'assignedClass': assignedClass,
      'studentId': studentId,
      'dob': dob,
      'parentName': parentName,
      'class': studentClass,
      'section': section,
      'rollNo': rollNo,
    };
  }
}