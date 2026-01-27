import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/student_attendance_tile.dart';
import '../../utils/summary_card.dart';

class AdminAttendanceScreen extends ConsumerStatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  ConsumerState<AdminAttendanceScreen> createState() =>
      _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState
    extends ConsumerState<AdminAttendanceScreen> {
  String selectedClass = "Class 8 A";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),

      // ✅ FIXED ACTION BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("SAVE ATTENDANCE"),
              onPressed: _onSaveAttendance,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔍 FILTER CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedClass,
                      decoration: const InputDecoration(
                        labelText: "Select Class",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "Class 8 A", child: Text("Class 8 A")),
                        DropdownMenuItem(
                            value: "Class 9 B", child: Text("Class 9 B")),
                        DropdownMenuItem(
                            value: "Class 10 C", child: Text("Class 10 C")),
                      ],
                      onChanged: (value) {
                        setState(() => selectedClass = value!);
                      },
                    ),

                    const SizedBox(height: 12),

                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Attendance Date",
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📊 SUMMARY
            Row(
              children: const [
                SummaryCard(
                  title: "Present",
                  value: "24",
                  color: Colors.green,
                ),
                SummaryCard(
                  title: "Absent",
                  value: "4",
                  color: Colors.red,
                ),
                SummaryCard(
                  title: "Total",
                  value: "28",
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 👨‍🎓 STUDENT LIST
            Text(
              "Students",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            StudentAttendanceTile(name: "Rahul Sharma", roll: "01"),
            StudentAttendanceTile(name: "Anita Verma", roll: "02"),
            StudentAttendanceTile(name: "Rohit Singh", roll: "03"),
            StudentAttendanceTile(name: "Neha Gupta", roll: "04"),
          ],
        ),
      ),
    );
  }

  // 📅 DATE PICKER
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // 💾 SAVE HANDLER
  void _onSaveAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance Saved Successfully")),
    );

    // 👉 Later:
    // ref.read(attendanceProvider.notifier).submit();
  }
}
