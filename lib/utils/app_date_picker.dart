import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDatePicker {

  static Future<String?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String format = "dd-MM-yyyy",
  }) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
    );

    if (picked != null) {
      return DateFormat(format).format(picked);
    }

    return null;
  }
}
