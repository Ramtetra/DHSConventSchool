import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notice_model.dart';

final noticeProvider =
StateNotifierProvider<NoticeNotifier, List<NoticeModel>>(
      (ref) => NoticeNotifier(),
);

class NoticeNotifier extends StateNotifier<List<NoticeModel>> {
  NoticeNotifier() : super([]) {
    loadDummyNotices();
  }

  void loadDummyNotices() {
    state = [
      NoticeModel(
        id: '1',
        title: 'Unit Test Schedule',
        message: 'Unit tests will start from 5th Feb for all classes.',
        postedBy: 'Principal Office',
        date: DateTime.now().subtract(const Duration(days: 1)),
        priority: NoticePriority.important,
      ),
      NoticeModel(
        id: '2',
        title: 'PTM Meeting',
        message: 'Parent-Teacher Meeting on Saturday at 10 AM.',
        postedBy: 'Admin',
        date: DateTime.now().subtract(const Duration(days: 2)),
        priority: NoticePriority.normal,
      ),
    ];
  }

  void addNotice(NoticeModel notice) {
    state = [notice, ...state];
  }
}
