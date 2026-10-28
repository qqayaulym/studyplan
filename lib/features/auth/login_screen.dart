import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    UserService.instance.update(email: _email.text);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);
  }

  void _forgot() {
    final error = Validators.email(_email.text);
    if (error != null) {
      _formKey.currentState!.validate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Алдымен email-ді дұрыс енгізіңіз')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Қалпына келтіру сілтемесі ${_email.text.trim()} поштасына жіберілді')),
    );
  }

  void _google() {
    // Демо: нақты Google OAuth қосылмаған, тікелей кіреміз.
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const AppLogoRow(),
                      const SizedBox(height: 40),
                      Text('Қайта қош келдіңіз!', style: AppTextStyles.h1),
                      const SizedBox(height: 6),
                      Text(
                        'Бүгінгі жоспарың сені күтіп тұр.',
                        style: AppTextStyles.caption
                            .copyWith(color: p.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        label: 'Электронды пошта',
                        hint: 'aidana@mail.kz',
                        icon: Icons.mail_outline,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Құпиясөз',
                        hint: 'Құпиясөзді енгізіңіз',
                        icon: Icons.lock_outline,
                        controller: _password,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.password,
                        onFieldSubmitted: (_) => _login(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgot,
                          child: Text(
                            'Құпиясөзді ұмыттыңыз ба?',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      PrimaryButton(label: 'Кіру', onPressed: _login),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'немесе',
                              style: AppTextStyles.label.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: p.textSecondary),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Google арқылы кіру',
                        leadingIcon: Icons.g_mobiledata,
                        style: AppButtonStyle.outlined,
                        onPressed: _google,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Аккаунтыңыз жоқ па? ',
                                style: AppTextStyles.label.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: p.textSecondary),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.register),
                                child: Text(
                                  'Тіркелу',
                                  style: AppTextStyles.label.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
