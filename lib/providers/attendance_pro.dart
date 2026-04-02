import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance_model/attendance_count.dart';
import '../network/dio_client.dart';
import '../repository/attendance_repository.dart';

// Repository Provider
final attendanceRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AttendanceRepository(dio);
});

// Future Provider
final attendanceProvider = FutureProvider<AttendanceCountModel>((ref) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getAttendanceCount();
});