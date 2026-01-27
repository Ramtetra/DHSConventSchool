import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_model.dart';

class AttendanceNotifier
    extends StateNotifier<Map<DateTime, AttendanceStatus>> {
  AttendanceNotifier() : super({}) {
    _loadDummyData();
  }

  void _loadDummyData() {
    state = {
      DateTime(2026, 1, 2): AttendanceStatus.present,
      DateTime(2026, 1, 3): AttendanceStatus.absent,
      DateTime(2026, 1, 5): AttendanceStatus.holiday,
      DateTime(2026, 1, 6): AttendanceStatus.present,
      DateTime(2026, 1, 7): AttendanceStatus.present,
      DateTime(2026, 1, 8): AttendanceStatus.present,
      DateTime(2026, 1, 9): AttendanceStatus.present,
      DateTime(2026, 1, 10): AttendanceStatus.present,
    };
  }

  AttendanceStatus? getStatus(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return state[date];
  }

  void markAttendance(DateTime day, AttendanceStatus status) {
    final date = DateTime(day.year, day.month, day.day);
    state = {...state, date: status};
  }
}

final attendanceProvider =
StateNotifierProvider<AttendanceNotifier,
    Map<DateTime, AttendanceStatus>>(
      (ref) => AttendanceNotifier(),
);
