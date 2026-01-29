enum NoticePriority { normal, important }

class NoticeModel {
  final String id;
  final String title;
  final String message;
  final String postedBy;
  final DateTime date;
  final NoticePriority priority;

  NoticeModel({
    required this.id,
    required this.title,
    required this.message,
    required this.postedBy,
    required this.date,
    required this.priority,
  });
}
