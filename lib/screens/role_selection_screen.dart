import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../widgets/custom_button.dart';
import 'student/student_class_selection_screen.dart';
import 'teacher/teacher_mode_selection_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  static const routeName = '/role-selection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rol Seçimi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Dersini Bil sana nasıl yardım etsin?', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person, size: 34),
                  const SizedBox(height: 10),
                  Text('Öğrenci', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Konularını, ödevlerini, notlarını ve net gelişimini takip et.'),
                  const SizedBox(height: 14),
                  CustomButton(
                    label: 'Öğrenci olarak devam et',
                    onPressed: () async {
                      await context.read<AppState>().setRole('student');
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, StudentClassSelectionScreen.routeName);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.groups, size: 34),
                  const SizedBox(height: 10),
                  Text('Öğretmen', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Öğrencilerini, ders saatlerini ve atadığın ödevleri izle.'),
                  const SizedBox(height: 14),
                  CustomButton(
                    label: 'Öğretmen olarak devam et',
                    onPressed: () async {
                      await context.read<AppState>().setRole('teacher');
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, TeacherModeSelectionScreen.routeName);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
