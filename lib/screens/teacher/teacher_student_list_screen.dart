import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student_model.dart';
import '../../utils/student_card.dart';

class TeacherStudentListScreen extends ConsumerStatefulWidget {
  const TeacherStudentListScreen({super.key});

  @override
  ConsumerState<TeacherStudentListScreen> createState() =>
      _TeacherStudentListScreenState();
}

class _TeacherStudentListScreenState extends ConsumerState<TeacherStudentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedClass = 'All';

  final List<String> classFilters = ['All', 'Class 6', 'Class 7', 'Class 8'];

  final List<StudentModel> allStudents = [
    StudentModel(
      id: '1',
      name: 'Aarav Sharma',
      className: 'Class 8',
      rollNo: '12',
      avatarUrl: '',
      performance: PerformanceLevel.good,
    ),
    StudentModel(
      id: '2',
      name: 'Neha Verma',
      className: 'Class 7',
      rollNo: '05',
      avatarUrl: '',
      performance: PerformanceLevel.average,
    ),
    StudentModel(
      id: '3',
      name: 'Rohit Kumar',
      className: 'Class 8',
      rollNo: '21',
      avatarUrl: '',
      performance: PerformanceLevel.weak,
    ),
  ];

  List<StudentModel> get filteredStudents {
    return allStudents.where((s) {
      final matchClass =
          selectedClass == 'All' || s.className == selectedClass;
      final matchSearch = s.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      return matchClass && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search student...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          /// Class Filter Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: classFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cls = classFilters[index];
                final isSelected = selectedClass == cls;

                return ChoiceChip(
                  label: Text(cls),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedClass = cls);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// Student List
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(child: Text('No students found'))
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStudents.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return StudentCard(
                  student: student,
                  onTap: () {
                    // TODO: Navigate to Student Detail Screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Open ${student.name} profile'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
