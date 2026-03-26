import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhs/screens/teacher/teacher_attendance_screen.dart';
import 'package:dhs/screens/teacher/teacher_homework_screen.dart';
import 'package:dhs/screens/teacher/teacher_mark_entry_screen.dart';
import 'package:dhs/screens/teacher/teacher_notice_screen.dart';
import 'package:dhs/screens/teacher/teacher_student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import '../../utils/class_title.dart';
import '../../utils/teacher_action_tile.dart';
import '../../utils/teacher_drawer.dart';
import '../../utils/teacher_state_card.dart';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends ConsumerState<TeacherDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const TeacherDrawer(),
      body: _buildBody(userAsync, theme),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Teacher Dashboard",
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

  // ==================== BODY ====================
  Widget _buildBody(AsyncValue<TeacherModel?> userAsync, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Teacher Profile Card (Dynamic)
            _buildTeacherProfileCard(userAsync, theme),

            const SizedBox(height: 20),

            /// 📊 Today Summary
            _buildStatsSection(),

            const SizedBox(height: 24),

            /// ⚡ Quick Actions
            _buildQuickActionsSection(theme),

            const SizedBox(height: 24),

            /// 🏫 My Classes
            _buildMyClassesSection(theme),
          ],
        ),
      ),
    );
  }

  // ==================== TEACHER PROFILE CARD ====================
  Widget _buildTeacherProfileCard(AsyncValue<TeacherModel?> userAsync, ThemeData theme) {
    return userAsync.when(
      data: (teacher) {
        final name = teacher?.teacherName ?? teacher?.teacherName ?? 'Teacher';
        final email = teacher?.email ?? '';
        final qualification = teacher?.qualification ?? '';
        final experience = teacher?.experience ?? '';
        final imagePath = teacher?.imagePath;
        final classes = teacher?.classes ?? [];
        final subjects = teacher?.subjects ?? [];

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1a237e),
                  const Color(0xFF283593),
                  const Color(0xFF3949ab),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Header
                  Row(
                    children: [
                      // Profile Image
                      _buildProfileImage(imagePath, name),

                      const SizedBox(width: 16),

                      // Teacher Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Qualification & Experience Chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (qualification.isNotEmpty)
                                  _buildInfoChip(
                                    icon: Icons.school,
                                    label: qualification,
                                  ),
                                if (experience.isNotEmpty)
                                  _buildInfoChip(
                                    icon: Icons.work,
                                    label: experience,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Edit Profile Button
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => _editProfile(teacher),
                        tooltip: 'Edit Profile',
                      ),
                    ],
                  ),

                 // const SizedBox(height: 16),

               /*   // Stats Row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          value: classes.length.toString(),
                          label: 'Classes',
                          icon: Icons.class_,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          value: subjects.length.toString(),
                          label: 'Subjects',
                          icon: Icons.book,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          value: experience.split(' ').first,
                          label: 'Experience',
                          icon: Icons.timeline,
                        ),
                      ],
                    ),
                  ),

                  // Classes & Subjects Tags
                  if (classes.isNotEmpty || subjects.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (classes.isNotEmpty)
                            _buildTagRow(
                              icon: Icons.class_,
                              label: 'Classes',
                              items: classes,
                            ),
                          const SizedBox(height: 8),
                          if (subjects.isNotEmpty)
                            _buildTagRow(
                              icon: Icons.subject,
                              label: 'Subjects',
                              items: subjects,
                            ),
                        ],
                      ),
                    ),*/
                ],
              ),
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildProfileImage(String? imagePath, String name) {
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        child: hasImage
            ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: imagePath!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => _buildInitialsAvatar(name),
          ),
        )
            : _buildInitialsAvatar(name),
      ),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    String initials = _getInitials(name);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.indigo.shade300, Colors.indigo.shade700],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'T';
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildLoadingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade700, Colors.indigo.shade900],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Loading profile...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.shade50,
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 8),
            const Text(
              'Failed to load profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refreshDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STATS SECTION ====================
  Widget _buildStatsSection() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stats = [
            {'title': 'Classes', 'value': '5 Today', 'icon': Icons.class_},
            {'title': 'Attendance', 'value': '2 Pending', 'icon': Icons.fact_check},
            {'title': 'Homework', 'value': '3 Review', 'icon': Icons.menu_book},
          ];
          final stat = stats[index];
          return TeacherStatCard(
            title: stat['title'] as String,
            value: stat['value'] as String,
            icon: stat['icon'] as IconData,
          );
        },
      ),
    );
  }

  // ==================== QUICK ACTIONS SECTION ====================
  Widget _buildQuickActionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
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
          children: [
            TeacherActionTile(
              icon: Icons.check_circle,
              label: "Attendance",
              onTap: () => _navigateTo(const TeacherAttendanceScreen()),
            ),
            TeacherActionTile(
              icon: Icons.upload_file,
              label: "Homework",
              onTap: () => _navigateTo(const TeacherHomeworkScreen()),
            ),
            TeacherActionTile(
              icon: Icons.people,
              label: "Students",
              onTap: () => _navigateTo(const TeacherStudentListScreen()),
            ),
            TeacherActionTile(
              icon: Icons.edit_note,
              label: "Marks Entry",
              onTap: () => _navigateTo(const TeacherMarkEntryScreen()),
            ),
            TeacherActionTile(
              icon: Icons.notifications,
              label: "Notices",
              onTap: () => _navigateTo(const TeacherNoticeScreen()),
            ),
            TeacherActionTile(
              icon: Icons.person,
              label: "Profile",
              onTap: () => _editProfile(null),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== MY CLASSES SECTION ====================
  Widget _buildMyClassesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Classes",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const ClassTile(className: "Class 8 A"),
        const ClassTile(className: "Class 9 B"),
        const ClassTile(className: "Class 10 C"),
      ],
    );
  }

  // ==================== HELPER METHODS ====================
  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _editProfile(TeacherModel? teacher) {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit Profile coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshDashboard() async {
    ref.invalidate(userProvider);
    setState(() {});
  }
}