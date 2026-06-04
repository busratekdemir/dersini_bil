import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  String generateTeacherCode(String uid) {
    final prefix = uid.length >= 6 ? uid.substring(0, 6) : uid;
    return 'TCH${prefix.toUpperCase()}';
  }

  Future<void> createUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String role,
    String? classLevel,
  }) {
    final isTeacher = role == 'teacher';
    return _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName.trim(),
      'email': email.trim(),
      'role': role,
      'classLevel': isTeacher ? null : classLevel,
      'teacherCode': isTeacher ? generateTeacherCode(uid) : null,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> updateStudentClass(String uid, String classLevel) {
    return _firestore.collection('users').doc(uid).set({
      'classLevel': classLevel,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> findTeacherByCode(String teacherCode) async {
    final query = await _firestore
        .collection('users')
        .where('teacherCode', isEqualTo: teacherCode.trim().toUpperCase())
        .where('role', isEqualTo: 'teacher')
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.data();
  }

  Future<void> sendMatchRequest({
    required String studentId,
    required String studentName,
    required String teacherId,
    required String teacherName,
  }) async {
    final existing = await _firestore
        .collection('matchRequests')
        .where('studentId', isEqualTo: studentId)
        .where('teacherId', isEqualTo: teacherId)
        .where('status', whereIn: ['pending', 'accepted'])
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      throw StateError('duplicate-match-request');
    }

    await _firestore.collection('matchRequests').add({
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherMatchRequests(
    String teacherId,
  ) {
    return _firestore
        .collection('matchRequests')
        .where('teacherId', isEqualTo: teacherId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> acceptMatchRequest(
    String requestId,
    String studentId,
    String teacherId,
  ) async {
    final requestRef = _firestore.collection('matchRequests').doc(requestId);
    final matchId = '${teacherId}_$studentId';
    final request = await requestRef.get();
    final data = request.data() ?? <String, dynamic>{};
    await _firestore.runTransaction((transaction) async {
      transaction.set(requestRef, {'status': 'accepted'}, SetOptions(merge: true));
      transaction.set(_firestore.collection('matches').doc(matchId), {
        'teacherId': teacherId,
        'studentId': studentId,
        'teacherName': data['teacherName'],
        'studentName': data['studentName'],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Future<void> rejectMatchRequest(String requestId) {
    return _firestore.collection('matchRequests').doc(requestId).set({
      'status': 'rejected',
    }, SetOptions(merge: true));
  }

  Stream<int> getTeacherStudentCount(String teacherId) {
    return _firestore
        .collection('matches')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTeacherPendingRequestCount(String teacherId) {
    return _firestore
        .collection('matchRequests')
        .where('teacherId', isEqualTo: teacherId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTeacherAssignedHomeworkCount(String teacherId) {
    return _firestore
        .collection('homeworks')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<Map<String, dynamic>>> getTeacherStudents(String teacherId) {
    return _firestore
        .collection('matches')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .asyncMap((snapshot) async {
      final students = <Map<String, dynamic>>[];
      for (final match in snapshot.docs) {
        final data = match.data();
        final studentId = data['studentId'] as String?;
        if (studentId == null) continue;
        final studentDoc = await _firestore.collection('users').doc(studentId).get();
        final student = studentDoc.data();
        if (student != null) {
          students.add({...student, 'matchId': match.id});
        }
      }
      return students;
    });
  }

  Future<void> assignHomework({
    required String teacherId,
    required String studentId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) {
    return _firestore.collection('homeworks').add({
      'teacherId': teacherId,
      'studentId': studentId,
      'title': title.trim(),
      'description': description.trim(),
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': FieldValue.serverTimestamp(),
      'isCompleted': false,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentHomeworks(String studentId) {
    return _firestore
        .collection('homeworks')
        .where('studentId', isEqualTo: studentId)
        .snapshots();
  }

  Future<void> markHomeworkCompleted(String homeworkId, bool value) {
    return _firestore.collection('homeworks').doc(homeworkId).set({
      'isCompleted': value,
    }, SetOptions(merge: true));
  }
}
