import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/task_cards.dart';
import '../../data/services/task_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final service = TaskService.instance;

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final favs = service.favorites;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('Таңдаулылар', style: AppTextStyles.h1),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF2DC9B)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Маңыздысы — әрдайым қолда',
                          style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onAccent),
                        ),
                        Text(
                          '${favs.length} таңдаулы тапсырма',
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
            const SizedBox(height: 14),
            if (favs.isEmpty)
              const EmptyState(
                icon: Icons.star_border,
                message: 'Таңдаулы тапсырма жоқ.\nТапсырма ішінде жұлдызшаны басыңыз.',
              )
            else
              for (final t in favs) ...[
                TaskInfoCard(
                  task: t,
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.taskDetail,
                      arguments: t.id),
                  trailing: GestureDetector(
                    onTap: () => service.toggleFavorite(t.id),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.star, color: AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            if (favs.isNotEmpty)
              Text(
                'Сақтау үшін тапсырмадағы жұлдызшаны басыңыз.',
                style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w400, color: p.textSecondary),
              ),
          ],
        );
      },
    );
  }
}
