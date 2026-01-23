import 'package:flutter/material.dart';

class _DayChip extends StatelessWidget {
  final String day;
  final bool selected;

  const _DayChip({required this.day, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(day),
        selected: selected,
        onSelected: (_) {},
      ),
    );
  }
}
