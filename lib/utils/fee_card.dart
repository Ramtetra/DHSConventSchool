import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fee_model.dart';

class FeeCard extends StatelessWidget {
  final FeeModel fee;

  const FeeCard({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(fee.status);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        isThreeLine: true, // ✅ ALLOW MORE HEIGHT
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.currency_rupee, color: color),
        ),
        title: Text(
          fee.studentName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT
          children: [
            Text('${fee.className} • ${fee.feeType}'),
            Text('Due: ${DateFormat('dd MMM yyyy').format(fee.dueDate)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT
          children: [
            Text(
              '₹${fee.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(fee.status.name.toUpperCase(),),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(fontSize: 12,color: color),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(FeeStatus status) {
    switch (status) {
      case FeeStatus.paid:
        return Colors.green;
      case FeeStatus.overdue:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
