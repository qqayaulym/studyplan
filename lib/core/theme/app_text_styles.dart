import 'package:flutter/material.dart';

/// Типографика жүйесі (Практикалық жұмыс №2).
/// Түс көрсетілмейді - ол Theme-ден (DefaultTextStyle) келеді.
class AppTextStyles {
  AppTextStyles._();

  static const display =
      TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 1.15);
  static const h1 =
      TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.2);
  static const h2 =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.25);
  static const title =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
  static const body =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.45);
  static const caption =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.35);
  static const label =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3);
}
