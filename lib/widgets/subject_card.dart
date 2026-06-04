import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.progress,
    required this.onTap,
  });

  final String subject;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.subject(subject);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(Icons.menu_book, color: color, size: 18),
                  ),
                  const Spacer(),
                  Text('%${(progress * 100).round()}'),
                ],
              ),
              const SizedBox(height: 18),
              Text(subject, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                color: color,
                backgroundColor: color.withValues(alpha: 0.12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
