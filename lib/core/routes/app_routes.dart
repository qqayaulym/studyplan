import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile/statistics_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tasks/task_detail_screen.dart';
import '../../features/tasks/task_form_screen.dart';

/// Барлық маршруттар бір жерде.
///
/// Splash -> Onboarding -> Login <-> Register -> Main (Home/List/Search/Favorites/Profile)
/// List/Home -> Detail -> Edit;  Home/List "+" -> Create;  Profile -> Statistics / Settings
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const taskDetail = '/task';
  static const taskForm = '/task/form';
  static const statistics = '/statistics';
  static const settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    final Widget page;
    switch (s.name) {
      case onboarding:
        page = const OnboardingScreen();
        break;
      case login:
        page = const LoginScreen();
        break;
      case register:
        page = const RegisterScreen();
        break;
      case main:
        page = const MainShell();
        break;
      case taskDetail:
        page = TaskDetailScreen(taskId: s.arguments as String);
        break;
      case taskForm:
        // arguments: null -> жаңа тапсырма, String -> өңдеу
        page = TaskFormScreen(taskId: s.arguments as String?);
        break;
      case statistics:
        page = const StatisticsScreen();
        break;
      case settings:
        page = const SettingsScreen();
        break;
      case splash:
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute<dynamic>(builder: (_) => page, settings: s);
  }
}
