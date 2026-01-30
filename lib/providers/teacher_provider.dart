import 'package:dhs/models/teacher_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_profile_model.dart';

final teacherProvider = FutureProvider<TeacherProfileModel>((ref) async {
  // 🔹 Simulate API / DB call
  await Future.delayed(const Duration(seconds: 1));

  // 🔹 Replace with real API response later
  return TeacherProfileModel(
    name: 'Rahul Sharma',
    email: 'rahul@gmail.com',
    phone: '9876543210',
    subject: 'Mathematics',
    classes: ['Class 8', 'Class 9', 'Class 10'],
  );
});
