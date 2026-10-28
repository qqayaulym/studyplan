/// Форма өрістерін тексеру (validation).
class Validators {
  Validators._();

  static final _emailRegExp = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');

  static String? required(String? value, [String field = 'Өріс']) {
    if (value == null || value.trim().isEmpty) {
      return '$field міндетті түрде толтырылуы керек';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email енгізіңіз';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'Email форматын тексеріңіз';
    }
    return null;
  }

  /// Кіру кезінде: бос болмауы керек.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Құпиясөзді енгізіңіз';
    }
    return null;
  }

  /// Тіркелу кезінде: кемінде 8 таңба.
  static String? newPassword(String? value) {
    final empty = password(value);
    if (empty != null) return empty;
    if (value!.length < 8) {
      return 'Құпиясөз кемінде 8 таңбадан тұруы керек';
    }
    return null;
  }
}
