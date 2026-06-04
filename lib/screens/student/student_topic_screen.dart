import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/topic_model.dart';
import '../../services/app_state.dart';
import '../../services/class_topic_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/subject_card.dart';

class StudentTopicScreen extends StatefulWidget {
  const StudentTopicScreen({super.key});

  @override
  State<StudentTopicScreen> createState() => _StudentTopicScreenState();
}

class _StudentTopicScreenState extends State<StudentTopicScreen> {
  final _service = ClassTopicService();

  @override
  Widget build(BuildContext context) {
    final classLevel = context.watch<AppState>().classLevel ?? '8. sınıf';
    return FutureBuilder<Map<String, List<Topic>>>(
      future: _service.fetchTopicsForClass(classLevel),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('$classLevel konuları', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: data.entries.map((entry) {
                final completed = entry.value.where((topic) {
                  return context.read<AppState>().isTopicCompleted(topic.id);
                }).length;
                return SubjectCard(
                  subject: entry.key,
                  progress: completed / entry.value.length,
                  onTap: () => _openTopics(context, entry.key, entry.value),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _openTopics(BuildContext context, String subject, List<Topic> topics) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Consumer<AppState>(
        builder: (context, state, child) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(subject, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...topics.map(
              (topic) => CheckboxListTile(
                value: state.isTopicCompleted(topic.id),
                title: Text(topic.title),
                activeColor: AppColors.subject(subject),
                onChanged: (_) => state.toggleTopic(topic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
