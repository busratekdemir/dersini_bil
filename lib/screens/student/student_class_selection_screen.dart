import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'student_dashboard_screen.dart';

class StudentClassSelectionScreen extends StatefulWidget {
  const StudentClassSelectionScreen({super.key});
  static const routeName = '/student-class';

  @override
  State<StudentClassSelectionScreen> createState() => _StudentClassSelectionScreenState();
}

class _StudentClassSelectionScreenState extends State<StudentClassSelectionScreen> {
  String selected = '8. sınıf';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sınıf Seçimi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Hangi sınıf öğrencisisin?', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...AppConstants.classLevels.map(
            (level) => Card(
              child: ListTile(
                leading: Icon(
                  selected == level ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected == level ? Theme.of(context).colorScheme.primary : null,
                ),
                title: Text(level),
                onTap: () => setState(() => selected = level),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: 'Konularımı getir',
            icon: Icons.arrow_forward,
            onPressed: () async {
              await context.read<AppState>().setClassLevel(selected);
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, StudentDashboardScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }
}
