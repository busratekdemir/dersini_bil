import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';
import 'teacher_dashboard_screen.dart';

class TeacherModeSelectionScreen extends StatelessWidget {
  const TeacherModeSelectionScreen({super.key});
  static const routeName = '/teacher-mode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmen Kategorisi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Hangi takip türüyle başlayalım?', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _ModeCard(title: 'Özel ders takibi', icon: Icons.person_search, value: 'Özel ders'),
          _ModeCard(title: 'Okul dersleri takibi', icon: Icons.apartment, value: 'Okul dersi'),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.title, required this.icon, required this.value});
  final String title;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            CustomButton(
              label: 'Seç ve devam et',
              onPressed: () async {
                await context.read<AppState>().setTeacherMode(value);
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, TeacherDashboardScreen.routeName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
