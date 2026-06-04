import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class TeacherStudentDetailScreen extends StatelessWidget {
  const TeacherStudentDetailScreen({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(student.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ödevler'),
              Tab(text: 'Konular'),
              Tab(text: 'Netler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _InfoList(items: ['Matematik: 30 soru', 'Türkçe: Paragraf denemesi']),
            _InfoList(items: student.subjects.map((item) => '$item ilerleme: %${(student.progress * 100).round()}').toList()),
            _InfoList(items: const ['Son deneme: 72.5 net', 'Haftalik soru: 420']),
          ],
        ),
      ),
    );
  }
}

class _InfoList extends StatelessWidget {
  const _InfoList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: items.map((item) => Card(child: ListTile(title: Text(item)))).toList(),
    );
  }
}
