import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final settings = SettingsService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Параметрлер')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _SectionLabel('Жалпы'),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(Icons.dark_mode_outlined,
                            color: p.textSecondary),
                        title: Text('Қараңғы тақырып',
                            style: AppTextStyles.caption
                                .copyWith(fontWeight: FontWeight.w600)),
                        value: settings.darkMode,
                        onChanged: settings.setDarkMode,
                      ),
                      const Divider(),
                      SwitchListTile(
                        secondary: Icon(Icons.notifications_none,
                            color: p.textSecondary),
                        title: Text('Хабарландырулар',
                            style: AppTextStyles.caption
                                .copyWith(fontWeight: FontWeight.w600)),
                        value: settings.notifications,
                        onChanged: settings.setNotifications,
                      ),
                      const Divider(),
                      ListTile(
                        leading:
                            Icon(Icons.language, color: p.textSecondary),
                        title: Text('Тіл',
                            style: AppTextStyles.caption
                                .copyWith(fontWeight: FontWeight.w600)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Қазақша',
                                style: AppTextStyles.label.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: p.textSecondary)),
                            Icon(Icons.chevron_right,
                                color: p.textSecondary),
                          ],
                        ),
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Тіл'),
                            content: const Text(
                                'Қазіргі нұсқада тек қазақ тілі қолжетімді.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Жақсы'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: p.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_none,
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Мерзімді өткізіп алмаңыз',
                              style: AppTextStyles.caption
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              settings.notifications
                                  ? 'Хабарландырулар тапсырмаларды уақытында орындауға көмектеседі.'
                                  : 'Хабарландырулар өшірулі. Қосып қойған жөн.',
                              style: AppTextStyles.label.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: p.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _SectionLabel('Ақпарат'),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: p.textSecondary),
                    title: Text('Қолданба туралы',
                        style: AppTextStyles.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                    trailing:
                        Icon(Icons.chevron_right, color: p.textSecondary),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'StudyPlan',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          'Оқу тапсырмаларын жоспарлауға арналған қосымша.',
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: Text('StudyPlan',
                      style: AppTextStyles.title
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
                Center(
                  child: Text(
                    '1.0.0 нұсқасы',
                    style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w400, color: p.textSecondary),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w500,
            color: context.palette.textSecondary),
      ),
    );
  }
}
