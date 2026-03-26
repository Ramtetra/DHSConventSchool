// lib/models/student_model.dart
class StudentModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String className;
  final String section;
  final String parentName;
  final String dob;
  final String rollNo;
  final String imagePath;
  final String gender;
  final String role;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.className,
    required this.section,
    required this.parentName,
    required this.dob,
    required this.rollNo,
    required this.imagePath,
    required this.gender,
    required this.role,
  });

  String get displayInfo {
    final parts = <String>[];
    if (className.isNotEmpty) parts.add('Class $className');
    if (section.isNotEmpty) parts.add('Section $section');
    if (rollNo.isNotEmpty) parts.add('Roll No: $rollNo');
    return parts.isNotEmpty ? parts.join(' • ') : 'Student';
  }

  String get initials {
    if (name.isEmpty) return 'S';
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}