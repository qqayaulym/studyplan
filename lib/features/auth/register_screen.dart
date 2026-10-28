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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    UserService.instance.update(name: _name.text, email: _email.text);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLogoRow(),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Аккаунт жасау', style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(
                  'Үлкен мақсаттар шағын жоспардан басталады.',
                  style:
                      AppTextStyles.caption.copyWith(color: p.textSecondary),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Аты-жөніңіз',
                  hint: 'Айдана',
                  icon: Icons.person_outline,
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'Аты-жөніңіз'),
                ),
                const SizedBox(height: 16),
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
                  hint: 'Кемінде 8 таңба',
                  icon: Icons.lock_outline,
                  controller: _password,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.newPassword,
                  onFieldSubmitted: (_) => _register(),
                ),
                const SizedBox(height: 6),
                Text(
                  'Кемінде 8 таңба қолданыңыз',
                  style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w400, color: p.textSecondary),
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Тіркелу', onPressed: _register),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Тіркелу арқылы қолдану шарттары мен құпиялық саясатын қабылдайсыз.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: p.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Аккаунтыңыз бар ма? ',
                        style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w400,
                            color: p.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Кіру',
                          style: AppTextStyles.label.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
