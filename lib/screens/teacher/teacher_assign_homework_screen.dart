import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/homework_model.dart';
import '../../services/app_state.dart';
import '../../services/mock_data_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';

class TeacherAssignHomeworkScreen extends StatefulWidget {
  const TeacherAssignHomeworkScreen({super.key});

  @override
  State<TeacherAssignHomeworkScreen> createState() => _TeacherAssignHomeworkScreenState();
}

class _TeacherAssignHomeworkScreenState extends State<TeacherAssignHomeworkScreen> {
  final _description = TextEditingController();
  String _student = MockDataService.students.first.name;
  String _subject = AppConstants.subjects.first;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    final assigned = context.watch<AppState>().assignedHomeworks;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Ödev Atama', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _student,
                  decoration: const InputDecoration(labelText: 'Öğrenci'),
                  items: MockDataService.students
                      .map((item) => DropdownMenuItem(value: item.name, child: Text(item.name)))
                      .toList(),
                  onChanged: (value) => setState(() => _student = value!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _subject,
                  decoration: const InputDecoration(labelText: 'Ders'),
                  items: AppConstants.subjects
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => _subject = value!),
                ),
                const SizedBox(height: 12),
                CustomTextField(controller: _description, label: 'Ödev açıklaması', maxLines: 3),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.event),
                  label: Text('Teslim: ${_dueDate.day}.${_dueDate.month}.${_dueDate.year}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: _dueDate,
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<AppState>().assignHomework(
                            Homework(
                              id: DateTime.now().microsecondsSinceEpoch.toString(),
                              title: _description.text,
                              subject: _subject,
                              dueDate: _dueDate,
                              studentName: _student,
                            ),
                          );
                      _description.clear();
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Ödevi ata'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...assigned.map(
          (homework) => Card(
            child: ListTile(
              leading: const Icon(Icons.assignment_turned_in),
              title: Text(homework.title),
              subtitle: Text('${homework.studentName} • ${homework.subject}'),
            ),
          ),
        ),
      ],
    );
  }
}
