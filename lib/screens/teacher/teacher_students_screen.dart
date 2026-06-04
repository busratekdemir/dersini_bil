import 'package:flutter/material.dart';

import '../../services/mock_data_service.dart';
import 'teacher_student_detail_screen.dart';

class TeacherStudentsScreen extends StatelessWidget {
  const TeacherStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Öğrencilerim', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...MockDataService.students.map(
          (student) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(student.name.characters.first)),
              title: Text(student.name),
              subtitle: Text('${student.classLevel} • ${student.subjects.join(', ')}'),
              trailing: Text('%${(student.progress * 100).round()}'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TeacherStudentDetailScreen(student: student)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
