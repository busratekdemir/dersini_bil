import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/progress_entry.dart';
import '../../services/app_state.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/progress_chart.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<AppState>().progressEntries;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Net ve Soru Takibi', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          SizedBox(height: 260, child: Card(child: Padding(padding: const EdgeInsets.all(12), child: ProgressChart(entries: entries)))),
          const SizedBox(height: 12),
          ...entries.reversed.map(
            (entry) => Card(
              child: ListTile(
                leading: const Icon(Icons.insights),
                title: Text('${entry.subject} - ${entry.netScore} net'),
                subtitle: Text('${entry.questionCount} soru • ${entry.date.day}.${entry.date.month}.${entry.date.year}'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add_chart),
        label: const Text('Veri'),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final question = TextEditingController();
    final net = TextEditingController();
    var subject = AppConstants.subjects.first;
    showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Günlük veri gir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: subject,
                items: AppConstants.subjects
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => subject = value!),
              ),
              const SizedBox(height: 12),
              CustomTextField(controller: question, label: 'Çözülen soru', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              CustomTextField(controller: net, label: 'Deneme neti', keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgec')),
            FilledButton(
              onPressed: () {
                context.read<AppState>().addProgress(
                      ProgressEntry(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        subject: subject,
                        questionCount: int.tryParse(question.text) ?? 0,
                        netScore: double.tryParse(net.text.replaceAll(',', '.')) ?? 0,
                        date: DateTime.now(),
                      ),
                    );
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
