import 'package:flutter/material.dart';

/// Жарық / қараңғы тақырыпқа тәуелді түстер.
/// `context.palette` арқылы алынады.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface;
  final Color text;
  final Color textSecondary;
  final Color border;
  final Color primaryLight;
  final Color navIndicator;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.border,
    required this.primaryLight,
    required this.navIndicator,
  });

  static const light = AppPalette(
    background: Color(0xFFFAF6F2),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF2B211C),
    textSecondary: Color(0xFF6B5B53),
    border: Color(0xFFEADFD8),
    primaryLight: Color(0xFFEFEBE9),
    navIndicator: Color(0xFFFFE9B0),
  );

  static const dark = AppPalette(
    background: Color(0xFF1E1815),
    surface: Color(0xFF2A221E),
    text: Color(0xFFF5EDE8),
    textSecondary: Color(0xFFB8A99F),
    border: Color(0xFF3E332D),
    primaryLight: Color(0xFF3A2E29),
    navIndicator: Color(0xFF5A4520),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? text,
    Color? textSecondary,
    Color? border,
    Color? primaryLight,
    Color? navIndicator,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      primaryLight: primaryLight ?? this.primaryLight,
      navIndicator: navIndicator ?? this.navIndicator,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      navIndicator: Color.lerp(navIndicator, other.navIndicator, t)!,
    );
  }
}

extension PaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
