import 'package:hive/hive.dart';

part 'story_session.g.dart';

@HiveType(typeId: 6)
class StorySession extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String studentId;
  
  @HiveField(2)
  final String storyId;
  
  @HiveField(3)
  final String storyTitle;
  
  @HiveField(4)
  final StoryType storyType;
  
  @HiveField(5)
  final DateTime startTime;
  
  @HiveField(6)
  final DateTime? endTime;
  
  @HiveField(7)
  final StorySessionStatus status;
  
  @HiveField(8)
  final List<StoryInteraction> interactions;
  
  @HiveField(9)
  final Map<String, dynamic> learningObjectives;
  
  @HiveField(10)
  final Map<String, dynamic> completionData;
  
  @HiveField(11)
  final String? voiceProfileUsed;
  
  @HiveField(12)
  final List<String> emotionalStatesDetected;
  
  @HiveField(13)
  final double comprehensionScore;
  
  @HiveField(14)
  final double engagementScore;
  
  @HiveField(15)
  final Map<String, dynamic> adaptationsApplied;
  
  StorySession({
    required this.id,
    required this.studentId,
    required this.storyId,
    required this.storyTitle,
    required this.storyType,
    required this.startTime,
    this.endTime,
    this.status = StorySessionStatus.inProgress,
    this.interactions = const [],
    this.learningObjectives = const {},
    this.completionData = const {},
    this.voiceProfileUsed,
    this.emotionalStatesDetected = const [],
    this.comprehensionScore = 0.0,
    this.engagementScore = 0.0,
    this.adaptationsApplied = const {},
  });
  
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }
  
  bool get isCompleted => status == StorySessionStatus.completed;
  
  StorySession copyWith({
    String? id,
    String? studentId,
    String? storyId,
    String? storyTitle,
    StoryType? storyType,
    DateTime? startTime,
    DateTime? endTime,
    StorySessionStatus? status,
    List<StoryInteraction>? interactions,
    Map<String, dynamic>? learningObjectives,
    Map<String, dynamic>? completionData,
    String? voiceProfileUsed,
    List<String>? emotionalStatesDetected,
    double? comprehensionScore,
    double? engagementScore,
    Map<String, dynamic>? adaptationsApplied,
  }) {
    return StorySession(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      storyId: storyId ?? this.storyId,
      storyTitle: storyTitle ?? this.storyTitle,
      storyType: storyType ?? this.storyType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      interactions: interactions ?? this.interactions,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      completionData: completionData ?? this.completionData,
      voiceProfileUsed: voiceProfileUsed ?? this.voiceProfileUsed,
      emotionalStatesDetected: emotionalStatesDetected ?? this.emotionalStatesDetected,
      comprehensionScore: comprehensionScore ?? this.comprehensionScore,
      engagementScore: engagementScore ?? this.engagementScore,
      adaptationsApplied: adaptationsApplied ?? this.adaptationsApplied,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'storyId': storyId,
      'storyTitle': storyTitle,
      'storyType': storyType.toString(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.toString(),
      'interactions': interactions.map((i) => i.toJson()).toList(),
      'learningObjectives': learningObjectives,
      'completionData': completionData,
      'voiceProfileUsed': voiceProfileUsed,
      'emotionalStatesDetected': emotionalStatesDetected,
      'comprehensionScore': comprehensionScore,
      'engagementScore': engagementScore,
      'adaptationsApplied': adaptationsApplied,
    };
  }
  
  factory StorySession.fromJson(Map<String, dynamic> json) {
    return StorySession(
      id: json['id'],
      studentId: json['studentId'],
      storyId: json['storyId'],
      storyTitle: json['storyTitle'],
      storyType: StoryType.values.firstWhere(
        (e) => e.toString() == json['storyType'],
        orElse: () => StoryType.learning,
      ),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: StorySessionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => StorySessionStatus.inProgress,
      ),
      interactions: (json['interactions'] as List? ?? [])
          .map((i) => StoryInteraction.fromJson(i))
          .toList(),
      learningObjectives: Map<String, dynamic>.from(json['learningObjectives'] ?? {}),
      completionData: Map<String, dynamic>.from(json['completionData'] ?? {}),
      voiceProfileUsed: json['voiceProfileUsed'],
      emotionalStatesDetected: List<String>.from(json['emotionalStatesDetected'] ?? []),
      comprehensionScore: json['comprehensionScore']?.toDouble() ?? 0.0,
      engagementScore: json['engagementScore']?.toDouble() ?? 0.0,
      adaptationsApplied: Map<String, dynamic>.from(json['adaptationsApplied'] ?? {}),
    );
  }
}

@HiveType(typeId: 7)
enum StoryType {
  @HiveField(0)
  learning,
  @HiveField(1)
  adventure,
  @HiveField(2)
  communication,
  @HiveField(3)
  emotional,
  @HiveField(4)
  social,
  @HiveField(5)
  creative,
}

@HiveType(typeId: 8)
enum StorySessionStatus {
  @HiveField(0)
  inProgress,
  @HiveField(1)
  paused,
  @HiveField(2)
  completed,
  @HiveField(3)
  abandoned,
  @HiveField(4)
  interrupted,
}

@HiveType(typeId: 9)
class StoryInteraction extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime timestamp;
  
  @HiveField(2)
  final InteractionType type;
  
  @HiveField(3)
  final String? content;
  
  @HiveField(4)
  final Map<String, dynamic> data;
  
  @HiveField(5)
  final double? responseTime;
  
  @HiveField(6)
  final bool isCorrect;
  
  @HiveField(7)
  final String? emotionalState;
  
  StoryInteraction({
    required this.id,
    required this.timestamp,
    required this.type,
    this.content,
    this.data = const {},
    this.responseTime,
    this.isCorrect = false,
    this.emotionalState,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'content': content,
      'data': data,
      'responseTime': responseTime,
      'isCorrect': isCorrect,
      'emotionalState': emotionalState,
    };
  }
  
  factory StoryInteraction.fromJson(Map<String, dynamic> json) {
    return StoryInteraction(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: InteractionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => InteractionType.tap,
      ),
      content: json['content'],
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      responseTime: json['responseTime']?.toDouble(),
      isCorrect: json['isCorrect'] ?? false,
      emotionalState: json['emotionalState'],
    );
  }
}

@HiveType(typeId: 10)
enum InteractionType {
  @HiveField(0)
  tap,
  @HiveField(1)
  voice,
  @HiveField(2)
  gesture,
  @HiveField(3)
  choice,
  @HiveField(4)
  drawing,
  @HiveField(5)
  text,
  @HiveField(6)
  emotion,
} 