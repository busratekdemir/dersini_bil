import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note_model.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_text_field.dart';

class StudentNotesScreen extends StatelessWidget {
  const StudentNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<AppState>().notes;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notlarım', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...notes.map(
            (note) => Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () => _showNoteDialog(context, note: note),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => context.read<AppState>().deleteNote(note.id),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Not'),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, {StudyNote? note}) {
    final title = TextEditingController(text: note?.title);
    final content = TextEditingController(text: note?.content);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'Not ekle' : 'Notu düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: title, label: 'Başlık'),
              const SizedBox(height: 12),
              CustomTextField(controller: content, label: 'İçerik', maxLines: 5),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgec')),
          FilledButton(
            onPressed: () {
              context.read<AppState>().saveNote(
                    StudyNote(
                      id: note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                      title: title.text,
                      content: content.text,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
