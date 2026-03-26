import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import '../../utils/teacher_card.dart';
import 'add_teacher_screen.dart';
import 'admin_teacher_profile_screen.dart';

class AdminTeacherListScreen extends ConsumerStatefulWidget {
  const AdminTeacherListScreen({super.key});

  @override
  ConsumerState<AdminTeacherListScreen> createState() =>
      _AdminTeacherListScreenState();
}

class _AdminTeacherListScreenState
    extends ConsumerState<AdminTeacherListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'All';
  bool _isSearching = false;

  // Department filters with icons
  final List<DepartmentFilter> _departmentFilters = const [
    DepartmentFilter(name: 'All', icon: Icons.all_inclusive),
    DepartmentFilter(name: 'Math', icon: Icons.calculate),
    DepartmentFilter(name: 'English', icon: Icons.translate),
    DepartmentFilter(name: 'Hindi', icon: Icons.language),
    DepartmentFilter(name: 'Physics', icon: Icons.science),
    DepartmentFilter(name: 'Chemistry', icon: Icons.science),
    DepartmentFilter(name: 'Biology', icon: Icons.biotech),
    DepartmentFilter(name: 'History', icon: Icons.history),
  ];

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
    final teacherAsync = ref.watch(teacherListProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildDepartmentFilters(),
          const SizedBox(height: 12),
          _buildTeacherList(teacherAsync),
        ],
      ),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Teachers',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshTeacherList,
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
      onPressed: _addTeacher,
      icon: const Icon(Icons.person_add_alt_1),
      label: const Text('Add Teacher'),
      elevation: 4,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  // ==================== SEARCH BAR ====================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, email, or qualification...',
          prefixIcon: const Icon(Icons.search),
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
        ),
      ),
    );
  }

  // ==================== DEPARTMENT FILTERS ====================
  Widget _buildDepartmentFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _departmentFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _departmentFilters[index];
          final isSelected = _selectedDepartment == filter.name;

          return FilterChip(
            label: Text(filter.name),
            selected: isSelected,
            onSelected: (_) => _selectDepartment(filter.name),
            avatar: isSelected
                ? Icon(filter.icon, size: 18)
                : null,
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  // ==================== TEACHER LIST ====================
  Widget _buildTeacherList(AsyncValue<List<TeacherModel>> teacherAsync) {
    return Expanded(
      child: teacherAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading teachers...'),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Error loading teachers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _refreshTeacherList,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (teachers) {
          final filteredTeachers = _filterTeachers(teachers);

          if (filteredTeachers.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshTeacherListAsync, // ✅ Changed to async function
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: filteredTeachers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final teacher = filteredTeachers[index];
                return TeacherCard(
                  teacher: teacher,
                  onTap: () => _navigateToTeacherProfile(teacher),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ==================== FILTER LOGIC ====================
  List<TeacherModel> _filterTeachers(List<TeacherModel> teachers) {
    final searchQuery = _searchController.text.trim().toLowerCase();

    return teachers.where((teacher) {
      // Search filter
      final matchesSearch = searchQuery.isEmpty ||
          teacher.teacherName.toLowerCase().contains(searchQuery) ||
          teacher.email.toLowerCase().contains(searchQuery) ||
          teacher.qualification.toLowerCase().contains(searchQuery) ||
          (teacher.subjects?.any((subject) =>
              subject.toLowerCase().contains(searchQuery)) ?? false);

      // Department filter
      final matchesDepartment = _selectedDepartment == 'All' ||
          (teacher.subjects?.contains(_selectedDepartment) ?? false);

      return matchesSearch && matchesDepartment;
    }).toList();
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty || _selectedDepartment != 'All'
                ? 'No teachers match your filters'
                : 'No teachers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty || _selectedDepartment != 'All'
                ? 'Try adjusting your search or filters'
                : 'Click the + button to add a teacher',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchController.text.isNotEmpty || _selectedDepartment != 'All')
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }

  // ==================== HELPER METHODS ====================

  // ✅ Synchronous refresh method for button clicks
  void _refreshTeacherList() {
    ref.invalidate(teacherListProvider);
  }

  // ✅ Async refresh method for RefreshIndicator
  Future<void> _refreshTeacherListAsync() async {
    ref.invalidate(teacherListProvider);
    // Wait for the refresh to complete
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _addTeacher() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTeacherScreen()),
    );

    if (result == true) {
      _refreshTeacherList();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Teacher added successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToTeacherProfile(TeacherModel teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminTeacherProfileScreen(teacher: teacher),
      ),
    ).then((_) {
      // Refresh when returning from profile
      _refreshTeacherList();
    });
  }

  void _selectDepartment(String department) {
    setState(() {
      _selectedDepartment = department;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearFilters() {
    _clearSearch();
    _selectDepartment('All');
  }
}

// ==================== DEPARTMENT FILTER MODEL ====================
class DepartmentFilter {
  final String name;
  final IconData icon;

  const DepartmentFilter({
    required this.name,
    required this.icon,
  });
}