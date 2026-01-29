class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final List<String> classes;
  final String avatarUrl;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.classes,
    required this.avatarUrl,
  });
}
