import 'package:flutter/material.dart';

/// Практикалық жұмыс №2 бойынша түстер палитрасы.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF6D4C41);
  static const primaryDark = Color(0xFF4E342E);
  static const primaryLight = Color(0xFFEFEBE9);
  static const accent = Color(0xFFFFB300);
  static const background = Color(0xFFFAF6F2);
  static const text = Color(0xFF2B211C);
  static const textSecondary = Color(0xFF6B5B53);
  static const success = Color(0xFF2E7D32);
  static const error = Color(0xFFC62828);
  static const onAccent = Color(0xFF3B2A00);
  static const heroCard = Color(0xFF3B2A25);

  /// Пәндер белгілерінің түстері (фон, мәтін).
  static SubjectStyle subject(String name) {
    switch (name) {
      case 'Мобильді':
        return const SubjectStyle(Color(0xFFEFEBE9), Color(0xFF4E342E));
      case 'Дерекқор':
        return const SubjectStyle(Color(0xFFE8EDDC), Color(0xFF4F5D2F));
      case 'Тестілеу':
        return const SubjectStyle(Color(0xFFF9E3D8), Color(0xFF8A3B1E));
      case 'Қазақ тілі':
        return const SubjectStyle(Color(0xFFF6EBD0), Color(0xFF6B4E0A));
      default:
        return const SubjectStyle(Color(0xFFE3E8F0), Color(0xFF34455E));
    }
  }
}

class SubjectStyle {
  final Color background;
  final Color foreground;
  const SubjectStyle(this.background, this.foreground);
}
