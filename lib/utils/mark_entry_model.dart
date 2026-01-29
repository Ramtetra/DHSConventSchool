class MarkEntryModel {
  final String studentId;
  final String studentName;
  final String rollNo;
  int marks;

  MarkEntryModel({
    required this.studentId,
    required this.studentName,
    required this.rollNo,
    this.marks = 0,
  });
}
