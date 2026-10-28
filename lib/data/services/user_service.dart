import 'package:flutter/foundation.dart';

/// Ағымдағы пайдаланушы (демо, жадта).
class UserService extends ChangeNotifier {
  UserService._();
  static final UserService instance = UserService._();

  String _name = 'Айдана Сәрсенбаева';
  String _group = 'БҚ 2309';
  String _email = 'aidana@mail.kz';

  String get name => _name;
  String get group => _group;
  String get email => _email;

  String get firstName => _name.trim().split(RegExp(r'\s+')).first;

  String get initials {
    final parts =
        _name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.substring(0, 1);
    final second = parts.length > 1 ? parts[1].substring(0, 1) : '';
    return (first + second).toUpperCase();
  }

  void update({String? name, String? group, String? email}) {
    if (name != null && name.trim().isNotEmpty) _name = name.trim();
    if (group != null && group.trim().isNotEmpty) _group = group.trim();
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    notifyListeners();
  }
}
