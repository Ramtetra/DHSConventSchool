import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../responsemodel/StudentDetailsModel.dart';

class StudentDetailScreen extends ConsumerStatefulWidget {
  final StudentDetailsModel student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  ConsumerState<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState
    extends ConsumerState<StudentDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          /// 🔥 Modern Gradient AppBar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF357ABD),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    /// Profile Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          student.studentName
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF357ABD),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Name
                    Text(
                      student.studentName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Class & Roll
                    Text(
                      "Class ${student.classes} • Roll No: ${student.studentId}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔥 Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  buildInfoTile(
                      Icons.school,
                      "Section",
                      student.section.join(", ")),

                  buildInfoTile(
                      Icons.cake,
                      "Date of Birth",
                      student.dob.split("T")[0]),

                  buildInfoTile(
                      Icons.person,
                      "Gender",
                      student.gender),

                  buildInfoTile(
                      Icons.phone,
                      "Mobile",
                      student.mobile),

                  buildInfoTile(
                      Icons.email,
                      "Email",
                      student.email),

                  buildInfoTile(
                      Icons.home,
                      "Address",
                      student.address),

                  buildInfoTile(
                      Icons.family_restroom,
                      "Parent Name",
                      student.parentName),

                  buildInfoTile(
                      Icons.badge,
                      "Role",
                      student.role),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Beautiful Info Tile
  Widget buildInfoTile(
      IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          const Color(0xFF4A90E2).withOpacity(0.1),
          child: Icon(icon,
              color: const Color(0xFF4A90E2)),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
              fontSize: 14),
        ),
      ),
    );
  }
}