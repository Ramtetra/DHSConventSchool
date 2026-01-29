enum PerformanceLevel { good, average, weak }

class StudentModel {
  final String id;
  final String name;
  final String className;
  final String rollNo;
  final String avatarUrl;
  final PerformanceLevel performance;

  StudentModel({
    required this.id,
    required this.name,
    required this.className,
    required this.rollNo,
    required this.avatarUrl,
    required this.performance,
  });
}
