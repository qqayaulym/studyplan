import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Кіші логотип + "StudyPlan" атауы (Login / Register жоғарғы жағы).
class AppLogoRow extends StatelessWidget {
  const AppLogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event_note, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          'StudyPlan',
          style: AppTextStyles.title
              .copyWith(fontWeight: FontWeight.w700, color: context.palette.text),
        ),
      ],
    );
  }
}
