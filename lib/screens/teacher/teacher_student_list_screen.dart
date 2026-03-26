// lib/screens/teacher/teacher_student_list_screen.dart
import 'package:dhs/screens/teacher/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import '../../utils/student_card.dart';
import '../admin/add_student_screen.dart';

class TeacherStudentListScreen extends ConsumerStatefulWidget {
  const TeacherStudentListScreen({super.key});

  @override
  ConsumerState<TeacherStudentListScreen> createState() =>
      _TeacherStudentListScreenState();
}

class _TeacherStudentListScreenState
    extends ConsumerState<TeacherStudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedClass = 'All';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });
      // Update search query in provider
      ref.read(studentSearchQueryProvider.notifier).state = _searchController.text;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Use convertedStudentListProvider which returns List<StudentModel>
    final studentsAsync = ref.watch(convertedStudentListProvider);
    final selectedClass = ref.watch(studentClassFilterProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildBody(studentsAsync, selectedClass),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Students',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      elevation: 2,
      backgroundColor: Colors.white,
      foregroundColor: Colors.indigo,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshStudentList,
          tooltip: 'Refresh',
        ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
            tooltip: 'Clear search',
          ),
      ],
    );
  }

  // ==================== FLOATING ACTION BUTTON ====================
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _addStudent,
      icon: const Icon(Icons.person_add_alt_1),
      label: const Text('Add Student'),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ==================== BODY ====================
  Widget _buildBody(
      AsyncValue<List<StudentModel>> studentsAsync,
      String selectedClass,
      ) {
    return studentsAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading students...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading students',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshStudentList,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      data: (allStudents) {
        // Get class filters from actual data
        final classFilters = _getClassFilters(allStudents);
        final filteredStudents = _filterStudents(allStudents, selectedClass);

        if (filteredStudents.isEmpty) {
          return _buildEmptyState(classFilters.length > 1);
        }

        return RefreshIndicator(
          onRefresh: _refreshStudentList,
          color: Colors.indigo,
          child: Column(
            children: [
              _buildSearchBar(),
              if (classFilters.length > 1)
                _buildClassFilters(classFilters, selectedClass),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return StudentCard(
                      student: student,
                      onTap: () => _navigateToStudentDetails(student),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== SEARCH BAR ====================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, email, or parent name...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: _clearSearch,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }

  // ==================== CLASS FILTERS ====================
  Widget _buildClassFilters(List<String> classFilters, String selectedClass) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: classFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cls = classFilters[index];
          final isSelected = selectedClass == cls;

          return FilterChip(
            label: Text(cls),
            selected: isSelected,
            onSelected: (_) => _selectClass(cls),
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState(bool hasFilters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? 'No students match your filters'
                : 'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your search or filters'
                : 'Click the + button to add a student',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (hasFilters)
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  List<String> _getClassFilters(List<StudentModel> students) {
    final classes = students
        .map((student) => "Class ${student.className}")
        .where((className) =>
    className.isNotEmpty &&
        className != "Class null" &&
        className != "Class " &&
        className != "Class")
        .toSet()
        .toList();

    // Sort classes numerically
    classes.sort((a, b) {
      final aNum = int.tryParse(a.replaceAll('Class ', '')) ?? 0;
      final bNum = int.tryParse(b.replaceAll('Class ', '')) ?? 0;
      return aNum.compareTo(bNum);
    });

    return ['All', ...classes];
  }

  List<StudentModel> _filterStudents(
      List<StudentModel> students,
      String selectedClass,
      ) {
    final searchQuery = _searchController.text.trim().toLowerCase();

    return students.where((student) {
      // Search filter
      final matchesSearch = searchQuery.isEmpty ||
          student.name.toLowerCase().contains(searchQuery) ||
          student.email.toLowerCase().contains(searchQuery) ||
          student.parentName.toLowerCase().contains(searchQuery) ||
          student.mobile.toLowerCase().contains(searchQuery);

      // Class filter
      final className = "Class ${student.className}";
      final matchesClass = selectedClass == 'All' || className == selectedClass;

      return matchesSearch && matchesClass;
    }).toList();
  }

  Future<void> _refreshStudentList() async {
    // Invalidate both providers to ensure fresh data
    ref.invalidate(convertedStudentListProvider);
    ref.invalidate(studentListProvider);
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddStudentScreen()),
    );

    if (result == true && mounted) {
      await _refreshStudentList();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _navigateToStudentDetails(StudentModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailScreen(student: student),
      ),
    ).then((result) async {
      if (result == true && mounted) {
        await _refreshStudentList();
      }
    });
  }

  void _selectClass(String className) {
    setState(() {
      _selectedClass = className;
    });
    // Update provider
    ref.read(studentClassFilterProvider.notifier).state = className;
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    // Clear search in provider
    ref.read(studentSearchQueryProvider.notifier).state = '';
  }

  void _clearFilters() {
    _clearSearch();
    _selectClass('All');
  }
}