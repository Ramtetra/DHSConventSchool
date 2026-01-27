import 'package:flutter/material.dart';

class StudentAttendanceTile extends StatefulWidget {
  final String name;
  final String roll;

  const StudentAttendanceTile({
    required this.name,
    required this.roll,
  });

  @override
  State<StudentAttendanceTile> createState() =>
      StudentAttendanceTileState();
}

class StudentAttendanceTileState extends State<StudentAttendanceTile> {
  bool isPresent = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(widget.roll),
        ),
        title: Text(widget.name),
        trailing: Switch(
          value: isPresent,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          onChanged: (value) {
            setState(() => isPresent = value);
          },
        ),
      ),
    );
  }
}
