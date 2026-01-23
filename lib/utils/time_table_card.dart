import 'package:flutter/material.dart';

class TimeTableCard extends StatelessWidget {
  final String subject;
  final String time;
  final String teacher;
  final Color color;
  final bool isCurrent;

  const TimeTableCard({
    super.key,
    required this.subject,
    required this.time,
    required this.teacher,
    required this.color,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
        border: isCurrent
            ? Border.all(color: color, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(teacher,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(time,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("NOW",
                  style: TextStyle(color: color, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
