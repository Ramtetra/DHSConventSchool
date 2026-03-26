// lib/models/user_session.dart

enum UserRole {
  admin,
  teacher,
  student,
}

class UserSession {
  // Common fields for all roles
  final String name;
  final String email;
  final String mobile;
  final String address;
  final UserRole role;
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

  UserSession({
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.role,
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

  // ==================== HELPER GETTERS ====================

  // Role checkers
  bool get isAdmin => role == UserRole.admin;
  bool get isTeacher => role == UserRole.teacher;
  bool get isStudent => role == UserRole.student;

  // Section helpers
  String get sectionString {
    if (section == null) return '';
    if (section is List) {
      return (section as List).join(', ');
    }
    return section.toString();
  }

  List<String>? get sectionList {
    if (section is List) {
      return List<String>.from(section);
    }
    return null;
  }

  // Classes helpers
  String get classesString {
    if (classes == null || classes!.isEmpty) return '';
    return classes!.join(', ');
  }

  // Subjects helpers
  String get subjectsString {
    if (subjects == null || subjects!.isEmpty) return '';
    return subjects!.join(', ');
  }

  // Full name with title
  String get displayName {
    if (isAdmin) return 'Admin: $name';
    if (isTeacher) return 'Teacher: $name';
    if (isStudent) return 'Student: $name';
    return name;
  }

  // Student info string
  String get studentInfo {
    if (!isStudent) return '';
    final parts = <String>[];
    if (studentClass != null && studentClass!.isNotEmpty) {
      parts.add('Class $studentClass');
    }
    if (sectionString.isNotEmpty) {
      parts.add('Section $sectionString');
    }
    if (parentName != null && parentName!.isNotEmpty) {
      parts.add('Parent: $parentName');
    }
    return parts.join(' • ');
  }

  // Teacher info string
  String get teacherInfo {
    if (!isTeacher) return '';
    final parts = <String>[];
    if (qualification != null && qualification!.isNotEmpty) {
      parts.add(qualification!);
    }
    if (experience != null && experience!.isNotEmpty) {
      parts.add(experience!);
    }
    if (classesString.isNotEmpty) {
      parts.add('Class: $classesString');
    }
    if (subjectsString.isNotEmpty) {
      parts.add('Subject: $subjectsString');
    }
    return parts.join(' • ');
  }

  // Admin info string
  String get adminInfo {
    if (!isAdmin) return '';
    final parts = <String>[];
    if (adminId != null && adminId!.isNotEmpty) {
      parts.add('ID: $adminId');
    }
    if (cDt != null && cDt!.isNotEmpty) {
      final date = DateTime.parse(cDt!);
      parts.add('Joined: ${date.year}');
    }
    return parts.join(' • ');
  }

  // Get user ID based on role
  String get userId {
    if (isAdmin) return adminId ?? '';
    if (isTeacher) return teacherId ?? '';
    if (isStudent) return studentId ?? '';
    return '';
  }

  // Get user display ID
  String get displayId {
    if (isAdmin) return 'Admin ID: ${adminId ?? "N/A"}';
    if (isTeacher) return 'Teacher ID: ${teacherId ?? "N/A"}';
    if (isStudent) return 'Student ID: ${studentId ?? "N/A"}';
    return '';
  }

  // ==================== JSON SERIALIZATION ====================

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'role': role.name,
      'imagePath': imagePath,
      // Admin fields
      'adminId': adminId,
      'cDt': cDt,
      'uDt': uDt,
      // Teacher fields
      'teacherId': teacherId,
      'gender': gender,
      'qualification': qualification,
      'experience': experience,
      'classes': classes,
      'subjects': subjects,
      'assignedClass': assignedClass,
      // Student fields
      'studentId': studentId,
      'dob': dob,
      'parentName': parentName,
      'studentClass': studentClass,
      'section': section,
      'rollNo': rollNo,
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    // Parse role string to enum
    UserRole parseRole(String? roleStr) {
      if (roleStr == null) return UserRole.student;
      switch (roleStr.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'teacher':
          return UserRole.teacher;
        case 'student':
          return UserRole.student;
        default:
          return UserRole.student;
      }
    }

    return UserSession(
      // Common fields
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      role: parseRole(json['role']?.toString()),
      imagePath: json['imagePath']?.toString(),
      // Admin fields
      adminId: json['adminId']?.toString(),
      cDt: json['cDt']?.toString(),
      uDt: json['uDt']?.toString(),
      // Teacher fields
      teacherId: json['teacherId']?.toString(),
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
      studentClass: json['studentClass']?.toString(),
      section: json['section'],
      rollNo: json['rollNo']?.toString(),
    );
  }

  // ==================== FACTORY METHODS ====================

  // Create from admin login response
  factory UserSession.fromAdminLogin(Map<String, dynamic> data) {
    return UserSession(
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      mobile: data['mobile']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      role: UserRole.admin,
      imagePath: data['imagePath']?.toString(),
      adminId: data['adminId']?.toString(),
      cDt: data['cDt']?.toString(),
      uDt: data['uDt']?.toString(),
    );
  }

  // Create from teacher login response
  factory UserSession.fromTeacherLogin(Map<String, dynamic> data) {
    return UserSession(
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      mobile: data['mobile']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      role: UserRole.teacher,
      imagePath: data['imagePath']?.toString(),
      teacherId: data['teacherID']?.toString(),
      gender: data['gender']?.toString(),
      qualification: data['qualification']?.toString(),
      experience: data['experience']?.toString(),
      classes: data['classes'] != null
          ? List<String>.from(data['classes'].map((c) => c.toString()))
          : null,
      subjects: data['subjects'] != null
          ? List<String>.from(data['subjects'].map((s) => s.toString()))
          : null,
      assignedClass: data['assignedClass'],
    );
  }

  // Create from student login response
  factory UserSession.fromStudentLogin(Map<String, dynamic> data) {
    return UserSession(
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      mobile: data['mobile']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      role: UserRole.student,
      imagePath: data['imagePath']?.toString(),
      studentId: data['studentId']?.toString(),
      dob: data['dob']?.toString(),
      parentName: data['parentName']?.toString(),
      cDt: data['cDt']?.toString(),
      studentClass: data['class']?.toString(),
      section: data['section'],
      rollNo: data['rollNo']?.toString(),
    );
  }

  // ==================== UTILITY METHODS ====================

  @override
  String toString() {
    return 'UserSession(name: $name, role: ${role.name}, email: $email, userId: $userId)';
  }

  // Check if session is valid
  bool get isValid {
    return name.isNotEmpty && email.isNotEmpty;
  }

  // Get profile completion percentage
  double get profileCompletion {
    int totalFields = 0;
    int filledFields = 0;

    if (name.isNotEmpty) filledFields++;
    totalFields++;

    if (email.isNotEmpty) filledFields++;
    totalFields++;

    if (mobile.isNotEmpty) filledFields++;
    totalFields++;

    if (address.isNotEmpty) filledFields++;
    totalFields++;

    if (imagePath != null && imagePath!.isNotEmpty) filledFields++;
    totalFields++;

    if (isAdmin) {
      if (adminId != null && adminId!.isNotEmpty) filledFields++;
      totalFields++;
    } else if (isTeacher) {
      if (teacherId != null && teacherId!.isNotEmpty) filledFields++;
      totalFields++;
      if (qualification != null && qualification!.isNotEmpty) filledFields++;
      totalFields++;
      if (experience != null && experience!.isNotEmpty) filledFields++;
      totalFields++;
    } else if (isStudent) {
      if (studentId != null && studentId!.isNotEmpty) filledFields++;
      totalFields++;
      if (parentName != null && parentName!.isNotEmpty) filledFields++;
      totalFields++;
      if (studentClass != null && studentClass!.isNotEmpty) filledFields++;
      totalFields++;
    }

    return (filledFields / totalFields) * 100;
  }
}