import 'package:flutter/material.dart';

class ClassTile extends StatelessWidget {
  final String className;

  const ClassTile({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.class_),
        title: Text(className),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
