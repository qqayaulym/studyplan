import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/task_cards.dart';
import '../../data/models/task.dart';
import '../../data/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _tab = 0; // 0 - барлығы, 1 - белсенді, 2 - орындалды
  String? _subject;
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final service = TaskService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final base = _tab == 0
            ? service.all
            : (_tab == 1 ? service.active : service.done);
        var list = base
            .where((t) => _subject == null || t.subject == _subject)
            .toList();
        if (!_ascending) list = list.reversed.toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Тапсырмалар', style: AppTextStyles.h1),
                  ),
                  RoundIconButton(
                    icon: _ascending
                        ? Icons.filter_list
                        : Icons.filter_list_off,
                    tooltip: 'Сұрыптау',
                    onTap: () => setState(() => _ascending = !_ascending),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              PillTabs(
                labels: [
                  'Барлығы ${service.total}',
                  'Белсенді ${service.activeCount}',
                  'Орындалды ${service.doneCount}',
                ],
                selected: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kSubjects.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final s = kSubjects[i];
                    final selected = _subject == s;
                    return ChoiceChip(
                      label: Text(
                        s,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : p.text,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _subject = selected ? null : s),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${list.length} тапсырма',
                    style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w400, color: p.textSecondary),
                  ),
                  Text(
                    _ascending ? 'Мерзім бойынша ↑' : 'Мерзім бойынша ↓',
                    style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w400, color: p.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: list.isEmpty
                    ? const EmptyState(
                        icon: Icons.inbox_outlined,
                        message: 'Бұл санатта тапсырма жоқ',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 96),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final t = list[i];
                          return TaskCard(
                            task: t,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.taskDetail,
                                arguments: t.id),
                            onToggle: () => service.toggleDone(t.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
