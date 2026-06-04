import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/homework_model.dart';
import '../../services/app_state.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/homework_card.dart';

class StudentHomeworkScreen extends StatelessWidget {
  const StudentHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeworks = context.watch<AppState>().homeworks;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Ödevlerim', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...homeworks.map(
            (homework) => HomeworkCard(
              homework: homework,
              onToggle: () => context.read<AppState>().toggleHomework(homework),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Ödev'),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final title = TextEditingController();
    var subject = AppConstants.subjects.first;
    var dueDate = DateTime.now().add(const Duration(days: 1));
    showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ödev ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(controller: title, label: 'Ödev açıklaması'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: subject,
                  items: AppConstants.subjects
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => subject = value!),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: dueDate,
                    );
                    if (picked != null) setState(() => dueDate = picked);
                  },
                  icon: const Icon(Icons.event),
                  label: Text('Teslim: ${dueDate.day}.${dueDate.month}.${dueDate.year}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgec')),
            FilledButton(
              onPressed: () async {
                final homework = Homework(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title.text,
                  subject: subject,
                  dueDate: dueDate,
                );
                final state = context.read<AppState>();
                await state.upsertHomework(homework);
                await state.notifications.scheduleReminder(
                  id: homework.id.hashCode,
                  title: 'Ödev hatırlatması',
                  body: homework.title,
                  dateTime: dueDate.subtract(const Duration(hours: 3)),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
