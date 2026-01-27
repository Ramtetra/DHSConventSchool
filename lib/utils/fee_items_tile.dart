import 'package:flutter/material.dart';

class FeeItemTile extends StatelessWidget {
  final String title;
  final String amount;
  final String frequency;

  const FeeItemTile({
    super.key,
    required this.title,
    required this.amount,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(frequency),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // 👉 Edit fee
        },
      ),
    );
  }
}
