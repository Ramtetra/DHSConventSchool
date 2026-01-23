import 'package:flutter/material.dart';

class StudentAttendanceTile extends StatefulWidget {
  final String name;
  final String rollNo;

  const StudentAttendanceTile({
    super.key,
    required this.name,
    required this.rollNo,
  });

  @override
  State<StudentAttendanceTile> createState() =>
      _StudentAttendanceTileState();
}

class _StudentAttendanceTileState extends State<StudentAttendanceTile> {
  String status = "Present";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            /// Roll No
            CircleAvatar(
              radius: 22,
              child: Text(widget.rollNo),
            ),
            const SizedBox(width: 12),

            /// Name
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Status Chips
            _StatusChip("Present", Colors.green),
            const SizedBox(width: 6),
            _StatusChip("Absent", Colors.red),
            const SizedBox(width: 6),
            _StatusChip("Leave", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _StatusChip(String value, Color color) {
    final isSelected = status == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          status = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          value.substring(0, 1),
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
