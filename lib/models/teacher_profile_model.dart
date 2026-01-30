class TeacherProfileModel {
  final String name;
  final String email;
  final String phone;
  final String subject;
  final List<String> classes;

  TeacherProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.classes,
  });
}
