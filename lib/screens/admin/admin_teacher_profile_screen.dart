import 'package:flutter/material.dart';

import '../../models/teacher_model.dart';

class AdminTeacherProfileScreen extends StatelessWidget {
  final TeacherModel teacher;

  const AdminTeacherProfileScreen({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: isDesktop
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _profileCard()),
            const SizedBox(width: 20),
            Expanded(flex: 5, child: _detailsSection()),
          ],
        )
            : Column(
          children: [
            _profileCard(),
            const SizedBox(height: 20),
            _detailsSection(),
          ],
        ),
      ),
    );
  }

  // ================= LEFT PROFILE =================
  Widget _profileCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: teacher.imagePath != null &&
                  teacher.imagePath!.isNotEmpty
                  ? NetworkImage(teacher.imagePath!)
                  : const AssetImage("assets/images/default_user.png")
              as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              teacher.teacherName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.qualification,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                "${teacher.experience} Years Experience",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= RIGHT DETAILS =================
  Widget _detailsSection() {
    return Column(
      children: [
        _detailCard("Personal Information", [
          _row("Gender", teacher.gender),
          _row("Qualification", teacher.qualification),
          _row("Experience", teacher.experience),
        ]),
        _detailCard("Contact Details", [
          _row("Mobile", teacher.mobile),
          _row("Email", teacher.email),
          _row("Address", teacher.address),
        ]),
        _detailCard("Subjects & Classes", [
          _row(
            "Subjects",
            teacher.subjects?.join(", "),
          ),
          _row(
            "Classes",
            teacher.classes?.join(", "),
          ),
        ]),
      ],
    );
  }
}

// ================= UI HELPERS =================

Widget _detailCard(String title, List<Widget> children) {
  return Card(
    margin: const EdgeInsets.only(bottom: 18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    ),
  );
}

Widget _row(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value == null || value.isEmpty ? "N/A" : value,
          ),
        ),
      ],
    ),
  );
}
