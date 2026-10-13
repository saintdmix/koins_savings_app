import 'package:flutter/material.dart';

IconData productIcon(String productId) {
  switch (productId) {
    case 'target':
      return Icons.track_changes;
    case 'fixed':
      return Icons.lock_clock;
    case 'education':
      return Icons.school_outlined;
    case 'vacation':
      return Icons.beach_access_outlined;
    default:
      return Icons.savings_outlined;
  }
}
