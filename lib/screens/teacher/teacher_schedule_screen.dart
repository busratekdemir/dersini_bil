import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/schedule_model.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_text_field.dart';

class TeacherScheduleScreen extends StatelessWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<AppState>().schedules;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Ders Programı', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...schedules.map(
            (schedule) => Card(
              child: ListTile(
                leading: const Icon(Icons.event_available),
                title: Text(schedule.title),
                subtitle: Text('${schedule.lessonType} • ${schedule.dateTime.day}.${schedule.dateTime.month}.${schedule.dateTime.year} ${schedule.dateTime.hour.toString().padLeft(2, '0')}:${schedule.dateTime.minute.toString().padLeft(2, '0')}'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Ders'),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final title = TextEditingController();
    var type = 'Özel ders';
    var date = DateTime.now().add(const Duration(days: 1));
    var time = TimeOfDay.now();
    showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ders ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(controller: title, label: 'Ders başlığı'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  items: const [
                    DropdownMenuItem(value: 'Özel ders', child: Text('Özel ders')),
                    DropdownMenuItem(value: 'Okul dersi', child: Text('Okul dersi')),
                  ],
                  onChanged: (value) => setState(() => type = value!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text('${date.day}.${date.month}.${date.year}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            initialDate: date,
                          );
                          if (picked != null) setState(() => date = picked);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: Text(time.format(context)),
                        onPressed: () async {
                          final picked = await showTimePicker(context: context, initialTime: time);
                          if (picked != null) setState(() => time = picked);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgec')),
            FilledButton(
              onPressed: () async {
                final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                final lesson = LessonSchedule(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title.text,
                  lessonType: type,
                  dateTime: scheduled,
                );
                final state = context.read<AppState>();
                state.addSchedule(lesson);
                await state.notifications.scheduleReminder(
                  id: lesson.id.hashCode,
                  title: 'Ders hatırlatması',
                  body: lesson.title,
                  dateTime: scheduled.subtract(const Duration(minutes: 30)),
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
