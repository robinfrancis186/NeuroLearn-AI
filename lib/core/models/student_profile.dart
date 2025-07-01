import 'package:hive/hive.dart';

part 'student_profile.g.dart';

@HiveType(typeId: 0)
class StudentProfile extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int age;
  
  @HiveField(3)
  final String avatarPath;
  
  @HiveField(4)
  final CognitiveProfile cognitiveProfile;
  
  @HiveField(5)
  final List<String> favoriteCharacters;
  
  @HiveField(6)
  final List<String> preferredTopics;
  
  @HiveField(7)
  final Map<String, dynamic> learningProgress;
  
  @HiveField(8)
  final String? parentEmail;
  
  @HiveField(9)
  final String? teacherEmail;
  
  @HiveField(10)
  final DateTime createdAt;
  
  @HiveField(11)
  final DateTime lastActiveAt;
  
  @HiveField(12)
  final bool isActive;
  
  StudentProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarPath,
    required this.cognitiveProfile,
    this.favoriteCharacters = const [],
    this.preferredTopics = const [],
    this.learningProgress = const {},
    this.parentEmail,
    this.teacherEmail,
    required this.createdAt,
    required this.lastActiveAt,
    this.isActive = true,
  });
  
  StudentProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? avatarPath,
    CognitiveProfile? cognitiveProfile,
    List<String>? favoriteCharacters,
    List<String>? preferredTopics,
    Map<String, dynamic>? learningProgress,
    String? parentEmail,
    String? teacherEmail,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    bool? isActive,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarPath: avatarPath ?? this.avatarPath,
      cognitiveProfile: cognitiveProfile ?? this.cognitiveProfile,
      favoriteCharacters: favoriteCharacters ?? this.favoriteCharacters,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      learningProgress: learningProgress ?? this.learningProgress,
      parentEmail: parentEmail ?? this.parentEmail,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isActive: isActive ?? this.isActive,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'avatarPath': avatarPath,
      'cognitiveProfile': cognitiveProfile.toJson(),
      'favoriteCharacters': favoriteCharacters,
      'preferredTopics': preferredTopics,
      'learningProgress': learningProgress,
      'parentEmail': parentEmail,
      'teacherEmail': teacherEmail,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'isActive': isActive,
    };
  }
  
  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      avatarPath: json['avatarPath'],
      cognitiveProfile: CognitiveProfile.fromJson(json['cognitiveProfile']),
      favoriteCharacters: List<String>.from(json['favoriteCharacters'] ?? []),
      preferredTopics: List<String>.from(json['preferredTopics'] ?? []),
      learningProgress: Map<String, dynamic>.from(json['learningProgress'] ?? {}),
      parentEmail: json['parentEmail'],
      teacherEmail: json['teacherEmail'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: DateTime.parse(json['lastActiveAt']),
      isActive: json['isActive'] ?? true,
    );
  }
}

@HiveType(typeId: 1)
class CognitiveProfile extends HiveObject {
  @HiveField(0)
  final List<String> neurodivergentTraits;
  
  @HiveField(1)
  final LearningStyle primaryLearningStyle;
  
  @HiveField(2)
  final AttentionProfile attentionProfile;
  
  @HiveField(3)
  final SensoryPreferences sensoryPreferences;
  
  @HiveField(4)
  final CommunicationNeeds communicationNeeds;
  
  @HiveField(5)
  final Map<String, double> skillLevels;
  
  @HiveField(6)
  final List<String> supportStrategies;
  
  CognitiveProfile({
    this.neurodivergentTraits = const [],
    required this.primaryLearningStyle,
    required this.attentionProfile,
    required this.sensoryPreferences,
    required this.communicationNeeds,
    this.skillLevels = const {},
    this.supportStrategies = const [],
  });
  
  Map<String, dynamic> toJson() {
    return {
      'neurodivergentTraits': neurodivergentTraits,
      'primaryLearningStyle': primaryLearningStyle.toString(),
      'attentionProfile': attentionProfile.toJson(),
      'sensoryPreferences': sensoryPreferences.toJson(),
      'communicationNeeds': communicationNeeds.toJson(),
      'skillLevels': skillLevels,
      'supportStrategies': supportStrategies,
    };
  }
  
  factory CognitiveProfile.fromJson(Map<String, dynamic> json) {
    return CognitiveProfile(
      neurodivergentTraits: List<String>.from(json['neurodivergentTraits'] ?? []),
      primaryLearningStyle: LearningStyle.values.firstWhere(
        (e) => e.toString() == json['primaryLearningStyle'],
        orElse: () => LearningStyle.visual,
      ),
      attentionProfile: AttentionProfile.fromJson(json['attentionProfile']),
      sensoryPreferences: SensoryPreferences.fromJson(json['sensoryPreferences']),
      communicationNeeds: CommunicationNeeds.fromJson(json['communicationNeeds']),
      skillLevels: Map<String, double>.from(json['skillLevels'] ?? {}),
      supportStrategies: List<String>.from(json['supportStrategies'] ?? []),
    );
  }
}

@HiveType(typeId: 2)
enum LearningStyle {
  @HiveField(0)
  visual,
  @HiveField(1)
  auditory,
  @HiveField(2)
  kinesthetic,
  @HiveField(3)
  reading,
  @HiveField(4)
  multimodal,
}

@HiveType(typeId: 3)
class AttentionProfile extends HiveObject {
  @HiveField(0)
  final int attentionSpanMinutes;
  
  @HiveField(1)
  final List<String> distractionTriggers;
  
  @HiveField(2)
  final List<String> focusStrategies;
  
  @HiveField(3)
  final bool needsBreaks;
  
  @HiveField(4)
  final int breakIntervalMinutes;
  
  AttentionProfile({
    required this.attentionSpanMinutes,
    this.distractionTriggers = const [],
    this.focusStrategies = const [],
    this.needsBreaks = false,
    this.breakIntervalMinutes = 15,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'attentionSpanMinutes': attentionSpanMinutes,
      'distractionTriggers': distractionTriggers,
      'focusStrategies': focusStrategies,
      'needsBreaks': needsBreaks,
      'breakIntervalMinutes': breakIntervalMinutes,
    };
  }
  
  factory AttentionProfile.fromJson(Map<String, dynamic> json) {
    return AttentionProfile(
      attentionSpanMinutes: json['attentionSpanMinutes'],
      distractionTriggers: List<String>.from(json['distractionTriggers'] ?? []),
      focusStrategies: List<String>.from(json['focusStrategies'] ?? []),
      needsBreaks: json['needsBreaks'] ?? false,
      breakIntervalMinutes: json['breakIntervalMinutes'] ?? 15,
    );
  }
}

@HiveType(typeId: 4)
class SensoryPreferences extends HiveObject {
  @HiveField(0)
  final bool visualSensitivity;
  
  @HiveField(1)
  final bool auditorySensitivity;
  
  @HiveField(2)
  final bool tactileSensitivity;
  
  @HiveField(3)
  final double preferredVolume;
  
  @HiveField(4)
  final bool reducedAnimations;
  
  @HiveField(5)
  final bool highContrast;
  
  SensoryPreferences({
    this.visualSensitivity = false,
    this.auditorySensitivity = false,
    this.tactileSensitivity = false,
    this.preferredVolume = 0.7,
    this.reducedAnimations = false,
    this.highContrast = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'visualSensitivity': visualSensitivity,
      'auditorySensitivity': auditorySensitivity,
      'tactileSensitivity': tactileSensitivity,
      'preferredVolume': preferredVolume,
      'reducedAnimations': reducedAnimations,
      'highContrast': highContrast,
    };
  }
  
  factory SensoryPreferences.fromJson(Map<String, dynamic> json) {
    return SensoryPreferences(
      visualSensitivity: json['visualSensitivity'] ?? false,
      auditorySensitivity: json['auditorySensitivity'] ?? false,
      tactileSensitivity: json['tactileSensitivity'] ?? false,
      preferredVolume: json['preferredVolume']?.toDouble() ?? 0.7,
      reducedAnimations: json['reducedAnimations'] ?? false,
      highContrast: json['highContrast'] ?? false,
    );
  }
}

@HiveType(typeId: 5)
class CommunicationNeeds extends HiveObject {
  @HiveField(0)
  final bool usesAAC;
  
  @HiveField(1)
  final bool needsVisualSupports;
  
  @HiveField(2)
  final bool prefersShorterSentences;
  
  @HiveField(3)
  final bool needsRepetition;
  
  @HiveField(4)
  final List<String> communicationMethods;
  
  CommunicationNeeds({
    this.usesAAC = false,
    this.needsVisualSupports = false,
    this.prefersShorterSentences = false,
    this.needsRepetition = false,
    this.communicationMethods = const [],
  });
  
  Map<String, dynamic> toJson() {
    return {
      'usesAAC': usesAAC,
      'needsVisualSupports': needsVisualSupports,
      'prefersShorterSentences': prefersShorterSentences,
      'needsRepetition': needsRepetition,
      'communicationMethods': communicationMethods,
    };
  }
  
  factory CommunicationNeeds.fromJson(Map<String, dynamic> json) {
    return CommunicationNeeds(
      usesAAC: json['usesAAC'] ?? false,
      needsVisualSupports: json['needsVisualSupports'] ?? false,
      prefersShorterSentences: json['prefersShorterSentences'] ?? false,
      needsRepetition: json['needsRepetition'] ?? false,
      communicationMethods: List<String>.from(json['communicationMethods'] ?? []),
    );
  }
} 