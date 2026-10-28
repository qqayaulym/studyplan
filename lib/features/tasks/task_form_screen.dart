import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_dates.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/task.dart';
import '../../data/services/task_service.dart';

/// Create / Edit формасы. taskId == null -> жаңа тапсырма.
class TaskFormScreen extends StatefulWidget {
  final String? taskId;
  const TaskFormScreen({super.key, this.taskId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();

  String? _subject;
  DateTime? _dueDate;
  int _reminder = 1;
  bool _favorite = false;

  Task? _editing;

  bool get _isEdit => _editing != null;

  @override
  void initState() {
    super.initState();
    final id = widget.taskId;
    if (id != null) {
      _editing = TaskService.instance.byId(id);
    }
    final t = _editing;
    if (t != null) {
      _title.text = t.title;
      _description.text = t.description;
      _subject = t.subject;
      _dueDate = t.dueDate;
      _date.text = AppDates.full(t.dueDate);
      _reminder = t.reminderDays;
      _favorite = t.isFavorite;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _date.text = AppDates.full(picked);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final service = TaskService.instance;
    final messenger = ScaffoldMessenger.of(context);

    if (_isEdit) {
      service.update(
        _editing!.id,
        title: _title.text,
        subject: _subject!,
        dueDate: _dueDate!,
        reminderDays: _reminder,
        description: _description.text,
        isFavorite: _favorite,
      );
    } else {
      service.create(
        title: _title.text,
        subject: _subject!,
        dueDate: _dueDate!,
        reminderDays: _reminder,
        description: _description.text,
        isFavorite: _favorite,
      );
    }
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(
      content: Text(_isEdit ? 'Өзгерістер сақталды' : 'Тапсырма қосылды'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Тапсырманы өңдеу' : 'Жаңа тапсырма'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'Атауы',
                        hint: 'Тапсырманың атауын енгізіңіз',
                        controller: _title,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.required(v, 'Атауы'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Пән',
                        style: AppTextStyles.label.copyWith(
                            fontSize: 13, color: p.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _subject,
                        isExpanded: true,
                        hint: const Text('Пәнді таңдаңыз'),
                        items: [
                          for (final s in kSubjects)
                            DropdownMenuItem(value: s, child: Text(s)),
                        ],
                        onChanged: (v) => setState(() => _subject = v),
                        validator: (v) =>
                            v == null ? 'Пәнді таңдаңыз' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Тапсыру күні',
                        hint: 'Күнді таңдаңыз',
                        controller: _date,
                        readOnly: true,
                        icon: Icons.event,
                        onTap: _pickDate,
                        validator: (v) =>
                            Validators.required(v, 'Тапсыру күні'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Еске салу',
                        style: AppTextStyles.label.copyWith(
                            fontSize: 13, color: p.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        value: _reminder,
                        isExpanded: true,
                        items: [
                          for (final e in kReminderOptions.entries)
                            DropdownMenuItem(
                                value: e.key, child: Text(e.value)),
                        ],
                        onChanged: (v) => setState(() => _reminder = v ?? 0),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Сипаттама',
                        hint: 'Тапсырма туралы толығырақ жазыңыз...',
                        controller: _description,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Таңдаулыға қосу',
                                style: AppTextStyles.caption
                                    .copyWith(color: p.text)),
                          ),
                          Switch(
                            value: _favorite,
                            onChanged: (v) => setState(() => _favorite = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(label: 'Сақтау', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
