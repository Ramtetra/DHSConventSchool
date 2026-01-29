import 'package:flutter/material.dart';

import '../models/student_model.dart';

extension PerformanceX on PerformanceLevel {
  String get label {
    switch (this) {
      case PerformanceLevel.good:
        return 'Good';
      case PerformanceLevel.average:
        return 'Average';
      case PerformanceLevel.weak:
        return 'Weak';
    }
  }

  Color get color {
    switch (this) {
      case PerformanceLevel.good:
        return Colors.green;
      case PerformanceLevel.average:
        return Colors.orange;
      case PerformanceLevel.weak:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case PerformanceLevel.good:
        return Icons.trending_up;
      case PerformanceLevel.average:
        return Icons.trending_flat;
      case PerformanceLevel.weak:
        return Icons.trending_down;
    }
  }
}
