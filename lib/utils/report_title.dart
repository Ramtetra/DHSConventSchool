import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ReportTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
