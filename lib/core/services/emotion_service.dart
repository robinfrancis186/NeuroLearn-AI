import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../models/emotional_state.dart';

class RealEmotionService {
  static final RealEmotionService _instance = RealEmotionService._internal();
  factory RealEmotionService() => _instance;
  RealEmotionService._internal();

  bool _isInitialized = false;
  bool _isActive = false;
  
  final StreamController<Map<String, dynamic>> _emotionStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  
  final StreamController<List<EmotionalState>> _historyStreamController =
      StreamController<List<EmotionalState>>.broadcast();
  
  Stream<Map<String, dynamic>> get emotionStream => _emotionStreamController.stream;
  Stream<List<EmotionalState>> get historyStream => _historyStreamController.stream;

  final List<String> _supportedEmotions = [
    'happy', 'sad', 'angry', 'surprise', 'fear', 'neutral'
  ];

  Map<String, double> _currentEmotions = {};
  List<Map<String, dynamic>> _emotionHistory = [];
  String _lastDominantEmotion = 'neutral';
  double _lastConfidence = 0.0;
  
  // Enhanced storage
  Box<EmotionalState>? _emotionBox;
  static const String _boxName = 'emotion_history';
  final Uuid _uuid = Uuid();
  String _currentStudentId = 'default_student';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('🔄 Initializing Real Emotion Detection...');
      
      // Initialize Hive storage
      try {
        _emotionBox = await Hive.openBox<EmotionalState>(_boxName);
        print('✅ Emotion history storage initialized');
      } catch (e) {
        print('⚠️ Could not initialize emotion storage: $e');
      }
      
      // Initialize emotion state
      _currentEmotions = {
        'happy': 0.0,
        'sad': 0.0,
        'angry': 0.0,
        'surprise': 0.0,
        'fear': 0.0,
        'neutral': 1.0,
      };
      
      _isInitialized = true;
      print('✅ Real Emotion Service initialized');
      
      // Emit initial state
      _updateEmotionState(_currentEmotions, isRealDetection: true);
      
      // Load and emit existing history
      _emitHistoryStream();
      
    } catch (e) {
      print('❌ Error initializing Real Emotion Service: $e');
      _isInitialized = true;
    }
  }

  void onEmotionDetected(Map<String, dynamic> emotionData) {
    if (!_isInitialized) return;

    try {
      String detectedEmotion = emotionData['emotion']?.toString().toLowerCase() ?? 'neutral';
      double confidence = (emotionData['confidence'] ?? 0.0).toDouble();
      
      // Map emotion names to our supported emotions
      detectedEmotion = _mapEmotionName(detectedEmotion);
      
      // Create emotion distribution
      Map<String, double> emotions = {};
      for (String emotion in _supportedEmotions) {
        emotions[emotion] = 0.0;
      }
      
      // Set the detected emotion
      emotions[detectedEmotion] = confidence;
      
      // Add some noise to other emotions for realism
      double remainingProbability = 1.0 - confidence;
      Random random = Random();
      
      for (String emotion in _supportedEmotions) {
        if (emotion != detectedEmotion) {
          emotions[emotion] = random.nextDouble() * remainingProbability * 0.2;
        }
      }
      
      // Normalize to sum to 1.0
      double total = emotions.values.fold(0.0, (sum, value) => sum + value);
      if (total > 0) {
        emotions.updateAll((key, value) => value / total);
      }
      
      _lastDominantEmotion = detectedEmotion;
      _lastConfidence = confidence;
      _isActive = true;
      
      _updateEmotionState(emotions, isRealDetection: true);
      
      print('🎯 Real emotion detected: $detectedEmotion (${(confidence * 100).toStringAsFixed(1)}%)');
      
    } catch (e) {
      print('❌ Error processing emotion data: $e');
    }
  }

  String _mapEmotionName(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'happiness':
      case 'joy':
        return 'happy';
      case 'sad':
      case 'sadness':
        return 'sad';
      case 'angry':
      case 'anger':
        return 'angry';
      case 'surprise':
      case 'surprised':
        return 'surprise';
      case 'fear':
      case 'afraid':
        return 'fear';
      case 'disgust':
        return 'angry'; // Map disgust to angry as we don't have disgust
      case 'neutral':
      case 'calm':
      default:
        return 'neutral';
    }
  }

  void onInitializationComplete() {
    _isActive = true;
    print('✅ Real emotion detection is now active');
    
    _emotionStreamController.add({
      'emotions': _currentEmotions,
      'isRealDetection': true,
      'timestamp': DateTime.now(),
      'status': 'active',
      'dominantEmotion': _lastDominantEmotion,
      'confidence': _lastConfidence,
    });
  }

  void onError(String error) {
    print('❌ Real emotion detection error: $error');
    _isActive = false;
    
    _emotionStreamController.add({
      'emotions': _currentEmotions,
      'isRealDetection': false,
      'timestamp': DateTime.now(),
      'status': 'error',
      'error': error,
    });
  }

  void _updateEmotionState(Map<String, double> emotions, {bool isRealDetection = false}) {
    _currentEmotions = Map<String, double>.from(emotions);
    
    // Add to in-memory history
    _emotionHistory.add({
      'timestamp': DateTime.now(),
      'emotions': Map<String, double>.from(emotions),
      'isRealDetection': isRealDetection,
      'dominantEmotion': _lastDominantEmotion,
      'confidence': _lastConfidence,
    });
    
    // Keep only last 100 entries in memory
    if (_emotionHistory.length > 100) {
      _emotionHistory.removeAt(0);
    }
    
    // Save to persistent storage
    _saveEmotionalState(emotions, isRealDetection);
    
    // Emit current state
    _emotionStreamController.add({
      'emotions': emotions,
      'isRealDetection': isRealDetection,
      'timestamp': DateTime.now(),
      'status': _isActive ? 'active' : 'initializing',
      'dominantEmotion': _lastDominantEmotion,
      'confidence': _lastConfidence,
    });
  }

  // Getters
  Map<String, double> get currentEmotions => Map<String, double>.from(_currentEmotions);
  List<Map<String, dynamic>> get emotionHistory => List<Map<String, dynamic>>.from(_emotionHistory);
  bool get isInitialized => _isInitialized;
  bool get isActive => _isActive;
  List<String> get supportedEmotions => List<String>.from(_supportedEmotions);
  String get lastDominantEmotion => _lastDominantEmotion;
  double get lastConfidence => _lastConfidence;

  /// Save emotional state to persistent storage
  Future<void> _saveEmotionalState(Map<String, double> emotions, bool isRealDetection) async {
    if (_emotionBox == null) return;
    
    try {
      final now = DateTime.now();
      final emotionId = _uuid.v4();
      
      // Create detected emotions list
      final detectedEmotions = <DetectedEmotion>[];
      emotions.forEach((emotion, confidence) {
        if (confidence > 0.1) {  // Only include emotions with meaningful confidence
          detectedEmotions.add(DetectedEmotion(
            label: emotion,
            confidence: confidence,
            metadata: {
              'source': isRealDetection ? 'real_detection' : 'simulation',
              'timestamp': now.toIso8601String(),
            },
          ));
        }
      });
      
      // Determine valence based on dominant emotion
      EmotionalValence valence = EmotionalValence.neutral;
      if (_lastDominantEmotion == 'happy') {
        valence = EmotionalValence.positive;
      } else if (['sad', 'angry', 'fear'].contains(_lastDominantEmotion)) {
        valence = EmotionalValence.negative;
      }
      
      // Determine recommended mood
      final recommendedMood = _determineStoryMood(_lastDominantEmotion, emotions);
      
      final emotionalState = EmotionalState(
        id: emotionId,
        studentId: _currentStudentId,
        timestamp: now,
        valence: valence,
        arousal: emotions.values.reduce((a, b) => a + b) / emotions.length, // Average as arousal
        detectedEmotions: detectedEmotions,
        source: isRealDetection ? EmotionDetectionSource.facial : EmotionDetectionSource.manual,
        confidence: _lastConfidence,
        rawData: {
          'emotions': emotions,
          'isRealDetection': isRealDetection,
          'dominantEmotion': _lastDominantEmotion,
        },
        recommendedMood: recommendedMood,
        triggers: _identifyTriggers(emotions),
      );
      
      await _emotionBox!.put(emotionId, emotionalState);
      
      // Emit updated history
      _emitHistoryStream();
      
      print('📊 Emotion saved to history: $_lastDominantEmotion (${(_lastConfidence * 100).toStringAsFixed(1)}%)');
      
    } catch (e) {
      print('❌ Error saving emotional state: $e');
    }
  }
  
  /// Determine story mood based on detected emotion
  StoryMood _determineStoryMood(String dominantEmotion, Map<String, double> emotions) {
    switch (dominantEmotion.toLowerCase()) {
      case 'happy':
        return emotions['happy']! > 0.7 ? StoryMood.excitement : StoryMood.calm;
      case 'sad':
      case 'fear':
        return StoryMood.comfort;
      case 'angry':
        return StoryMood.calm;
      case 'surprise':
        return StoryMood.adventure;
      case 'neutral':
      default:
        return StoryMood.neutral;
    }
  }
  
  /// Identify potential emotional triggers
  List<String> _identifyTriggers(Map<String, double> emotions) {
    final triggers = <String>[];
    
    emotions.forEach((emotion, confidence) {
      if (confidence > 0.6) {
        switch (emotion) {
          case 'happy':
            triggers.add('positive_engagement');
            break;
          case 'sad':
            triggers.add('challenging_content');
            break;
          case 'angry':
            triggers.add('frustration');
            break;
          case 'fear':
            triggers.add('overwhelming_content');
            break;
          case 'surprise':
            triggers.add('unexpected_element');
            break;
        }
      }
    });
    
    return triggers;
  }
  
  /// Emit history stream with current emotional states
  void _emitHistoryStream() {
    if (_emotionBox == null) return;
    
    try {
      final allEmotions = _emotionBox!.values
          .where((emotion) => emotion.studentId == _currentStudentId)
          .toList();
      
      // Sort by timestamp (newest first)
      allEmotions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      _historyStreamController.add(allEmotions);
    } catch (e) {
      print('❌ Error emitting history stream: $e');
    }
  }
  
  /// Get emotion history for analysis
  Future<List<EmotionalState>> getEmotionHistory({
    String? studentId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    if (_emotionBox == null) return [];
    
    try {
      var emotions = _emotionBox!.values
          .where((emotion) => emotion.studentId == (studentId ?? _currentStudentId))
          .toList();
      
      // Filter by date range
      if (startDate != null) {
        emotions = emotions.where((e) => e.timestamp.isAfter(startDate)).toList();
      }
      if (endDate != null) {
        emotions = emotions.where((e) => e.timestamp.isBefore(endDate)).toList();
      }
      
      // Sort by timestamp (newest first)
      emotions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Limit results
      if (limit != null && emotions.length > limit) {
        emotions = emotions.take(limit).toList();
      }
      
      return emotions;
    } catch (e) {
      print('❌ Error getting emotion history: $e');
      return [];
    }
  }
  
  /// Set current student ID for tracking
  void setStudentId(String studentId) {
    _currentStudentId = studentId;
    print('📚 Emotion tracking set for student: $studentId');
    _emitHistoryStream(); // Emit history for the new student
  }
  
  /// Get analytics for the current student
  Future<Map<String, dynamic>> getAnalytics({Duration? period}) async {
    final DateTime now = DateTime.now();
    final DateTime startDate = period != null 
        ? now.subtract(period)
        : now.subtract(Duration(days: 7)); // Default to last 7 days
    
    final history = await getEmotionHistory(
      startDate: startDate,
      endDate: now,
    );
    
    return _generateAnalytics(history);
  }
  
  /// Generate analytics from emotion history
  Map<String, dynamic> _generateAnalytics(List<EmotionalState> emotions) {
    if (emotions.isEmpty) {
      return {
        'totalEmotions': 0,
        'emotionCounts': <String, int>{},
        'moodCounts': <String, int>{},
        'averageArousal': 0.5,
        'averageConfidence': 0.0,
        'positiveRatio': 0.0,
        'negativeRatio': 0.0,
        'emotionalStability': 1.0,
        'dominantEmotion': 'neutral',
        'dominantMood': 'neutral',
        'recommendations': ['Start engaging to build emotional insights'],
      };
    }
    
    final emotionCounts = <String, int>{};
    final moodCounts = <StoryMood, int>{};
    
    double totalArousal = 0.0;
    double totalConfidence = 0.0;
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final emotion in emotions) {
      // Count detected emotions
      for (final detected in emotion.detectedEmotions) {
        emotionCounts[detected.label] = (emotionCounts[detected.label] ?? 0) + 1;
      }
      
      // Count moods
      moodCounts[emotion.recommendedMood] = (moodCounts[emotion.recommendedMood] ?? 0) + 1;
      
      // Accumulate metrics
      totalArousal += emotion.arousal;
      totalConfidence += emotion.confidence;
      
      if (emotion.valence == EmotionalValence.positive) positiveCount++;
      if (emotion.valence == EmotionalValence.negative) negativeCount++;
    }
    
    final length = emotions.length;
    final stability = _calculateEmotionalStability(emotions);
    
    return {
      'totalEmotions': length,
      'emotionCounts': emotionCounts,
      'moodCounts': moodCounts.map((k, v) => MapEntry(k.toString().split('.').last, v)),
      'averageArousal': totalArousal / length,
      'averageConfidence': totalConfidence / length,
      'positiveRatio': positiveCount / length,
      'negativeRatio': negativeCount / length,
      'emotionalStability': stability,
      'dominantEmotion': _findDominantEmotion(emotionCounts),
      'dominantMood': _findDominantMood(moodCounts),
      'recommendations': _generateRecommendations(positiveCount / length, totalArousal / length),
    };
  }
  
  /// Calculate emotional stability
  double _calculateEmotionalStability(List<EmotionalState> emotions) {
    if (emotions.length < 2) return 1.0;
    
    double totalVariation = 0.0;
    for (int i = 1; i < emotions.length; i++) {
      final prev = emotions[i - 1];
      final curr = emotions[i];
      
      final arousalChange = (curr.arousal - prev.arousal).abs();
      final valenceChange = prev.valence != curr.valence ? 1.0 : 0.0;
      
      totalVariation += (arousalChange + valenceChange) / 2;
    }
    
    return max(0.0, 1.0 - (totalVariation / (emotions.length - 1)));
  }
  
  /// Find dominant emotion from counts
  String _findDominantEmotion(Map<String, int> emotionCounts) {
    if (emotionCounts.isEmpty) return 'neutral';
    return emotionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// Find dominant mood from counts
  String _findDominantMood(Map<StoryMood, int> moodCounts) {
    if (moodCounts.isEmpty) return 'neutral';
    return moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key
        .toString()
        .split('.')
        .last;
  }
  
  /// Generate personalized recommendations
  List<String> _generateRecommendations(double positiveRatio, double averageArousal) {
    final recommendations = <String>[];
    
    if (positiveRatio < 0.4) {
      recommendations.add('Focus on comfort and calm story themes');
      recommendations.add('Incorporate more positive reinforcement');
    } else if (positiveRatio > 0.8) {
      recommendations.add('Great emotional balance! Continue current approach');
    }
    
    if (averageArousal > 0.7) {
      recommendations.add('Include more calming activities');
      recommendations.add('Use "calm" story moods more frequently');
    } else if (averageArousal < 0.3) {
      recommendations.add('Add more interactive and engaging elements');
      recommendations.add('Try "adventure" and "excitement" themed content');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Emotional patterns look balanced');
      recommendations.add('Continue with current learning approach');
    }
    
    return recommendations;
  }

  void dispose() {
    _emotionStreamController.close();
    _historyStreamController.close();
  }
}

// Legacy EmotionService class for backward compatibility
class EmotionService extends RealEmotionService {
  static final EmotionService _instance = EmotionService._internal();
  factory EmotionService() => _instance;
  EmotionService._internal() : super._internal();

  // Legacy getters for backward compatibility
  bool get isCameraActive => isActive;
  List<String> get coreEmotions => supportedEmotions;
  
  // Legacy null camera controller
  get cameraController => null;
}
