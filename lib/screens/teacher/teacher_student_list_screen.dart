import 'package:dhs/screens/teacher/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/student_provider.dart';
import '../../utils/student_card.dart';

class TeacherStudentListScreen extends ConsumerStatefulWidget {
  const TeacherStudentListScreen({super.key});

  @override
  ConsumerState<TeacherStudentListScreen> createState() =>
      _TeacherStudentListScreenState();
}

class _TeacherStudentListScreenState
    extends ConsumerState<TeacherStudentListScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String selectedClass = 'All';

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        centerTitle: true,
      ),
      body: studentsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text("Error: $e")),
        data: (allStudents) {
          /// Dynamic Class Filters from API
          final classFilters = [
            'All',
            ...allStudents
                .map((e) => "Class ${e.classes}")
                .toSet()
          ];

          /// Filtering
          final filteredStudents =
          allStudents.where((s) {
            final className = "Class ${s.classes}";

            final matchClass =
                selectedClass == 'All' ||
                    className == selectedClass;

            final matchSearch = s.studentName
                .toLowerCase()
                .contains(
                _searchController.text
                    .toLowerCase());

            return matchClass && matchSearch;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(studentListProvider);
            },
            child: Column(
              children: [
                /// Search Bar
                Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: TextField(
                    controller:
                    _searchController,
                    onChanged: (_) =>
                        setState(() {}),
                    decoration:
                    InputDecoration(
                      hintText:
                      'Search student...',
                      prefixIcon:
                      const Icon(
                          Icons.search),
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            16),
                      ),
                    ),
                  ),
                ),

                /// Class Filter Chips
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding:
                    const EdgeInsets
                        .symmetric(
                        horizontal:
                        16),
                    scrollDirection:
                    Axis.horizontal,
                    itemCount:
                    classFilters.length,
                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                        width: 8),
                    itemBuilder:
                        (context, index) {
                      final cls =
                      classFilters[
                      index];
                      final isSelected =
                          selectedClass ==
                              cls;

                      return ChoiceChip(
                        label: Text(cls),
                        selected:
                        isSelected,
                        onSelected: (_) {
                          setState(() =>
                          selectedClass =
                              cls);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// Student List
                Expanded(
                  child:
                  filteredStudents
                      .isEmpty
                      ? const Center(
                      child: Text(
                          'No students found'))
                      : ListView
                      .separated(
                    padding:
                    const EdgeInsets
                        .all(
                        16),
                    itemCount:
                    filteredStudents
                        .length,
                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                        height:
                        8),
                    itemBuilder:
                        (context,
                        index) {
                      final student =
                      filteredStudents[
                      index];

                      return StudentCard(
                        student: student,
                        onTap: () {
                          Navigator
                              .push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentDetailScreen(
                                    student:
                                    student,
                                  ),
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
        },
      ),
    );
  }
}