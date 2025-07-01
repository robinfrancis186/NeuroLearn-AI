import 'package:hive/hive.dart';

part 'progress_data.g.dart';

@HiveType(typeId: 6)
class StudentProgress extends HiveObject {
  @HiveField(0)
  final String studentId;
  
  @HiveField(1)
  final int storiesCompleted;
  
  @HiveField(2)
  final Duration totalLearningTime;
  
  @HiveField(3)
  final int learningStreakDays;
  
  @HiveField(4)
  final int achievements;
  
  @HiveField(5)
  final Map<String, double> subjectProgress;
  
  @HiveField(6)
  final List<DailyActivity> weeklyActivity;
  
  @HiveField(7)
  final List<DailyLearningTime> dailyLearningTime;
  
  @HiveField(8)
  final Map<String, dynamic> moodData;
  
  @HiveField(9)
  final DateTime lastUpdated;
  
  StudentProgress({
    required this.studentId,
    this.storiesCompleted = 0,
    this.totalLearningTime = Duration.zero,
    this.learningStreakDays = 0,
    this.achievements = 0,
    this.subjectProgress = const {},
    this.weeklyActivity = const [],
    this.dailyLearningTime = const [],
    this.moodData = const {},
    required this.lastUpdated,
  });
  
  StudentProgress copyWith({
    String? studentId,
    int? storiesCompleted,
    Duration? totalLearningTime,
    int? learningStreakDays,
    int? achievements,
    Map<String, double>? subjectProgress,
    List<DailyActivity>? weeklyActivity,
    List<DailyLearningTime>? dailyLearningTime,
    Map<String, dynamic>? moodData,
    DateTime? lastUpdated,
  }) {
    return StudentProgress(
      studentId: studentId ?? this.studentId,
      storiesCompleted: storiesCompleted ?? this.storiesCompleted,
      totalLearningTime: totalLearningTime ?? this.totalLearningTime,
      learningStreakDays: learningStreakDays ?? this.learningStreakDays,
      achievements: achievements ?? this.achievements,
      subjectProgress: subjectProgress ?? this.subjectProgress,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      dailyLearningTime: dailyLearningTime ?? this.dailyLearningTime,
      moodData: moodData ?? this.moodData,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@HiveType(typeId: 7)
class DailyActivity extends HiveObject {
  @HiveField(0)
  final String day;
  
  @HiveField(1)
  final double value;
  
  @HiveField(2)
  final DateTime date;
  
  DailyActivity({
    required this.day,
    required this.value,
    required this.date,
  });
}

@HiveType(typeId: 8)
class DailyLearningTime extends HiveObject {
  @HiveField(0)
  final String day;
  
  @HiveField(1)
  final double minutes;
  
  @HiveField(2)
  final DateTime date;
  
  DailyLearningTime({
    required this.day,
    required this.minutes,
    required this.date,
  });
}

@HiveType(typeId: 9)
class SubjectProgress extends HiveObject {
  @HiveField(0)
  final String subject;
  
  @HiveField(1)
  final double progress;
  
  @HiveField(2)
  final double totalLessons;
  
  @HiveField(3)
  final double completedLessons;
  
  SubjectProgress({
    required this.subject,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
  });
}

@HiveType(typeId: 4)
class MoodEntry {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final MoodType mood;
  
  @HiveField(2)
  final int energyLevel; // 1-5 scale
  
  @HiveField(3)
  final int focusLevel; // 1-5 scale
  
  @HiveField(4)
  final String? notes;
  
  @HiveField(5)
  final List<String> activities;

  MoodEntry({
    required this.date,
    required this.mood,
    required this.energyLevel,
    required this.focusLevel,
    this.notes,
    required this.activities,
  });
}

@HiveType(typeId: 5)
enum MoodType {
  @HiveField(0)
  veryHappy,
  @HiveField(1)
  happy,
  @HiveField(2)
  neutral,
  @HiveField(3)
  sad,
  @HiveField(4)
  verySad,
  @HiveField(5)
  excited,
  @HiveField(6)
  calm,
  @HiveField(7)
  anxious,
  @HiveField(8)
  frustrated,
  @HiveField(9)
  proud,
}

@HiveType(typeId: 6)
class Achievement {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String iconPath;
  
  @HiveField(4)
  final AchievementCategory category;
  
  @HiveField(5)
  final DateTime unlockedAt;
  
  @HiveField(6)
  final int points;
  
  @HiveField(7)
  final bool isNew;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.unlockedAt,
    required this.points,
    this.isNew = true,
  });
}

@HiveType(typeId: 7)
enum AchievementCategory {
  @HiveField(0)
  learning,
  @HiveField(1)
  consistency,
  @HiveField(2)
  creativity,
  @HiveField(3)
  social,
  @HiveField(4)
  milestone,
  @HiveField(5)
  special,
}

@HiveType(typeId: 8)
class AIInsight {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String content;
  
  @HiveField(3)
  final InsightType type;
  
  @HiveField(4)
  final DateTime generatedAt;
  
  @HiveField(5)
  final double confidence; // 0.0 to 1.0
  
  @HiveField(6)
  final List<String> recommendations;
  
  @HiveField(7)
  final Map<String, dynamic> metadata;

  AIInsight({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.generatedAt,
    required this.confidence,
    required this.recommendations,
    required this.metadata,
  });
}

@HiveType(typeId: 9)
enum InsightType {
  @HiveField(0)
  learningPattern,
  @HiveField(1)
  moodTrend,
  @HiveField(2)
  performanceAnalysis,
  @HiveField(3)
  recommendation,
  @HiveField(4)
  achievement,
  @HiveField(5)
  warning,
  @HiveField(6)
  celebration,
}

@HiveType(typeId: 10)
class WellbeingMetrics {
  @HiveField(0)
  final double averageMoodScore; // 1-5 scale
  
  @HiveField(1)
  final double averageEnergyLevel;
  
  @HiveField(2)
  final double averageFocusLevel;
  
  @HiveField(3)
  final int totalMoodEntries;
  
  @HiveField(4)
  final DateTime lastMoodEntry;
  
  @HiveField(5)
  final Map<MoodType, int> moodDistribution;

  WellbeingMetrics({
    required this.averageMoodScore,
    required this.averageEnergyLevel,
    required this.averageFocusLevel,
    required this.totalMoodEntries,
    required this.lastMoodEntry,
    required this.moodDistribution,
  });
} 