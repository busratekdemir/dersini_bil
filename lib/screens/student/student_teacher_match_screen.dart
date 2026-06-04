import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../services/mock_data_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class StudentTeacherMatchScreen extends StatefulWidget {
  const StudentTeacherMatchScreen({super.key});

  @override
  State<StudentTeacherMatchScreen> createState() => _StudentTeacherMatchScreenState();
}

class _StudentTeacherMatchScreenState extends State<StudentTeacherMatchScreen> {
  final _code = TextEditingController(text: AppConstants.teacherCode);

  @override
  Widget build(BuildContext context) {
    final matched = context.watch<AppState>().isTeacherMatched;
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmenim')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomTextField(controller: _code, label: 'Öğretmen kodu', icon: Icons.key),
          const SizedBox(height: 12),
          CustomButton(
            label: 'Eşleş',
            icon: Icons.handshake,
            onPressed: () {
              if (_code.text.trim() == AppConstants.teacherCode) {
                context.read<AppState>().matchTeacher();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Öğretmen eşleşmesi tamamlandı.')));
              }
            },
          ),
          const SizedBox(height: 16),
          if (matched)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_pin),
                title: Text(MockDataService.teacher.name),
                subtitle: Text(MockDataService.teacher.subjects.join(', ')),
              ),
            ),
        ],
      ),
    );
  }
}
