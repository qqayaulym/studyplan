import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/utils/validators.dart';
import '../../data/services/task_service.dart';
import '../../data/services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editProfile(BuildContext context) async {
    final user = UserService.instance;
    final name = TextEditingController(text: user.name);
    final group = TextEditingController(text: user.group);
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Профильді өзгерту'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Аты-жөні',
                controller: name,
                validator: (v) => Validators.required(v, 'Аты-жөні'),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Топ',
                controller: group,
                validator: (v) => Validators.required(v, 'Топ'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Болдырмау'),
          ),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              user.update(name: name.text, group: group.text);
              Navigator.pop(ctx);
            },
            child: const Text('Сақтау'),
          ),
        ],
      ),
    );
    name.dispose();
    group.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Жүйеден шығу'),
        content: const Text('Аккаунттан шыққыңыз келе ме?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Болдырмау'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Шығу',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final tasks = TaskService.instance;
    final user = UserService.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([tasks, user]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(child: Text('Профиль', style: AppTextStyles.h1)),
                RoundIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Параметрлер',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: p.primaryLight,
                child: Text(
                  user.initials,
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(user.name,
                  style: AppTextStyles.title.copyWith(fontSize: 18)),
            ),
            Center(
              child: Text(
                user.group,
                style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w400, color: p.textSecondary),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                    child: _StatTile(
                        value: '${tasks.total}', label: 'Барлығы')),
                const SizedBox(width: 10),
                Expanded(
                    child: _StatTile(
                        value: '${tasks.doneCount}', label: 'Орындалды')),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    value: '${tasks.overdueCount}',
                    label: 'Кешікті',
                    valueColor: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Профильді өзгерту',
                    onTap: () => _editProfile(context),
                  ),
                  const Divider(),
                  _MenuItem(
                    icon: Icons.bar_chart,
                    label: 'Статистика',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.statistics),
                  ),
                  const Divider(),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Параметрлер',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  const Divider(),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Жүйеден шығу',
                    color: AppColors.error,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _StatTile({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h2
                .copyWith(color: valueColor ?? AppColors.primary),
          ),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w400, color: p.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = color ?? p.text;
    return ListTile(
      leading: Icon(icon, size: 22, color: color ?? AppColors.primary),
      title: Text(
        label,
        style: AppTextStyles.caption
            .copyWith(fontWeight: FontWeight.w600, color: c),
      ),
      trailing: Icon(Icons.chevron_right, color: p.textSecondary),
      onTap: onTap,
    );
  }
}
