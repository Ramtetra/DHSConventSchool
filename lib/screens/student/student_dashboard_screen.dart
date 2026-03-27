// student_dashboard_screen.dart
import 'package:dhs/screens/student/student_attendance_screen.dart';
import 'package:dhs/screens/student/student_home_work_screen.dart';
import 'package:dhs/screens/student/student_time_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/logout_dialog.dart';
import '../../utils/session_manager.dart';
import '../../utils/stat_card.dart';
import '../../models/user_session.dart';
import '../admin/login_screen.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends ConsumerState<StudentDashboardScreen> {
  bool _isLoading = true;
  UserSession? _userSession;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    await _verifyStudentSession();
    await _loadUserData();
    await _loadStudentData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyStudentSession() async {
    final loggedIn = await SessionManager.isLoggedIn();
    final userSession = await SessionManager.getUserSession();

    if (!mounted) return;

    // Check if user is logged in and is a student
    if (!loggedIn || userSession?.role != UserRole.student) {
      await SessionManager.logout();
      _forceToLogin();
    } else {
      setState(() {
        _userSession = userSession;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userSession = await SessionManager.getUserSession();
      if (mounted && userSession != null) {
        setState(() {
          _userSession = userSession;
        });

        // Debug print to verify
        print('Student loaded: ${userSession.name}');
        print('Student Class: ${userSession.studentClass}');
        print('Student Section: ${userSession.section}');
        print('Student ID: ${userSession.studentId}');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadStudentData() async {
    try {
      // Get student ID from session
      final studentId = await SessionManager.getStudentId();

      if (studentId != null && studentId.isNotEmpty) {
        // If you have a method to fetch student details from API
        // final studentData = await ref.read(studentProvider.notifier).getStudentById(studentId);
        // if (mounted) {
        //   setState(() => _studentData = studentData);
        // }

        // For now, create StudentModel from session data
        if (mounted && _userSession != null) {
          setState(() {
          });
        }
      } else {
        print('Student ID not found in session');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading student data: $e')),
        );
      }
      print('Error loading student data: $e');
    }
  }
// Helper method to safely convert section to string
  void _forceToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(theme),
      drawer: _buildDrawer(context),
      body: _buildBody(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: const Text(
        "Student Dashboard",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: _handleNotifications,
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshDashboard,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentHeader(theme),
            const SizedBox(height: 16),
            _buildStatsSection(theme),
            const SizedBox(height: 16),
            _buildQuickAccessSection(theme),
           // const SizedBox(height: 16),
            _buildUpdatesSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(_userSession?.name ?? 'Student'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userSession?.name ?? 'Student Name',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStudentInfo(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userSession?.email ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blue.shade100,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _getStatsData().length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stat = _getStatsData()[index];
          return StatCard(
            title: stat['title']!,
            value: stat['value']!,
            icon: stat['icon'] as IconData,
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getStatsData() {
    return [
      {
        'title': 'Attendance',
        'value': '92%',
        'icon': Icons.fact_check,
        'color': Colors.blue,
      },
      {
        'title': 'Homework',
        'value': '3 Due',
        'icon': Icons.book,
        'color': Colors.orange,
      },
      {
        'title': 'Exams',
        'value': '2 Upcoming',
        'icon': Icons.event,
        'color': Colors.red,
      },
      {
        'title': 'Grade',
        'value': 'A',
        'icon': Icons.grade,
        'color': Colors.green,
      },
    ];
  }

  Widget _buildQuickAccessSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.9,
          children: _getFeatureTiles(),
        ),
      ],
    );
  }

  List<Widget> _getFeatureTiles() {
    final features = [
      {'icon': Icons.schedule, 'label': 'Timetable', 'screen': const StudentTimetableScreen()},
      {'icon': Icons.check_circle, 'label': 'Attendance', 'screen': const StudentAttendanceScreen()},
      {'icon': Icons.menu_book, 'label': 'Homework', 'screen': const StudentHomeworkScreen()},
      {'icon': Icons.folder, 'label': 'Study Material', 'screen': null},
      {'icon': Icons.event_note, 'label': 'Exams', 'screen': null},
      {'icon': Icons.bar_chart, 'label': 'Results', 'screen': null},
    ];

    return features.map((feature) {
      return FeatureTile(
        icon: feature['icon'] as IconData,
        label: feature['label'] as String,
        onTap: () => _navigateToScreen(feature['screen'] as Widget?),
      );
    }).toList();
  }

  Widget _buildUpdatesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Latest Updates",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
       // const SizedBox(height: 8),
        Card(
          elevation: 1,
          child: Column(
            children: [
              _buildUpdateItem(
                icon: Icons.notifications_active,
                title: "Math homework due tomorrow",
                subtitle: "Chapter 7: Algebra",
                timeAgo: "2 hours ago",
                color: Colors.orange,
              ),
              const Divider(height: 1),
              _buildUpdateItem(
                icon: Icons.calendar_today,
                title: "Unit test starts next week",
                subtitle: "Science & Mathematics",
                timeAgo: "Yesterday",
                color: Colors.blue,
              ),
              const Divider(height: 1),
              _buildUpdateItem(
                icon: Icons.announcement,
                title: "Parent-Teacher Meeting",
                subtitle: "Saturday, 10:00 AM",
                timeAgo: "2 days ago",
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String timeAgo,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        timeAgo,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      isThreeLine: false,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _getDrawerItems(),
            ),
          ),
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade700, Colors.blue.shade900],
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          _userSession?.name.isNotEmpty == true
              ? _userSession!.name[0].toUpperCase()
              : 'S',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      accountName: Text(
        _userSession?.name ?? 'Student Name',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      accountEmail: Text(_getStudentInfo()),
    );
  }

  List<Widget> _getDrawerItems() {
    final drawerItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard', 'screen': null},
      {'icon': Icons.schedule, 'title': 'Timetable', 'screen': const StudentTimetableScreen()},
      {'icon': Icons.fact_check, 'title': 'Attendance', 'screen': const StudentAttendanceScreen()},
      {'icon': Icons.menu_book, 'title': 'Homework', 'screen': const StudentHomeworkScreen()},
      {'icon': Icons.folder, 'title': 'Study Materials', 'screen': null},
      {'icon': Icons.event_note, 'title': 'Exam Schedule', 'screen': null},
      {'icon': Icons.bar_chart, 'title': 'Results', 'screen': null},
      {'icon': Icons.person, 'title': 'Profile', 'screen': null},
    ];

    return drawerItems.map((item) {
      return ListTile(
        leading: Icon(item['icon'] as IconData),
        title: Text(item['title'] as String),
        onTap: () {
          Navigator.pop(context);
          if (item['screen'] != null) {
            _navigateToScreen(item['screen'] as Widget);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      );
    }).toList();
  }

  Widget _buildDrawerFooter() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.red),
          ),
          onTap: _handleLogout,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        ),
      ),
    );
  }

  void _navigateToScreen(Widget? screen) {
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon!')),
      );
    }
  }

  void _handleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications feature coming soon!')),
    );
  }

  Future<void> _refreshDashboard() async {
    setState(() => _isLoading = true);
    await _loadUserData();
    await _loadStudentData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handleLogout() {
    showLogoutDialog(context);
  }

  String _getStudentInfo() {
    if (_userSession == null) return 'Loading...';

    final parts = <String>[];

    if (_userSession!.studentClass != null && _userSession!.studentClass!.isNotEmpty) {
      parts.add('Class ${_userSession!.studentClass}');
    }

    if (_userSession!.section != null && _userSession!.section!.isNotEmpty) {
      parts.add('Section ${_userSession!.section!.join(', ')}');
    }

    if (_userSession!.parentName != null && _userSession!.parentName!.isNotEmpty) {
      parts.add('Parent: ${_userSession!.parentName}');
    }

    return parts.isNotEmpty ? parts.join(' • ') : 'Student Information';
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// FeatureTile Widget
class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}