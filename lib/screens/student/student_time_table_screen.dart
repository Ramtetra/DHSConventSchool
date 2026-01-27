import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/time_table_card.dart';

class StudentTimetableScreen extends ConsumerStatefulWidget {
  const StudentTimetableScreen({super.key});

  @override
  ConsumerState<StudentTimetableScreen> createState() =>
      _StudentTimetableScreenState();
}

class _StudentTimetableScreenState
    extends ConsumerState<StudentTimetableScreen> {

  int selectedDayIndex = 0;

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri","Sat"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Timetable"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🗓 WORKING DAY SELECTOR
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(days[index]),
                    selected: selectedDayIndex == index,
                    onSelected: (_) {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 📚 TIMETABLE LIST
          Expanded(
            child: ListView(
              children: const [
                TimeTableCard(
                  subject: "Mathematics",
                  teacher: "Mr. Sharma",
                  time: "09:00 AM - 09:45 AM",
                  color: Colors.blue,
                  isCurrent: true,
                ),
                TimeTableCard(
                  subject: "English",
                  teacher: "Ms. Neha",
                  time: "09:45 AM - 10:30 AM",
                  color: Colors.green,
                ),
                TimeTableCard(
                  subject: "Science",
                  teacher: "Dr. Verma",
                  time: "10:45 AM - 11:30 AM",
                  color: Colors.orange,
                ),
                TimeTableCard(
                  subject: "Social Studies",
                  teacher: "Mr. Singh",
                  time: "11:30 AM - 12:15 PM",
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
