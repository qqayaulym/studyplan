import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_dates.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/services/task_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _tab = 0;

  static const _ranges = [StatsRange.week, StatsRange.month, StatsRange.semester];

  String _periodText(StatsRange r) {
    switch (r) {
      case StatsRange.week:
        return '${AppDates.weekRange()}, ${DateTime.now().year}';
      case StatsRange.month:
        return 'Соңғы 4 апта';
      case StatsRange.semester:
        return 'Соңғы 5 ай';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final service = TaskService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: service,
          builder: (context, _) {
            final range = _ranges[_tab];
            final buckets = service.buckets(range);
            final sum = buckets.fold<int>(0, (a, b) => a + b.count);
            final maxCount =
                buckets.fold<int>(0, (a, b) => b.count > a ? b.count : a);
            final percent = (service.progress * 100).round();
            final subjects = service.subjectProgress();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                PillTabs(
                  labels: const ['Апта', 'Ай', 'Семестр'],
                  selected: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 16),
                SurfaceCard(
                  padding: const EdgeInsets.all(16),
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
                                  _periodText(range),
                                  style: AppTextStyles.label.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: p.textSecondary),
                                ),
                                Text('$sum тапсырма',
                                    style: AppTextStyles.h2
                                        .copyWith(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1CC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$percent%',
                              style: AppTextStyles.label.copyWith(
                                  color: const Color(0xFF8A5A00)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final b in buckets)
                              Expanded(
                                child: _Bar(
                                  label: b.label,
                                  count: b.count,
                                  maxCount: maxCount,
                                  highlight:
                                      maxCount > 0 && b.count == maxCount,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text('Пәндер бойынша үлгерім',
                    style: AppTextStyles.title
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                SurfaceCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < subjects.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Text(subjects[i].subject,
                                  style: AppTextStyles.caption),
                            ),
                            Text(
                              '${subjects[i].done}/${subjects[i].total}',
                              style: AppTextStyles.label
                                  .copyWith(color: p.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: subjects[i].total == 0
                                ? 0
                                : subjects[i].done / subjects[i].total,
                            minHeight: 6,
                            backgroundColor: p.primaryLight,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final int count;
  final int maxCount;
  final bool highlight;

  const _Bar({
    required this.label,
    required this.count,
    required this.maxCount,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const maxHeight = 90.0;
    final height = maxCount == 0 ? 4.0 : 4.0 + (maxHeight - 4) * count / maxCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: AppTextStyles.label
              .copyWith(fontSize: 11, color: p.textSecondary),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 22,
          height: height,
          decoration: BoxDecoration(
            color: highlight ? AppColors.primaryDark : AppColors.accent,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: p.textSecondary),
        ),
      ],
    );
  }
}
