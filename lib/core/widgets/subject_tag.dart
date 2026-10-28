import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Пән белгісі (Мобильді, Дерекқор, ...).
class SubjectTag extends StatelessWidget {
  final String subject;
  const SubjectTag(this.subject, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppColors.subject(subject);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: s.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        subject,
        style: AppTextStyles.label.copyWith(fontSize: 11, color: s.foreground),
      ),
    );
  }
}

/// Тапсырма күйінің белгісі (Орындалды, Кешікті, ...).
class StatusChip extends StatelessWidget {
  final TaskStatus status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (status) {
      case TaskStatus.done:
        bg = const Color(0xFFE3F1E4);
        fg = AppColors.success;
        break;
      case TaskStatus.inProgress:
        bg = const Color(0xFFFFF1CC);
        fg = const Color(0xFF8A5A00);
        break;
      case TaskStatus.overdue:
        bg = const Color(0xFFFBE3E1);
        fg = AppColors.error;
        break;
      case TaskStatus.planned:
        bg = const Color(0xFFEFEBE9);
        fg = const Color(0xFF6B5B53);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.label.copyWith(fontSize: 11, color: fg),
      ),
    );
  }
}
