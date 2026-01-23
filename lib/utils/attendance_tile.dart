import 'package:flutter/material.dart';

Widget AttendanceTile(String date, String status, Color color) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(Icons.check, color: color),
      ),
      title: Text(date),
      trailing: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
