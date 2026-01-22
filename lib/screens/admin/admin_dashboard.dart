import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/action_button.dart';
import '../../utils/dashboard_card.dart';
import '../../utils/report_title.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👋 Welcome
            Text(
              "Welcome, Admin 👋",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 📊 KPI CARDS
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                DashboardCard(
                  title: "Students",
                  value: "1,250",
                  icon: Icons.groups,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: "Teachers",
                  value: "75",
                  icon: Icons.school,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: "Attendance",
                  value: "92%",
                  icon: Icons.fact_check,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: "Pending Fees",
                  value: "₹1.2L",
                  icon: Icons.currency_rupee,
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ⚡ QUICK ACTIONS
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
              children: const [
                ActionButton(icon: Icons.person_add, label: "Add Student"),
                ActionButton(icon: Icons.person_add_alt, label: "Add Teacher"),
                ActionButton(icon: Icons.assignment, label: "Attendance"),
                ActionButton(icon: Icons.receipt_long, label: "Fee Report"),
              ],
            ),

            const SizedBox(height: 24),

            // 📈 REPORTS
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

            const SizedBox(height: 24),

            // 📢 NOTICE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.campaign),
                title: const Text("Notice / Circular"),
                subtitle:
                const Text("School will remain closed on Friday."),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
