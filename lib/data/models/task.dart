import '../../core/utils/app_dates.dart';

const List<String> kSubjects = [
  'Мобильді',
  'Дерекқор',
  'Тестілеу',
  'Алгоритмдер',
  'Қазақ тілі',
];

/// Еске салу нұсқалары: күн саны -> белгі.
const Map<int, String> kReminderOptions = {
  0: 'Ескертусіз',
  1: '1 күн бұрын',
  2: '2 күн бұрын',
  3: '3 күн бұрын',
  7: '1 апта бұрын',
};

enum TaskStatus { planned, inProgress, overdue, done }

extension TaskStatusLabel on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.planned:
        return 'Жоспарланған';
      case TaskStatus.inProgress:
        return 'Орындауда';
      case TaskStatus.overdue:
        return 'Кешікті';
      case TaskStatus.done:
        return 'Орындалды';
    }
  }
}

class Task {
  final String id;
  String title;
  String subject;
  DateTime dueDate;
  int reminderDays;
  String description;
  bool isFavorite;
  DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.reminderDays = 1,
    this.description = '',
    this.isFavorite = false,
    this.completedAt,
  });

  bool get isDone => completedAt != null;

  TaskStatus get status {
    if (isDone) return TaskStatus.done;
    final left = AppDates.daysFromToday(dueDate);
    if (left < 0) return TaskStatus.overdue;
    if (left <= 2) return TaskStatus.inProgress;
    return TaskStatus.planned;
  }
}
