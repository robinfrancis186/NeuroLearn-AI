import 'package:hive/hive.dart';

part 'emotional_state.g.dart';

@HiveType(typeId: 11)
class EmotionalState extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String studentId;
  
  @HiveField(2)
  final DateTime timestamp;
  
  @HiveField(3)
  final EmotionalValence valence;
  
  @HiveField(4)
  final double arousal; // 0.0 (calm) to 1.0 (excited)
  
  @HiveField(5)
  final List<DetectedEmotion> detectedEmotions;
  
  @HiveField(6)
  final EmotionDetectionSource source;
  
  @HiveField(7)
  final double confidence;
  
  @HiveField(8)
  final Map<String, dynamic> rawData;
  
  @HiveField(9)
  final StoryMood recommendedMood;
  
  @HiveField(10)
  final List<String> triggers;
  
  EmotionalState({
    required this.id,
    required this.studentId,
    required this.timestamp,
    required this.valence,
    required this.arousal,
    this.detectedEmotions = const [],
    required this.source,
    required this.confidence,
    this.rawData = const {},
    required this.recommendedMood,
    this.triggers = const [],
  });
  
  bool get isPositive => valence == EmotionalValence.positive;
  bool get isNegative => valence == EmotionalValence.negative;
  bool get isNeutral => valence == EmotionalValence.neutral;
  
  bool get isHighArousal => arousal > 0.7;
  bool get isLowArousal => arousal < 0.3;
  
  EmotionalState copyWith({
    String? id,
    String? studentId,
    DateTime? timestamp,
    EmotionalValence? valence,
    double? arousal,
    List<DetectedEmotion>? detectedEmotions,
    EmotionDetectionSource? source,
    double? confidence,
    Map<String, dynamic>? rawData,
    StoryMood? recommendedMood,
    List<String>? triggers,
  }) {
    return EmotionalState(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      timestamp: timestamp ?? this.timestamp,
      valence: valence ?? this.valence,
      arousal: arousal ?? this.arousal,
      detectedEmotions: detectedEmotions ?? this.detectedEmotions,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      rawData: rawData ?? this.rawData,
      recommendedMood: recommendedMood ?? this.recommendedMood,
      triggers: triggers ?? this.triggers,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'timestamp': timestamp.toIso8601String(),
      'valence': valence.toString(),
      'arousal': arousal,
      'detectedEmotions': detectedEmotions.map((e) => e.toJson()).toList(),
      'source': source.toString(),
      'confidence': confidence,
      'rawData': rawData,
      'recommendedMood': recommendedMood.toString(),
      'triggers': triggers,
    };
  }
  
  factory EmotionalState.fromJson(Map<String, dynamic> json) {
    return EmotionalState(
      id: json['id'],
      studentId: json['studentId'],
      timestamp: DateTime.parse(json['timestamp']),
      valence: EmotionalValence.values.firstWhere(
        (e) => e.toString() == json['valence'],
        orElse: () => EmotionalValence.neutral,
      ),
      arousal: json['arousal']?.toDouble() ?? 0.5,
      detectedEmotions: (json['detectedEmotions'] as List? ?? [])
          .map((e) => DetectedEmotion.fromJson(e))
          .toList(),
      source: EmotionDetectionSource.values.firstWhere(
        (e) => e.toString() == json['source'],
        orElse: () => EmotionDetectionSource.manual,
      ),
      confidence: json['confidence']?.toDouble() ?? 0.0,
      rawData: Map<String, dynamic>.from(json['rawData'] ?? {}),
      recommendedMood: StoryMood.values.firstWhere(
        (e) => e.toString() == json['recommendedMood'],
        orElse: () => StoryMood.neutral,
      ),
      triggers: List<String>.from(json['triggers'] ?? []),
    );
  }
}

@HiveType(typeId: 12)
enum EmotionalValence {
  @HiveField(0)
  positive,
  @HiveField(1)
  negative,
  @HiveField(2)
  neutral,
}

@HiveType(typeId: 13)
enum EmotionDetectionSource {
  @HiveField(0)
  facial,
  @HiveField(1)
  voice,
  @HiveField(2)
  interaction,
  @HiveField(3)
  physiological,
  @HiveField(4)
  manual,
  @HiveField(5)
  combined,
}

@HiveType(typeId: 14)
enum StoryMood {
  @HiveField(0)
  calm, // For relaxation and focus
  @HiveField(1)
  excitement, // For motivation and energy
  @HiveField(2)
  comfort, // For security and safety
  @HiveField(3)
  adventure, // For exploration and curiosity
  @HiveField(4)
  creative, // For imagination and expression
  @HiveField(5)
  social, // For connection and communication
  @HiveField(6)
  neutral, // Balanced approach
}

@HiveType(typeId: 15)
class DetectedEmotion extends HiveObject {
  @HiveField(0)
  final String label;
  
  @HiveField(1)
  final double confidence;
  
  @HiveField(2)
  final Map<String, dynamic> metadata;
  
  DetectedEmotion({
    required this.label,
    required this.confidence,
    this.metadata = const {},
  });
  
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'confidence': confidence,
      'metadata': metadata,
    };
  }
  
  factory DetectedEmotion.fromJson(Map<String, dynamic> json) {
    return DetectedEmotion(
      label: json['label'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

// Extension to map emotions to story moods
extension EmotionToMood on List<DetectedEmotion> {
  StoryMood toStoryMood() {
    if (isEmpty) return StoryMood.neutral;
    
    // Get the highest confidence emotion
    final primaryEmotion = reduce((a, b) => a.confidence > b.confidence ? a : b);
    
    switch (primaryEmotion.label.toLowerCase()) {
      case 'happy':
      case 'joy':
      case 'excited':
        return StoryMood.excitement;
      case 'calm':
      case 'relaxed':
      case 'peaceful':
        return StoryMood.calm;
      case 'sad':
      case 'anxious':
      case 'worried':
        return StoryMood.comfort;
      case 'curious':
      case 'interested':
        return StoryMood.adventure;
      case 'creative':
      case 'playful':
        return StoryMood.creative;
      case 'lonely':
      case 'social':
        return StoryMood.social;
      default:
        return StoryMood.neutral;
    }
  }
}

// Helper class for emotion analytics
class EmotionalAnalytics {
  static Map<String, dynamic> analyzeEmotionalPattern(List<EmotionalState> states) {
    if (states.isEmpty) return {};
    
    final emotionCounts = <String, int>{};
    final moodCounts = <StoryMood, int>{};
    double totalArousal = 0.0;
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final state in states) {
      // Count emotions
      for (final emotion in state.detectedEmotions) {
        emotionCounts[emotion.label] = (emotionCounts[emotion.label] ?? 0) + 1;
      }
      
      // Count moods
      moodCounts[state.recommendedMood] = (moodCounts[state.recommendedMood] ?? 0) + 1;
      
      // Track valence
      if (state.isPositive) positiveCount++;
      if (state.isNegative) negativeCount++;
      
      totalArousal += state.arousal;
    }
    
    return {
      'emotionCounts': emotionCounts,
      'moodCounts': moodCounts.map((k, v) => MapEntry(k.toString(), v)),
      'averageArousal': totalArousal / states.length,
      'positiveRatio': positiveCount / states.length,
      'negativeRatio': negativeCount / states.length,
      'dominantMood': moodCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key
          .toString(),
      'emotionalStability': _calculateStability(states),
    };
  }
  
  static double _calculateStability(List<EmotionalState> states) {
    if (states.length < 2) return 1.0;
    
    double variability = 0.0;
    for (int i = 1; i < states.length; i++) {
      final prev = states[i - 1];
      final curr = states[i];
      
      // Calculate change in arousal and valence
      final arousalChange = (curr.arousal - prev.arousal).abs();
      final valenceChange = curr.valence != prev.valence ? 1.0 : 0.0;
      
      variability += (arousalChange + valenceChange) / 2;
    }
    
    return 1.0 - (variability / (states.length - 1));
  }
} 