import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/homework_model.dart';
import '../models/note_model.dart';
import '../models/progress_entry.dart';
import '../models/topic_model.dart';

class LocalStorageService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get role => _prefs.getString('role');
  String? get classLevel => _prefs.getString('classLevel');
  String? get teacherMode => _prefs.getString('teacherMode');

  Future<void> saveRole(String value) => _prefs.setString('role', value);
  Future<void> clearRole() => _prefs.remove('role');
  Future<void> saveClassLevel(String value) => _prefs.setString('classLevel', value);
  Future<void> saveTeacherMode(String value) => _prefs.setString('teacherMode', value);

  List<T> _readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> _writeList(String key, List<Map<String, dynamic>> values) {
    return _prefs.setString(key, jsonEncode(values));
  }

  List<Homework> loadHomeworks() => _readList('homeworks', Homework.fromJson);
  Future<void> saveHomeworks(List<Homework> values) {
    return _writeList('homeworks', values.map((item) => item.toJson()).toList());
  }

  List<StudyNote> loadNotes() => _readList('notes', StudyNote.fromJson);
  Future<void> saveNotes(List<StudyNote> values) {
    return _writeList('notes', values.map((item) => item.toJson()).toList());
  }

  List<ProgressEntry> loadProgress() => _readList('progress', ProgressEntry.fromJson);
  Future<void> saveProgress(List<ProgressEntry> values) {
    return _writeList('progress', values.map((item) => item.toJson()).toList());
  }

  List<Topic> loadTopics() => _readList('topics', Topic.fromJson);
  Future<void> saveTopics(List<Topic> values) {
    return _writeList('topics', values.map((item) => item.toJson()).toList());
  }
}
