import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/topic_model.dart';

class ClassTopicService {
  static const String _topicsUrl =
      'https://raw.githubusercontent.com/busratekdemir/dersini_bil/main/data/class_topics.json';

  Future<Map<String, List<Topic>>> fetchTopicsForClass(String classLevel) async {
    final response = await http.get(Uri.parse(_topicsUrl));

    if (response.statusCode != 200) {
      throw Exception('Konu verileri alınamadı.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final classKey = _normalizeClassLevel(classLevel);

    final Map<String, dynamic>? classData =
        data[classKey] as Map<String, dynamic>?;

    if (classData == null) {
      return {};
    }

    return classData.map((subject, titles) {
      final topicTitles = List<String>.from(titles as List);

      return MapEntry(
        subject,
        topicTitles.map((title) {
          return Topic(
            id: '${classKey}_${subject}_$title',
            subject: subject,
            title: title,
          );
        }).toList(),
      );
    });
  }

  String _normalizeClassLevel(String classLevel) {
    final normalized = classLevel.trim();

    if (normalized.toLowerCase().contains('mezun')) {
      return 'Mezun / sınava hazırlık';
    }

    return normalized
        .replaceAll('. sınıf', '')
        .replaceAll('. Sınıf', '')
        .replaceAll('sınıf', '')
        .replaceAll('Sınıf', '')
        .trim();
  }
}