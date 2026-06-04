import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import 'teacher_subject_selection_screen.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Ayşe Yılmaz'),
            subtitle: Text('Eşleşme kodu: ${AppConstants.teacherCode}'),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kod kopyalanabilir: OGR123')));
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.teacherSubjects
              .map(
                (subject) => Chip(
                  label: Text(subject),
                  avatar: Icon(Icons.local_offer, color: AppColors.subject(subject), size: 18),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.tune),
            label: const Text('Ders alanlarını düzenle'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TeacherSubjectSelectionScreen()),
            ),
          ),
        ),
      ],
    );
  }
}
