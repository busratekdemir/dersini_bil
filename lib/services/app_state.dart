import 'package:flutter/material.dart';

import '../models/homework_model.dart';
import '../models/note_model.dart';
import '../models/progress_entry.dart';
import '../models/schedule_model.dart';
import '../models/topic_model.dart';
import 'local_storage_service.dart';
import 'mock_data_service.dart';
import 'notification_service.dart';

class AppState extends ChangeNotifier {
  AppState({required this.storage, required this.notifications});

  final LocalStorageService storage;
  final NotificationService notifications;

  String? role;
  String? classLevel;
  String? teacherMode;
  List<Homework> homeworks = [];
  List<Homework> assignedHomeworks = [];
  List<StudyNote> notes = [];
  List<ProgressEntry> progressEntries = [];
  List<Topic> completedTopics = [];
  List<LessonSchedule> schedules = [];
  List<String> teacherSubjects = ['Matematik'];
  bool isTeacherMatched = false;

  void load() {
    role = storage.role;
    classLevel = storage.classLevel;
    teacherMode = storage.teacherMode;
    homeworks = storage.loadHomeworks();
    if (homeworks.isEmpty) homeworks = [...MockDataService.demoHomework];
    notes = storage.loadNotes();
    progressEntries = storage.loadProgress();
    completedTopics = storage.loadTopics();
    notifyListeners();
  }

  Future<void> setRole(String value) async {
    role = value;
    await storage.saveRole(value);
    notifyListeners();
  }

  Future<void> clearRole() async {
    role = null;
    await storage.clearRole();
    notifyListeners();
  }

  Future<void> clearSession() async {
    role = null;
    classLevel = null;
    teacherMode = null;
    await storage.clearSession();
    notifyListeners();
  }

  Future<void> setClassLevel(String value) async {
    classLevel = value;
    await storage.saveClassLevel(value);
    notifyListeners();
  }

  Future<void> setTeacherMode(String value) async {
    teacherMode = value;
    await storage.saveTeacherMode(value);
    notifyListeners();
  }

  Future<void> upsertHomework(Homework homework) async {
    final index = homeworks.indexWhere((item) => item.id == homework.id);
    if (index >= 0) {
      homeworks[index] = homework;
    } else {
      homeworks.add(homework);
    }
    await storage.saveHomeworks(homeworks);
    notifyListeners();
  }

  Future<void> assignHomework(Homework homework) async {
    assignedHomeworks.add(homework);
    notifyListeners();
  }

  Future<void> toggleHomework(Homework homework) async {
    await upsertHomework(homework.copyWith(isCompleted: !homework.isCompleted));
  }

  Future<void> saveNote(StudyNote note) async {
    final index = notes.indexWhere((item) => item.id == note.id);
    if (index >= 0) {
      notes[index] = note;
    } else {
      notes.add(note);
    }
    await storage.saveNotes(notes);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    notes.removeWhere((note) => note.id == id);
    await storage.saveNotes(notes);
    notifyListeners();
  }

  Future<void> addProgress(ProgressEntry entry) async {
    progressEntries.add(entry);
    await storage.saveProgress(progressEntries);
    notifyListeners();
  }

  Future<void> toggleTopic(Topic topic) async {
    final exists = completedTopics.any((item) => item.id == topic.id);
    if (exists) {
      completedTopics.removeWhere((item) => item.id == topic.id);
    } else {
      completedTopics.add(topic.copyWith(isCompleted: true));
    }
    await storage.saveTopics(completedTopics);
    notifyListeners();
  }

  bool isTopicCompleted(String id) => completedTopics.any((topic) => topic.id == id);

  void addSchedule(LessonSchedule schedule) {
    schedules.add(schedule);
    notifyListeners();
  }

  void setTeacherSubjects(List<String> subjects) {
    teacherSubjects = subjects;
    notifyListeners();
  }

  void matchTeacher() {
    isTeacherMatched = true;
    notifyListeners();
  }
}
