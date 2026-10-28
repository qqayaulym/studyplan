import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF7D5C50),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF9A7B6F)),
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 48, color: Colors.white),
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'StudyPlan',
              style: AppTextStyles.display.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Оқуыңды ретте. Мақсатыңа жет.',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.primaryLight),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 2400),
                curve: Curves.easeInOut,
                builder: (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 4,
                    backgroundColor: const Color(0xFF8A6A5D),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Жоспарың дайындалуда...',
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
