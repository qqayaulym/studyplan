import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

enum AppButtonStyle { filled, outlined, destructive }

/// Қайта қолданылатын батырма: толтырылған / контурлы / қауіпті әрекет.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppButtonStyle style;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.style = AppButtonStyle.filled,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final Color bg;
    final Color fg;
    BorderSide? side;

    switch (style) {
      case AppButtonStyle.filled:
        bg = AppColors.primary;
        fg = Colors.white;
        break;
      case AppButtonStyle.outlined:
        bg = p.surface;
        fg = p.text;
        side = BorderSide(color: p.border);
        break;
      case AppButtonStyle.destructive:
        bg = p.surface;
        fg = AppColors.error;
        side = const BorderSide(color: AppColors.error);
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: side ?? BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title.copyWith(color: fg),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
