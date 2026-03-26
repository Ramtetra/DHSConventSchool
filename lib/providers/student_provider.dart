// lib/providers/student_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student_model.dart';
import '../network/dio_client.dart';
import '../repository/student_repository.dart';
import '../requestmodel/student_request_model.dart';
import '../responsemodel/StudentDetailsModel.dart';
import '../responsemodel/student_response_model.dart';
import '../services/student_service.dart';

// ==================== HELPER FUNCTIONS ====================
String _getSectionString(dynamic section) {
  if (section == null) return '';
  if (section is List) {
    return (section as List).join(', ');
  }
  return section.toString();
}

// ==================== STUDENT SERVICE PROVIDER ====================
final studentServiceProvider = Provider<StudentService>((ref) {
  final dio = ref.read(dioProvider);
  return StudentService(dio);
});

// ==================== STUDENT REPOSITORY PROVIDER ====================
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final service = ref.read(studentServiceProvider);
  return StudentRepository(service);
});

// ==================== ADD STUDENT PROVIDER ====================
final addStudentProvider = StateNotifierProvider<AddStudentNotifier, AsyncValue<StudentResponseModel?>>((ref) {
  final service = ref.read(studentServiceProvider);
  return AddStudentNotifier(service);
});

class AddStudentNotifier extends StateNotifier<AsyncValue<StudentResponseModel?>> {
  final StudentService service;

  AddStudentNotifier(this.service) : super(const AsyncValue.data(null));

  Future<void> addStudent(StudentRequestModel model) async {
    try {
      state = const AsyncValue.loading();
      final result = await service.addStudent(model);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// ==================== STUDENT LIST PROVIDER ====================
final studentListProvider = FutureProvider<List<StudentDetailsModel>>((ref) async {
  try {
    final repository = ref.read(studentRepositoryProvider);
    final students = await repository.getAllStudents();
    print('✅ Students loaded: ${students.length}');
    return students;
  } catch (e) {
    print('❌ Error fetching student list: $e');
    return [];
  }
});

// ==================== CONVERTED STUDENT LIST PROVIDER ====================
final convertedStudentListProvider = FutureProvider<List<StudentModel>>((ref) async {
  try {
    final studentDetailsList = await ref.watch(studentListProvider.future);

    if (studentDetailsList.isEmpty) {
      print('⚠️ No students found');
      return [];
    }

    print('🔄 Converting ${studentDetailsList.length} students to StudentModel');

    return studentDetailsList.map((studentDetails) {
      return StudentModel(
        id: studentDetails.studentId?.toString() ?? '',
        name: studentDetails.studentName?.toString() ?? '',
        email: studentDetails.email?.toString() ?? '',
        mobile: studentDetails.mobile?.toString() ?? '',
        address: studentDetails.address?.toString() ?? '',
        className: studentDetails.classes?.toString() ?? '',
        section: _getSectionString(studentDetails.section),
        parentName: studentDetails.parentName?.toString() ?? '',
        dob: studentDetails.dob?.toString() ?? '',
        rollNo: studentDetails.studentId?.toString() ?? '',
        imagePath: studentDetails.imagePath?.toString() ?? '',
        gender: studentDetails.gender?.toString() ?? '',
        role: studentDetails.role?.toString() ?? 'student',
      );
    }).toList();
  } catch (e) {
    print('❌ Error converting student list: $e');
    return [];
  }
});

// ==================== STUDENT BY ID PROVIDER ====================
final studentByIdProvider = FutureProvider.family<StudentModel?, String>((ref, studentId) async {
  try {
    final repository = ref.read(studentRepositoryProvider);
    final studentDetails = await repository.getStudentById(studentId);

    if (studentDetails == null) return null;

    return StudentModel(
      id: studentDetails.studentId?.toString() ?? '',
      name: studentDetails.studentName?.toString() ?? '',
      email: studentDetails.email?.toString() ?? '',
      mobile: studentDetails.mobile?.toString() ?? '',
      address: studentDetails.address?.toString() ?? '',
      className: studentDetails.classes?.toString() ?? '',
      section: _getSectionString(studentDetails.section),
      parentName: studentDetails.parentName?.toString() ?? '',
      dob: studentDetails.dob?.toString() ?? '',
      rollNo: studentDetails.studentId?.toString() ?? '',
      imagePath: studentDetails.imagePath?.toString() ?? '',
      gender: studentDetails.gender?.toString() ?? '',
      role: studentDetails.role?.toString() ?? 'student',
    );
  } catch (e) {
    print('❌ Error fetching student by ID $studentId: $e');
    return null;
  }
});

// ==================== SEARCH AND FILTER PROVIDERS ====================
final studentSearchQueryProvider = StateProvider<String>((ref) => '');
final studentClassFilterProvider = StateProvider<String>((ref) => 'All');

// ==================== FILTERED STUDENT LIST PROVIDER ====================
final filteredStudentListProvider = Provider<List<StudentModel>>((ref) {
  final students = ref.watch(convertedStudentListProvider).value ?? [];
  final searchQuery = ref.watch(studentSearchQueryProvider);
  final selectedClass = ref.watch(studentClassFilterProvider);

  if (students.isEmpty) return [];

  return students.where((student) {
    final matchesSearch = searchQuery.isEmpty ||
        student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.parentName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.mobile.toLowerCase().contains(searchQuery.toLowerCase());

    final className = "Class ${student.className}";
    final matchesClass = selectedClass == 'All' || className == selectedClass;

    return matchesSearch && matchesClass;
  }).toList();
});

// ==================== STUDENT STATS PROVIDER ====================
final studentStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final students = ref.watch(convertedStudentListProvider).value ?? [];

  final totalStudents = students.length;
  final classesCount = students.map((s) => s.className).toSet().length;

  return {
    'totalStudents': totalStudents,
    'classesCount': classesCount,
  };
});

// ==================== CLASS LIST PROVIDER ====================
final classListProvider = Provider<List<String>>((ref) {
  final students = ref.watch(convertedStudentListProvider).value ?? [];
  final classes = students
      .map((student) => student.className)
      .where((className) => className.isNotEmpty)
      .toSet()
      .toList();
  classes.sort((a, b) {
    final aNum = int.tryParse(a) ?? 0;
    final bNum = int.tryParse(b) ?? 0;
    return aNum.compareTo(bNum);
  });
  return classes;
});

// ==================== STUDENT COUNT BY CLASS PROVIDER ====================
final studentCountByClassProvider = Provider<Map<String, int>>((ref) {
  final students = ref.watch(convertedStudentListProvider).value ?? [];
  final Map<String, int> countByClass = {};

  for (final student in students) {
    final className = student.className;
    if (className.isNotEmpty) {
      countByClass[className] = (countByClass[className] ?? 0) + 1;
    }
  }

  return countByClass;
});

// ==================== DELETE STUDENT PROVIDER ====================
final deleteStudentProvider = FutureProvider.family<void, String>((ref, studentId) async {
  try {
    final repository = ref.read(studentRepositoryProvider);
    // await repository.deleteStudent(studentId);

    ref.invalidate(studentListProvider);
    ref.invalidate(convertedStudentListProvider);
    ref.invalidate(studentByIdProvider);

    print('✅ Student deleted: $studentId');
  } catch (e) {
    print('❌ Error deleting student: $e');
    rethrow;
  }
});

// ==================== REFRESH STUDENT LIST PROVIDER ====================
final refreshStudentListProvider = Provider<void>((ref) {
  ref.invalidate(studentListProvider);
  ref.invalidate(convertedStudentListProvider);
  print('🔄 Student list refreshed');
});

// ==================== CREATE STUDENT PROVIDER ====================
final createStudentProvider = FutureProvider.family<void, StudentRequestModel>((ref, request) async {
  try {
    final notifier = ref.read(addStudentProvider.notifier);
    await notifier.addStudent(request);

    ref.invalidate(studentListProvider);
    ref.invalidate(convertedStudentListProvider);

    print('✅ Student created: ${request.studentName}');
  } catch (e) {
    print('❌ Error creating student: $e');
    rethrow;
  }
});