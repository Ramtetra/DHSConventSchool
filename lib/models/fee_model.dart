enum FeeStatus { paid, pending, overdue }

class FeeModel {
  final String id;
  final String studentName;
  final String className;
  final String feeType;
  final double amount;
  final DateTime dueDate;
  final FeeStatus status;

  FeeModel({
    required this.id,
    required this.studentName,
    required this.className,
    required this.feeType,
    required this.amount,
    required this.dueDate,
    required this.status,
  });
}
