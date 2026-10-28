import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_dates.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/task_cards.dart';
import '../../data/services/task_service.dart';
import '../../data/services/user_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeScreen({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final tasks = TaskService.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([tasks, UserService.instance]),
      builder: (context, _) {
        final upcoming = tasks.active.take(2).toList();
        final percent = (tasks.progress * 100).round();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Қайырлы күн, ${UserService.instance.firstName}',
                        style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w400,
                            color: p.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppDates.todayTitle(),
                        style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                RoundIconButton(
                  icon: Icons.notifications_none,
                  tooltip: 'Хабарландырулар',
                  onTap: () {
                    final n = tasks.overdueCount;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(n == 0
                          ? 'Кешіккен тапсырма жоқ'
                          : 'Кешіккен тапсырма саны: $n'),
                    ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            _ProgressCard(
              percent: percent,
              progress: tasks.progress,
              done: tasks.doneCount,
              total: tasks.total,
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: 'Жақын мерзімдер',
              actionLabel: 'Барлығы',
              onAction: onSeeAll,
            ),
            const SizedBox(height: 12),
            if (upcoming.isEmpty)
              const EmptyState(
                icon: Icons.celebration_outlined,
                message: 'Белсенді тапсырма жоқ. Жаңасын қосыңыз!',
              )
            else
              for (final t in upcoming) ...[
                TaskCard(
                  task: t,
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.taskDetail,
                      arguments: t.id),
                  onToggle: () => tasks.toggleDone(t.id),
                ),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 18, color: AppColors.onAccent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Әр қадам — алға басу',
                          style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onAccent),
                        ),
                        Text(
                          '${tasks.activeCount} белсенді тапсырма. Сенің қолыңнан келеді!',
                          style: AppTextStyles.label.copyWith(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B5B30)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int percent;
  final double progress;
  final int done;
  final int total;

  const _ProgressCard({
    required this.percent,
    required this.progress,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.heroCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Апталық прогресс',
                      style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text(
                      AppDates.weekRange(),
                      style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFBFA79B)),
                    ),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: AppTextStyles.h1.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF5A463F),
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$total тапсырманың $done-і орындалды',
                  style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFBFA79B)),
                ),
              ),
              const Icon(Icons.check, size: 18, color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }
}
