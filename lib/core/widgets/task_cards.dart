import 'package:flutter/material.dart';

import '../../data/models/task.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_dates.dart';
import 'subject_tag.dart';

RoundedRectangleBorder _cardShape(BuildContext context) =>
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: context.palette.border),
    );

/// Чекбоксы бар карточка (Home, List).
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final overdue = task.status == TaskStatus.overdue;

    return Material(
      color: p.surface,
      shape: _cardShape(context),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 14, 10),
          child: Row(
            children: [
              Checkbox(
                value: task.isDone,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 15,
                        color: task.isDone ? p.textSecondary : p.text,
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SubjectTag(task.subject),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.isDone
                                ? 'Орындалды'
                                : AppDates.dueShort(task.dueDate),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.label.copyWith(
                              fontWeight: FontWeight.w400,
                              color: task.isDone
                                  ? AppColors.success
                                  : (overdue
                                      ? AppColors.error
                                      : p.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Мәліметті карточка: атауы, пән, мерзім, күй (Search, Favorites).
class TaskInfoCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Widget trailing;

  const TaskInfoCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      shape: _cardShape(context),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: AppTextStyles.title,
                    ),
                  ),
                  trailing,
                ],
              ),
              const SizedBox(height: 2),
              Text(
                task.subject,
                style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w400, color: p.textSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.event, size: 14, color: p.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    AppDates.full(task.dueDate),
                    style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w400, color: p.textSecondary),
                  ),
                  const Spacer(),
                  StatusChip(task.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
