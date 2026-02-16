import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';
import '../../utils/action_button.dart';
import '../../utils/admin_drawer.dart';
import '../../utils/dashboard_card.dart';
import '../../utils/report_title.dart';
import '../../utils/session_manager.dart';
import 'add_student_screen.dart';
import 'add_teacher_screen.dart';
import 'admin_attendance_screen.dart';
import 'admin_fee_structure_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends ConsumerState<AdminDashboardScreen> {

  @override
  void initState() {
    super.initState();
    _verifyAdminSession();
  }

  // ================= SESSION GUARD =================
  Future<void> _verifyAdminSession() async {
    final loggedIn = await SessionManager.isLoggedIn();
    final role = await SessionManager.getUserRole();

    if (!mounted) return;

    if (!loggedIn || role != UserRole.admin) {
      await SessionManager.logout();
      _forceToLogin();
    }
  }

  void _forceToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final countAsync = ref.watch(countProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager.logout();
              _forceToLogin();
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(countProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= WELCOME =================
              Text(
                "Welcome, Admin 👋",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ================= DASHBOARD COUNT =================
              countAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Text("Error: ${err.toString()}"),
                ),
                data: (count) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      DashboardCard(
                        title: "Students",
                        value: count.totalStudents.toString(),
                        icon: Icons.groups,
                        color: Colors.blue,
                      ),
                      DashboardCard(
                        title: "Teachers",
                        value: count.totalTeachers.toString(),
                        icon: Icons.school,
                        color: Colors.green,
                      ),
                      const DashboardCard(
                        title: "Attendance",
                        value: "92%",
                        icon: Icons.fact_check,
                        color: Colors.orange,
                      ),
                      const DashboardCard(
                        title: "Pending Fees",
                        value: "₹1.2L",
                        icon: Icons.currency_rupee,
                        color: Colors.red,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // ================= QUICK ACTIONS =================
              Text(
                "Quick Actions",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ActionButton(
                    icon: Icons.person_add,
                    label: "Add Student",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddStudentScreen(),
                        ),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.person_add_alt,
                    label: "Add Teacher",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTeacherScreen(),
                        ),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.assignment,
                    label: "Attendance",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminAttendanceScreen(),
                        ),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.receipt_long,
                    label: "Fee Report",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminFeeStructureScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ================= REPORTS =================
              Text(
                "Reports & Control",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const ReportTile(
                icon: Icons.bar_chart,
                title: "Attendance Report",
              ),
              const ReportTile(
                icon: Icons.payments,
                title: "Fee Report",
              ),
              const ReportTile(
                icon: Icons.edit_note,
                title: "Exam Management",
              ),

              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text("Notice / Circular"),
                  subtitle: const Text(
                      "School will remain closed on Friday."),
                  trailing:
                  const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
