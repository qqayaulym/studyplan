import 'package:flutter/foundation.dart';

import '../../core/utils/app_dates.dart';
import '../models/task.dart';

enum StatsRange { week, month, semester }

class StatBucket {
  final String label;
  final int count;
  const StatBucket(this.label, this.count);
}

class SubjectProgress {
  final String subject;
  final int done;
  final int total;
  const SubjectProgress(this.subject, this.done, this.total);
}

/// Тапсырмалар қоймасы (жадта). Өзгерген сайын экрандар автоматты жаңарады.
class TaskService extends ChangeNotifier {
  TaskService._() {
    _seed();
  }

  static final TaskService instance = TaskService._();

  final List<Task> _tasks = [];
  final List<String> _recentSearches = ['SQL сұраныстары', 'Практикалық жұмыс'];
  int _nextId = 1;

  DateTime _inDays(int n) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + n);
  }

  DateTime _ago(int days) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - days, 12);
  }

  void _seed() {
    void add(String title, String subject, int due,
        {bool done = false,
        int doneAgo = 0,
        bool fav = false,
        String desc = ''}) {
      _tasks.add(Task(
        id: 't${_nextId++}',
        title: title,
        subject: subject,
        dueDate: _inDays(due),
        description: desc,
        isFavorite: fav,
        completedAt: done ? _ago(doneAgo) : null,
      ));
    }

    add('Қосымша макетін жасау', 'Мобильді', 2,
        desc: 'Figma-да негізгі экрандардың макетін дайындау.');
    add('SQL сұраныстарын жазу', 'Дерекқор', 3,
        desc: 'SELECT, JOIN және GROUP BY бойынша жаттығулар.');
    add('Тест жоспарын дайындау', 'Тестілеу', 4);
    add('Навигацияны құрастыру', 'Мобильді', 5);
    add('Кестелер байланысын құру', 'Дерекқор', 6);
    add('Жоба құрылымын құру', 'Мобильді', 1, done: true, doneAgo: 0);
    add('Тест түрлерін оқу', 'Тестілеу', -1, done: true, doneAgo: 1);
    add('Деректер моделін құру', 'Дерекқор', -2, done: true, doneAgo: 2);
    add('Flutter практикалық жұмысы №1', 'Мобильді', 0,
        fav: true,
        desc: 'Flutter ортасын баптап, алғашқы мобильді қосымшаны жасаңыз. '
            'Басты экранға өз атыңызды, тобыңызды және сәлемдесу мәтінін қосыңыз.');
    add('Flutter: виджеттермен жұмыс', 'Мобильді', 2,
        desc: 'Row, Column, Stack және ListView виджеттерін қолдану.');
    add('SQL: кестелерді байланыстыру', 'Дерекқор', -2, fav: true);
    add('Алгоритмдерді талдау', 'Алгоритмдер', 3, fav: true);
  }

  // ---------- оқу ----------

  List<Task> get all {
    final list = List<Task>.of(_tasks);
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  List<Task> get active => all.where((t) => !t.isDone).toList();
  List<Task> get done => all.where((t) => t.isDone).toList();
  List<Task> get favorites => all.where((t) => t.isFavorite).toList();

  int get total => _tasks.length;
  int get doneCount => _tasks.where((t) => t.isDone).length;
  int get activeCount => total - doneCount;
  int get overdueCount =>
      _tasks.where((t) => t.status == TaskStatus.overdue).length;

  double get progress => total == 0 ? 0 : doneCount / total;

  Task? byId(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  List<Task> search(String query, {String? subject}) {
    final q = query.trim().toLowerCase();
    return all.where((t) {
      final okText = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          t.subject.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q);
      final okSubject = subject == null || t.subject == subject;
      return okText && okSubject;
    }).toList();
  }

  // ---------- жазу ----------

  Task create({
    required String title,
    required String subject,
    required DateTime dueDate,
    required int reminderDays,
    required String description,
    required bool isFavorite,
  }) {
    final task = Task(
      id: 't${_nextId++}',
      title: title.trim(),
      subject: subject,
      dueDate: dueDate,
      reminderDays: reminderDays,
      description: description.trim(),
      isFavorite: isFavorite,
    );
    _tasks.add(task);
    notifyListeners();
    return task;
  }

  void update(
    String id, {
    required String title,
    required String subject,
    required DateTime dueDate,
    required int reminderDays,
    required String description,
    required bool isFavorite,
  }) {
    final t = byId(id);
    if (t == null) return;
    t.title = title.trim();
    t.subject = subject;
    t.dueDate = dueDate;
    t.reminderDays = reminderDays;
    t.description = description.trim();
    t.isFavorite = isFavorite;
    notifyListeners();
  }

  void delete(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleDone(String id) {
    final t = byId(id);
    if (t == null) return;
    t.completedAt = t.isDone ? null : DateTime.now();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final t = byId(id);
    if (t == null) return;
    t.isFavorite = !t.isFavorite;
    notifyListeners();
  }

  void addRecentSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _recentSearches.removeWhere((s) => s.toLowerCase() == q.toLowerCase());
    _recentSearches.insert(0, q);
    if (_recentSearches.length > 5) _recentSearches.removeLast();
    notifyListeners();
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    notifyListeners();
  }

  // ---------- статистика ----------

  List<StatBucket> buckets(StatsRange range) {
    final doneTasks = _tasks.where((t) => t.completedAt != null).toList();
    final now = DateTime.now();

    switch (range) {
      case StatsRange.week:
        final start = AppDates.weekStart();
        return List.generate(7, (i) {
          final day = DateTime(start.year, start.month, start.day + i);
          final c = doneTasks
              .where((t) => AppDates.sameDay(t.completedAt!, day))
              .length;
          return StatBucket(AppDates.weekdaysShort[i], c);
        });
      case StatsRange.month:
        return List.generate(4, (k) {
          final endAgo = (3 - k) * 7;
          final c = doneTasks.where((t) {
            final d = AppDates.daysFromToday(t.completedAt!);
            return d <= -endAgo && d >= -(endAgo + 6);
          }).length;
          return StatBucket('${k + 1}-ап', c);
        });
      case StatsRange.semester:
        return List.generate(5, (k) {
          final m = DateTime(now.year, now.month - (4 - k), 1);
          final c = doneTasks
              .where((t) =>
                  t.completedAt!.year == m.year &&
                  t.completedAt!.month == m.month)
              .length;
          return StatBucket(AppDates.monthsShort[m.month - 1], c);
        });
    }
  }

  List<SubjectProgress> subjectProgress() {
    final result = <SubjectProgress>[];
    for (final s in kSubjects) {
      final list = _tasks.where((t) => t.subject == s).toList();
      if (list.isEmpty) continue;
      result.add(SubjectProgress(s, list.where((t) => t.isDone).length, list.length));
    }
    return result;
  }
}
