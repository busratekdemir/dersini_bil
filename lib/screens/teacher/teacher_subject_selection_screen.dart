import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../utils/constants.dart';

class TeacherSubjectSelectionScreen extends StatelessWidget {
  const TeacherSubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<AppState>().teacherSubjects;
    return Scaffold(
      appBar: AppBar(title: const Text('Ders Alanları')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: AppConstants.teacherSubjects.map((subject) {
          return CheckboxListTile(
            value: selected.contains(subject),
            title: Text(subject),
            onChanged: (_) {
              final next = [...selected];
              next.contains(subject) ? next.remove(subject) : next.add(subject);
              context.read<AppState>().setTeacherSubjects(next);
            },
          );
        }).toList(),
      ),
    );
  }
}
