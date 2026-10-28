import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_palette.dart';
import 'core/theme/app_theme.dart';
import 'data/services/settings_service.dart';

class StudyPlanApp extends StatelessWidget {
  const StudyPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'StudyPlan',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: SettingsService.instance.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          // Планшет / кең экран: мазмұнды телефон енінде ортаға орналастыру.
          builder: (context, child) {
            final p = context.palette;
            return ColoredBox(
              color: p.border,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ClipRect(child: child ?? const SizedBox.shrink()),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
