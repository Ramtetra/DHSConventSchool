import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/attendance_model.dart';
import '../../providers/attendance_provider.dart';
import '../../utils/attendance_color.dart';

class StudentAttendanceScreen extends ConsumerStatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  ConsumerState<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState
    extends ConsumerState<StudentAttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(attendanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Attendance"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 📅 Calendar
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,

              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },

              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final status = notifier.getStatus(date);
                  if (status == null) return const SizedBox();

                  return Positioned(
                    bottom: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: attendanceColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// 📄 Selected Day Details
          Expanded(
            child: _selectedDay == null
                ? const Center(
              child: Text(
                "Select a date to view attendance",
                style: TextStyle(fontSize: 16),
              ),
            )
                : _attendanceDetailCard(_selectedDay!, notifier),
          ),
        ],
      ),
    );
  }

  Widget _attendanceDetailCard(
      DateTime day,
      AttendanceNotifier notifier,
      ) {
    final status = notifier.getStatus(day);

    return Padding(
     // padding: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat("dd MMM yyyy").format(day),
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// Status Chip
              Chip(
                label: Text(
                  status == null
                      ? "NO RECORD"
                      : status.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: status == null
                    ? Colors.grey
                    : attendanceColor(status),
              ),

              const SizedBox(height: 24),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionBtn(
                    "Present",
                    Colors.green,
                        () => notifier.markAttendance(
                        day, AttendanceStatus.present),
                  ),
                  _actionBtn(
                    "Absent",
                    Colors.red,
                        () => notifier.markAttendance(
                        day, AttendanceStatus.absent),
                  ),
                  _actionBtn(
                    "Holiday",
                    Colors.orange,
                        () => notifier.markAttendance(
                        day, AttendanceStatus.holiday),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(
      String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
