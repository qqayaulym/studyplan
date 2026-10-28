# StudyPlan — Практикалық жұмыс №3 (Flutter)

Figma макеті (Практикалық жұмыс №2) бойынша жасалған Flutter қосымшасы.

## Іске қосу
```bash
cd studyplan
flutter create . --org kz.studyplan --project-name studyplan   # android/ios папкаларын жасайды (lib/ мен pubspec.yaml-ды өзгертпейді)
flutter pub get
flutter run
```
Сыртқы пакеттер жоқ — тек Flutter SDK (Material 3).

## Құрылымы (feature-based)
```
lib/
  main.dart, app.dart            # кіру нүктесі, MaterialApp, тақырып, маршруттар
  core/
    theme/                       # AppColors, AppTextStyles, AppPalette (жарық/қараңғы), AppTheme
    routes/app_routes.dart       # барлық маршруттар
    utils/                       # validators, app_dates
    widgets/                     # reusable: PrimaryButton, AppTextField, TaskCard, SubjectTag, PillTabs ...
  data/
    models/task.dart             # Task, TaskStatus
    services/                    # TaskService, UserService, SettingsService (ChangeNotifier)
  features/
    splash/ onboarding/ auth/ (login, register)
    shell/ (Bottom NavigationBar)  home/ tasks/ (list, detail, form)
    search/ favorites/ profile/ (profile, settings, statistics)
```

## Навигация
Splash → Onboarding → Login ⇄ Register → Main (Басты · Тапсырмалар · Іздеу · Таңдаулы · Профиль)
Тапсырма карточкасы → Detail → Edit; «+» → Create; Профиль → Статистика / Параметрлер / Шығу.

## Валидация
Email форматы, бос құпиясөз, тіркелуде құпиясөз ≥ 8 таңба, аты-жөні, тапсырма атауы/пәні/күні — міндетті өрістер (түсінікті қате хабарламаларымен).

## Бейімделу
Мазмұн ≤ 520 px енде ортаға орналасады, экрандар scroll/LayoutBuilder қолданады, mәтін өлшемі `AppTextStyles` бойынша (36/28/22/16/14/12).

## Ескерту
Деректер жадта сақталады (қолданба жабылғанда бастапқы күйге оралады). Google арқылы кіру — демо.
