import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/primary_button.dart';

class _OnboardingPage {
  final IconData icon;
  final IconData badge;
  final String title;
  final String text;
  const _OnboardingPage(this.icon, this.badge, this.title, this.text);
}

const _pages = [
  _OnboardingPage(
    Icons.calendar_month_outlined,
    Icons.check,
    'Барлық тапсырма — бір жерде',
    'Сабақтарыңды жоспарла, мерзімдерді бақыла және маңыздысына көңіл бөл.',
  ),
  _OnboardingPage(
    Icons.notifications_active_outlined,
    Icons.schedule,
    'Мерзімді жіберіп алма',
    'Еске салғыштар тапсыру күнінен бұрын хабарлап тұрады.',
  ),
  _OnboardingPage(
    Icons.insights_outlined,
    Icons.trending_up,
    'Прогресті бақыла',
    'Статистика арқылы әр пән бойынша орындалған жұмысты көр.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogoRow(),
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Өткізіп жіберу',
                      style: AppTextStyles.caption
                          .copyWith(color: p.textSecondary),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _PageContent(page: _pages[i]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _index ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _index ? AppColors.primary : p.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: isLast ? 'Бастау' : 'Келесі',
                trailingIcon: Icons.arrow_forward,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Кішкентай экранда иллюстрацияны кішірейту.
        final size = constraints.maxHeight < 480 ? 150.0 : 230.0;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: size + 40,
                    height: size,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: size,
                          height: size,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF3D0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon,
                              size: size * 0.45, color: AppColors.primary),
                        ),
                        Positioned(
                          right: 0,
                          bottom: size * 0.12,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: p.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: p.border),
                            ),
                            child: Icon(page.badge,
                                color: AppColors.accent, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(page.title, style: AppTextStyles.h1.copyWith(fontSize: 26)),
                const SizedBox(height: 10),
                Text(
                  page.text,
                  style: AppTextStyles.caption.copyWith(color: p.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
