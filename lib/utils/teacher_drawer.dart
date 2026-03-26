import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_model.dart';
import '../providers/teacher_provider.dart';
import 'logout_dialog.dart';

class TeacherDrawer extends ConsumerWidget {
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Use the correct provider that returns TeacherModel
    final teacherAsync = ref.watch(userProvider);

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(teacherAsync), // ✅ No type casting needed
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _getDrawerItems(context),
            ),
          ),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(AsyncValue<TeacherModel?> teacherAsync) {
    return teacherAsync.when(
      data: (teacher) {
        final name = teacher?.teacherName ?? teacher?.teacherName ?? 'Teacher';
        final imagePath = teacher?.imagePath;
        final qualification = teacher?.qualification ?? '';
        final experience = teacher?.experience ?? '';
        final email = teacher?.email ?? '';

        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          currentAccountPicture: _buildProfileImage(imagePath, name),
          accountName: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          accountEmail: Text(
            _getTeacherInfo(qualification, experience, email),
            style: const TextStyle(
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      loading: () => const UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blue],
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        accountName: Text('Loading...'),
        accountEmail: Text('Loading...'),
      ),
      error: (error, stack) => UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blue],
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: const Icon(Icons.error, color: Colors.red, size: 30),
        ),
        accountName: Text('Error'),
        accountEmail: Text(error.toString().substring(0, 30)),
      ),
    );
  }

  Widget _buildProfileImage(String? imagePath, String name) {
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.white,
      child: hasImage
          ? ClipOval(
        child: Image.network(
          imagePath!,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar(name);
          },
        ),
      )
          : _buildInitialsAvatar(name),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    String initials = _getInitials(name);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.indigo.shade300, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 24,
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
      final firstInitial = nameParts[0].isNotEmpty ? nameParts[0][0] : '';
      final secondInitial = nameParts[1].isNotEmpty ? nameParts[1][0] : '';
      return '$firstInitial$secondInitial'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'T';
  }

  String _getTeacherInfo(String qualification, String experience, String email) {
    final parts = <String>[];

    if (qualification.isNotEmpty) {
      parts.add(qualification);
    }

    if (experience.isNotEmpty) {
      parts.add(experience);
    }

    if (parts.isEmpty && email.isNotEmpty) {
      return email;
    }

    if (parts.isEmpty) {
      return 'Teacher';
    }

    return parts.join(' • ');
  }

  List<Widget> _getDrawerItems(BuildContext context) {
    final drawerItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard'},
      {'icon': Icons.check_circle, 'title': 'Attendance'},
      {'icon': Icons.menu_book, 'title': 'Homework'},
      {'icon': Icons.edit_note, 'title': 'Marks Entry'},
      {'icon': Icons.people, 'title': 'My Classes'},
      {'icon': Icons.school, 'title': 'Subjects'},
      {'icon': Icons.calendar_today, 'title': 'Timetable'},
      {'icon': Icons.settings, 'title': 'Settings'},
    ];

    return drawerItems.map((item) {
      return _DrawerItem(
        icon: item['icon'] as IconData,
        title: item['title'] as String,
        onTap: () {
          Navigator.pop(context);
          _handleNavigation(context, item['title'] as String);
        },
      );
    }).toList();
  }

  void _handleNavigation(BuildContext context, String title) {
    // Handle navigation based on title
    switch (title) {
      case 'Dashboard':
      // Navigate to dashboard
        break;
      case 'Attendance':
      // Navigate to attendance
        break;
      case 'Homework':
      // Navigate to homework
        break;
      case 'Marks Entry':
      // Navigate to marks entry
        break;
      case 'My Classes':
      // Navigate to my classes
        break;
      case 'Subjects':
      // Navigate to subjects
        break;
      case 'Timetable':
      // Navigate to timetable
        break;
      case 'Settings':
      // Navigate to settings
        break;
    }
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                Navigator.pop(context);
                showLogoutDialog(context);
              },
              color: Colors.red,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).iconTheme.color,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      hoverColor: Colors.grey.withOpacity(0.1),
      splashColor: Colors.grey.withOpacity(0.2),
      dense: true,
    );
  }
}