import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/student_profile.dart';
import '../models/story_session.dart';
import '../models/emotional_state.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance!;
  
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  late FirebaseStorage _storage;
  
  static Future<void> initialize() async {
    _instance = FirebaseService._();
    await _instance!._init();
  }
  
  FirebaseService._();
  
  Future<void> _init() async {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _storage = FirebaseStorage.instance;
  }
  
  // Authentication methods
  Future<User?> signInAnonymously() async {
    try {
      final result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      throw FirebaseServiceException('Anonymous sign-in failed: $e');
    }
  }
  
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw FirebaseServiceException('Email sign-in failed: $e');
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  User? get currentUser => _auth.currentUser;
  
  // Student Profile operations
  Future<void> saveStudentProfile(StudentProfile profile) async {
    try {
      await _firestore
          .collection('students')
          .doc(profile.id)
          .set(profile.toJson());
    } catch (e) {
      throw FirebaseServiceException('Failed to save student profile: $e');
    }
  }
  
  Future<StudentProfile?> getStudentProfile(String studentId) async {
    try {
      final doc = await _firestore
          .collection('students')
          .doc(studentId)
          .get();
      
      if (doc.exists) {
        return StudentProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw FirebaseServiceException('Failed to get student profile: $e');
    }
  }
  
  Future<List<StudentProfile>> getStudentProfiles() async {
    try {
      final query = await _firestore
          .collection('students')
          .where('isActive', isEqualTo: true)
          .get();
      
      return query.docs
          .map((doc) => StudentProfile.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw FirebaseServiceException('Failed to get student profiles: $e');
    }
  }
  
  // Story Session operations
  Future<void> saveStorySession(StorySession session) async {
    try {
      await _firestore
          .collection('story_sessions')
          .doc(session.id)
          .set(session.toJson());
    } catch (e) {
      throw FirebaseServiceException('Failed to save story session: $e');
    }
  }
  
  Future<List<StorySession>> getStudentStorySessions(String studentId) async {
    try {
      final query = await _firestore
          .collection('story_sessions')
          .where('studentId', isEqualTo: studentId)
          .orderBy('startTime', descending: true)
          .get();
      
      return query.docs
          .map((doc) => StorySession.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw FirebaseServiceException('Failed to get story sessions: $e');
    }
  }
  
  // Emotional State operations
  Future<void> saveEmotionalState(EmotionalState state) async {
    try {
      await _firestore
          .collection('emotional_states')
          .doc(state.id)
          .set(state.toJson());
    } catch (e) {
      throw FirebaseServiceException('Failed to save emotional state: $e');
    }
  }
  
  Future<List<EmotionalState>> getStudentEmotionalStates(
    String studentId, {
    DateTime? since,
    int? limit,
  }) async {
    try {
      Query query = _firestore
          .collection('emotional_states')
          .where('studentId', isEqualTo: studentId)
          .orderBy('timestamp', descending: true);
      
      if (since != null) {
        query = query.where('timestamp', isGreaterThan: since);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final result = await query.get();
      
      return result.docs
          .map((doc) => EmotionalState.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw FirebaseServiceException('Failed to get emotional states: $e');
    }
  }
  
  // File upload operations
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw FirebaseServiceException('Failed to upload file: $e');
    }
  }
  
  // Analytics and reporting
  Future<Map<String, dynamic>> getStudentAnalytics(String studentId) async {
    try {
      final sessions = await getStudentStorySessions(studentId);
      final emotions = await getStudentEmotionalStates(studentId, limit: 100);
      
      return {
        'totalSessions': sessions.length,
        'completedSessions': sessions.where((s) => s.isCompleted).length,
        'averageEngagement': _calculateAverageEngagement(sessions),
        'averageComprehension': _calculateAverageComprehension(sessions),
        'emotionalPattern': EmotionalAnalytics.analyzeEmotionalPattern(emotions),
        'lastActivity': sessions.isNotEmpty ? sessions.first.startTime : null,
      };
    } catch (e) {
      throw FirebaseServiceException('Failed to get analytics: $e');
    }
  }
  
  double _calculateAverageEngagement(List<StorySession> sessions) {
    if (sessions.isEmpty) return 0.0;
    
    final scores = sessions.map((s) => s.engagementScore).where((s) => s > 0);
    if (scores.isEmpty) return 0.0;
    
    return scores.reduce((a, b) => a + b) / scores.length;
  }
  
  double _calculateAverageComprehension(List<StorySession> sessions) {
    if (sessions.isEmpty) return 0.0;
    
    final scores = sessions.map((s) => s.comprehensionScore).where((s) => s > 0);
    if (scores.isEmpty) return 0.0;
    
    return scores.reduce((a, b) => a + b) / scores.length;
  }
}

class FirebaseServiceException implements Exception {
  final String message;
  FirebaseServiceException(this.message);
  
  @override
  String toString() => 'FirebaseServiceException: $message';
} 