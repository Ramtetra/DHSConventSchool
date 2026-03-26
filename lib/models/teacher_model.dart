// lib/models/teacher_model.dart

import 'package:dhs/models/user_session.dart';

class TeacherModel {
  final String teacherId;
  final String teacherName;
  final String email;
  final String mobile;
  final String address;
  final String gender;
  final String qualification;
  final String experience;
  final String? imagePath;
  final List<String>? classes;
  final List<String>? subjects;
  final dynamic assignedClass;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeacherModel({
    required this.teacherId,
    required this.teacherName,
    required this.email,
    required this.mobile,
    required this.address,
    required this.gender,
    required this.qualification,
    required this.experience,
    this.imagePath,
    this.classes,
    this.subjects,
    this.assignedClass,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Alternative constructor with optional fields
  TeacherModel.fromUserSession(UserSession session)
      : teacherId = session.teacherId ?? '',
        teacherName = session.name,
        email = session.email,
        mobile = session.mobile,
        address = session.address,
        gender = session.gender ?? '',
        qualification = session.qualification ?? '',
        experience = session.experience ?? '',
        imagePath = session.imagePath,
        classes = session.classes,
        subjects = session.subjects,
        assignedClass = session.assignedClass,
        isActive = true,
        createdAt = session.cDt != null ? DateTime.tryParse(session.cDt!) : null,
        updatedAt = session.uDt != null ? DateTime.tryParse(session.uDt!) : null;

  // Factory method from JSON
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacherId']?.toString() ?? json['teacherID']?.toString() ?? '',
      teacherName: json['teacherName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      qualification: json['qualification']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
      classes: json['classes'] != null ? List<String>.from(json['classes']) : null,
      subjects: json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      assignedClass: json['assignedClass'],
      isActive: json['isActive'] ?? true,
      createdAt: json['cDt'] != null ? DateTime.tryParse(json['cDt']) : null,
      updatedAt: json['uDt'] != null ? DateTime.tryParse(json['uDt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'email': email,
      'mobile': mobile,
      'address': address,
      'gender': gender,
      'qualification': qualification,
      'experience': experience,
      'imagePath': imagePath,
      'classes': classes,
      'subjects': subjects,
      'assignedClass': assignedClass,
      'isActive': isActive,
      'cDt': createdAt?.toIso8601String(),
      'uDt': updatedAt?.toIso8601String(),
    };
  }
}