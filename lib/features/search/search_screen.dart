import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/task_cards.dart';
import '../../data/models/task.dart';
import '../../data/services/task_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String? _subject;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final service = TaskService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final hasQuery = _controller.text.trim().isNotEmpty || _subject != null;
        final results =
            hasQuery ? service.search(_controller.text, subject: _subject) : <Task>[];
        final recents = service.recentSearches;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text('Іздеу', style: AppTextStyles.h1),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
              onSubmitted: (v) => service.addRecentSearch(v),
              style: AppTextStyles.caption.copyWith(color: p.text),
              decoration: InputDecoration(
                hintText: 'Тапсырма іздеу...',
                prefixIcon:
                    Icon(Icons.search, size: 20, color: p.textSecondary),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => setState(_controller.clear),
                      ),
              ),
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
                    avatar: selected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
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
            if (hasQuery) ...[
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Нәтижелер',
                      style: AppTextStyles.title
                          .copyWith(fontWeight: FontWeight.w700)),
                  Text('${results.length} тапсырма',
                      style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w400,
                          color: p.textSecondary)),
                ],
              ),
              const SizedBox(height: 10),
              if (results.isEmpty)
                const EmptyState(
                  icon: Icons.search_off,
                  message: 'Ештеңе табылмады. Басқа сөзбен іздеп көріңіз.',
                )
              else
                for (final t in results) ...[
                  TaskInfoCard(
                    task: t,
                    trailing: Icon(Icons.chevron_right, color: p.textSecondary),
                    onTap: () {
                      service.addRecentSearch(_controller.text);
                      Navigator.pushNamed(context, AppRoutes.taskDetail,
                          arguments: t.id);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
            ],
            if (recents.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text('Соңғы іздеулер',
                  style: AppTextStyles.title
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              for (final r in recents)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading:
                      Icon(Icons.history, size: 20, color: p.textSecondary),
                  title: Text(r, style: AppTextStyles.caption),
                  trailing: IconButton(
                    icon: Icon(Icons.close, size: 18, color: p.textSecondary),
                    onPressed: () => service.removeRecentSearch(r),
                  ),
                  onTap: () => setState(() => _controller.text = r),
                ),
            ],
          ],
        );
      },
    );
  }
}
