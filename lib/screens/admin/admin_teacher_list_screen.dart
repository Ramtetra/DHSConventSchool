import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/teacher_model.dart';
import '../../utils/teacher_card.dart';

class AdminTeacherListScreen extends ConsumerStatefulWidget {
  const AdminTeacherListScreen({super.key});

  @override
  ConsumerState<AdminTeacherListScreen> createState() =>
      _AdminTeacherListScreenState();
}

class _AdminTeacherListScreenState
    extends ConsumerState<AdminTeacherListScreen> {

  final TextEditingController _searchController = TextEditingController();

  String selectedDepartment = 'All';

  final List<String> departmentFilters = [
    'All',
    'Mathematics',
    'Science',
    'English',
    'Hindi',
    'Computer',
  ];

  /// Mock Data (Replace with API)
  final List<TeacherModel> allTeachers = [
    TeacherModel(
      id: '1',
      name: 'Mr. Rajesh Sharma',
      subject: 'Mathematics',
      email: 'rajesh@school.com',
      phone: '9876543210',
      avatarUrl: '',
      status: TeacherStatus.active,
    ),
    TeacherModel(
      id: '2',
      name: 'Ms. Neha Verma',
      subject: 'Science',
      email: 'neha@school.com',
      phone: '9876500000',
      avatarUrl: '',
      status: TeacherStatus.active,
    ),
    TeacherModel(
      id: '3',
      name: 'Mr. Amit Kumar',
      subject: 'English',
      email: 'amit@school.com',
      phone: '9876511111',
      avatarUrl: '',
      status: TeacherStatus.inactive,
    ),
  ];

  List<TeacherModel> get filteredTeachers {
    return allTeachers.where((t) {
      final matchDept =
          selectedDepartment == 'All' || t.subject == selectedDepartment;

      final matchSearch = t.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchDept && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export coming soon')),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Add Teacher Screen
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Teacher'),
      ),

      body: Column(
        children: [
          /// 🔍 Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          /// 🏷 Department Filters
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: departmentFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final dept = departmentFilters[index];
                final isSelected = selectedDepartment == dept;

                return ChoiceChip(
                  label: Text(dept),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedDepartment = dept);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// 👨‍🏫 Teacher List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: API reload
                await Future.delayed(const Duration(seconds: 1));
              },
              child: filteredTeachers.isEmpty
                  ? const Center(child: Text('No teachers found'))
                  : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTeachers.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final teacher = filteredTeachers[index];

                  return TeacherCard(
                    teacher: teacher,
                    onTap: () {
                      // TODO: Navigate to Teacher Detail Screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('Open ${teacher.name} profile'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
