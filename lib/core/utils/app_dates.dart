/// Күнді қазақша форматтау көмекшілері.
class AppDates {
  AppDates._();

  static const months = [
    'қаңтар',
    'ақпан',
    'наурыз',
    'сәуір',
    'мамыр',
    'маусым',
    'шілде',
    'тамыз',
    'қыркүйек',
    'қазан',
    'қараша',
    'желтоқсан',
  ];

  static const monthsShort = [
    'қаң',
    'ақп',
    'нау',
    'сәу',
    'мам',
    'мау',
    'шіл',
    'там',
    'қыр',
    'қаз',
    'қар',
    'жел',
  ];

  static const weekdaysShort = ['Дс', 'Сс', 'Ср', 'Бс', 'Жм', 'Сб', 'Жс'];

  static String _two(int n) => n.toString().padLeft(2, '0');

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 21.10.2026
  static String full(DateTime d) => '${_two(d.day)}.${_two(d.month)}.${d.year}';

  /// 21.10
  static String dayMonth(DateTime d) => '${_two(d.day)}.${_two(d.month)}';

  /// Бүгінгі күннен айырма (күн санымен). DST әсер етпейді.
  static int daysFromToday(DateTime d) {
    final now = DateTime.now();
    final a = DateTime.utc(d.year, d.month, d.day);
    final b = DateTime.utc(now.year, now.month, now.day);
    return a.difference(b).inDays;
  }

  static String relative(DateTime d) {
    final n = daysFromToday(d);
    if (n == 0) return 'бүгін';
    if (n > 0) return '$n күннен кейін';
    return '${-n} күн кешікті';
  }

  /// 21.10 · 2 күннен кейін
  static String dueShort(DateTime d) => '${dayMonth(d)} · ${relative(d)}';

  /// Бүгін — 19 қазан
  static String todayTitle() {
    final now = DateTime.now();
    return 'Бүгін — ${now.day} ${months[now.month - 1]}';
  }

  /// Ағымдағы аптаның дүйсенбісі.
  static DateTime weekStart() {
    final now = dateOnly(DateTime.now());
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  /// 19–25 қазан немесе 28 қаз – 3 қар
  static String weekRange() {
    final s = weekStart();
    final e = DateTime(s.year, s.month, s.day + 6);
    if (s.month == e.month) {
      return '${s.day}–${e.day} ${months[e.month - 1]}';
    }
    return '${s.day} ${monthsShort[s.month - 1]} – ${e.day} ${monthsShort[e.month - 1]}';
  }
}
