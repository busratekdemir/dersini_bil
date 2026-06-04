import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1E3A8A);
  static const accent = Color(0xFF14B8A6);
  static const surface = Color(0xFFF8FAFC);
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const teacher = Color(0xFF7C3AED);

  static Color subject(String subject) {
    switch (subject) {
      case 'Matematik':
        return const Color(0xFF2563EB);
      case 'Türkçe':
        return const Color(0xFF0891B2);
      case 'Fen Bilimleri':
        return const Color(0xFF16A34A);
      case 'Sosyal Bilgiler':
        return const Color(0xFFEAB308);
      case 'İngilizce':
        return const Color(0xFFEF4444);
      default:
        return primary;
    }
  }
}
