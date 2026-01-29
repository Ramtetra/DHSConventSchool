import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_model.dart';

final teacherProvider = StateProvider<TeacherModel?>((ref) {
  return TeacherModel(
    id: 'T001',
    name: 'Mr. Rajesh Sharma',
    email: 'rajesh.sharma@school.com',
    phone: '+91 98765 43210',
    subject: 'Mathematics',
    classes: ['Class 7-A', 'Class 8-A', 'Class 9-B'],
    avatarUrl: '', // Future: Network image
  );
});
