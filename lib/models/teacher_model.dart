enum TeacherStatus { active, inactive }

class TeacherModel {
  final String id;
  final String name;
  final String subject;
  final String email;
  final String phone;
  final String avatarUrl;
  final TeacherStatus status;

  TeacherModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.status,
  });
}
