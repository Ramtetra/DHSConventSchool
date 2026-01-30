import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/teacher_provider.dart';
import '../../utils/info_card.dart';
import '../../utils/profile_header.dart';
import '../../utils/session_manager.dart';
import '../admin/login_screen.dart';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState
    extends ConsumerState<TeacherProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final teacherAsync = ref.watch(teacherProvider);

    return teacherAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (teacher) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// Profile Header
              ProfileHeader(teacher: teacher),

              const SizedBox(height: 16),

              /// Personal Info
              InfoCard(
                title: 'Personal Information',
                children: [
                  InfoRow(
                    icon: Icons.person,
                    label: 'Name',
                    value: teacher.name,
                  ),
                  InfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: teacher.email,
                  ),
                  InfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: teacher.phone,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Academic Info
              InfoCard(
                title: 'Academic Information',
                children: [
                  InfoRow(
                    icon: Icons.book,
                    label: 'Subject',
                    value: teacher.subject,
                  ),
                  InfoRow(
                    icon: Icons.class_,
                    label: 'Classes',
                    value: teacher.classes.join(', '),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Account Actions
              InfoCard(
                title: 'Account',
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  ListTile(
                    leading:
                    const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      await SessionManager.logout();

                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
