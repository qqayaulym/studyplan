import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_dates.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/subject_tag.dart';
import '../../data/models/task.dart';
import '../../data/services/task_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Тапсырманы жою'),
        content: Text('«${task.title}» тапсырмасын жойғыңыз келе ме?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Болдырмау'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Жою',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      TaskService.instance.delete(task.id);
      messenger.showSnackBar(const SnackBar(content: Text('Тапсырма жойылды')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final service = TaskService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final task = service.byId(taskId);
        if (task == null) {
          return const Scaffold(body: SizedBox.shrink());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Тапсырма'),
            actions: [
              IconButton(
                tooltip: 'Өңдеу',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.taskForm,
                    arguments: task.id),
              ),
              IconButton(
                tooltip: 'Таңдаулы',
                icon: Icon(
                  task.isFavorite ? Icons.star : Icons.star_border,
                  color: task.isFavorite ? AppColors.accent : p.text,
                ),
                onPressed: () => service.toggleFavorite(task.id),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StatusChip(task.status),
                      ),
                      const SizedBox(height: 12),
                      Text(task.title, style: AppTextStyles.h1),
                      const SizedBox(height: 18),
                      SurfaceCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: p.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.event,
                                      color: AppColors.primary),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Тапсыру мерзімі',
                                      style: AppTextStyles.label.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: p.textSecondary),
                                    ),
                                    Text(
                                      AppDates.full(task.dueDate),
                                      style: AppTextStyles.title
                                          .copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Пән',
                                  style: AppTextStyles.caption
                                      .copyWith(color: p.textSecondary),
                                ),
                                const Spacer(),
                                SubjectTag(task.subject),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Сипаттама',
                        style: AppTextStyles.title
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.description.isEmpty
                            ? 'Сипаттама қосылмаған.'
                            : task.description,
                        style: AppTextStyles.caption.copyWith(
                            fontSize: 15, color: p.textSecondary),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(Icons.notifications_none,
                              size: 16, color: p.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            task.reminderDays == 0
                                ? 'Еске салу өшірулі'
                                : '${kReminderOptions[task.reminderDays] ?? '${task.reminderDays} күн бұрын'} еске салу',
                            style: AppTextStyles.label.copyWith(
                                fontWeight: FontWeight.w400,
                                color: p.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    children: [
                      PrimaryButton(
                        label: task.isDone
                            ? 'Орындалмады деп белгілеу'
                            : 'Орындалды деп белгілеу',
                        leadingIcon:
                            task.isDone ? Icons.undo : Icons.check,
                        onPressed: () => service.toggleDone(task.id),
                      ),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        label: 'Жою',
                        leadingIcon: Icons.delete_outline,
                        style: AppButtonStyle.destructive,
                        onPressed: () => _confirmDelete(context, task),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
