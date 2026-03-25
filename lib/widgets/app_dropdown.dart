import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final String Function(T) getLabel;
  final Function(T?) onChanged;

  final String hint;
  final bool isRequired;
  final bool isEnabled;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.getLabel,
    required this.onChanged,
    this.hint = "Select",
    this.isRequired = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            getLabel(item),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: isEnabled ? onChanged : null,
      validator: (value) {
        if (isRequired && value == null) {
          return "Please select $label";
        }
        return null;
      },
    );
  }
}