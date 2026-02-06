import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/teacher_provider.dart';
import '../../utils/teacher_card.dart';
import 'add_teacher_screen.dart';

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

  final List<String> departmentFilters = const [
    'All',
    'Math',
    'English',
    'Hindi',
    'Physics',
    'Chemistry',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherAsync = ref.watch(teacherListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(teacherListProvider);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTeacherScreen()),
          );

          // Refresh after coming back
          ref.invalidate(teacherListProvider);
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Teacher'),
      ),

      body: Column(
        children: [
          // 🔍 Search
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

          // 🏷 Filters
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

          // 👨‍🏫 Teacher List (API)
          Expanded(
            child: teacherAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, _) => Center(
                child: Text('Error: $err'),
              ),
              data: (teachers) {
                final filtered = teachers.where((t) {
                  final matchSearch = t.teacherName
                      ?.toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ??
                      false;

                  final matchDept = selectedDepartment == 'All' ||
                      (t.subjects?.contains(selectedDepartment) ?? false);

                  return matchSearch && matchDept;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No teachers found'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(teacherListProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final teacher = filtered[index];

                      return TeacherCard(
                        teacher: teacher,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Open ${teacher.teacherName} profile'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
