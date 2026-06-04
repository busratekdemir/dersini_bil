import 'package:flutter/material.dart';

import '../models/homework_model.dart';
import '../utils/app_colors.dart';

class HomeworkCard extends StatelessWidget {
  const HomeworkCard({
    super.key,
    required this.homework,
    required this.onToggle,
    this.trailing,
  });

  final Homework homework;
  final VoidCallback onToggle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.subject(homework.subject);
    return Card(
      child: ListTile(
        leading: Checkbox(value: homework.isCompleted, onChanged: (_) => onToggle()),
        title: Text(homework.title),
        subtitle: Text('${homework.subject} • Teslim: ${_date(homework.dueDate)}'),
        trailing: trailing ?? Icon(Icons.notifications_active, color: color),
      ),
    );
  }

  String _date(DateTime date) => '${date.day}.${date.month}.${date.year}';
}
