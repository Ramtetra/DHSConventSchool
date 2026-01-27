import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

Color attendanceColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return Colors.green;
    case AttendanceStatus.absent:
      return Colors.red;
    case AttendanceStatus.holiday:
      return Colors.orange;
  }
}
