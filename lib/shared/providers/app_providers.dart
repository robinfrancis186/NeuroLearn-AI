import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/student_profile.dart';
import '../../core/models/story_session.dart';
import '../../core/models/emotional_state.dart';
import '../../core/models/progress_data.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/voice_service.dart';
// import '../../core/services/emotion_service.dart'; // TODO: Implement EmotionService

// Theme providers
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Student profile providers
final currentStudentProvider = StateProvider<StudentProfile?>((ref) => null);

// Story session providers
final currentStorySessionProvider = StateProvider<StorySession?>((ref) => null);
final storyQueueProvider = StateProvider<List<String>>((ref) => []);

// Emotional state providers
final currentEmotionalStateProvider = StateProvider<EmotionalState?>((ref) => null);
final storyMoodProvider = StateProvider<StoryMood>((ref) => StoryMood.neutral);

// Voice and AI service providers
final aiServiceProvider = Provider<AIService>((ref) => AIService.instance);
final voiceServiceProvider = Provider<VoiceService>((ref) => VoiceService.instance);
// final emotionServiceProvider = Provider<EmotionService>((ref) => EmotionService.instance); // TODO: Implement EmotionService

// Communication providers
final currentAACtextProvider = StateProvider<String>((ref) => '');
final speechRecognitionActiveProvider = StateProvider<bool>((ref) => false);

// Gamification providers
final studentProgressProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final unlockedStoriesProvider = StateProvider<List<String>>((ref) => []);
final achievementsProvider = StateProvider<List<String>>((ref) => []);

// Dashboard providers
final parentDashboardDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final teacherDashboardDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// Mood & Wellbeing providers
final moodEntriesProvider = StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>((ref) {
  return MoodEntriesNotifier();
});

final wellbeingMetricsProvider = StateProvider<WellbeingMetrics?>((ref) => null);

final dailyMoodProvider = StateProvider<MoodType?>((ref) => null);

// Achievement providers
final userAchievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});

final achievementCategoriesProvider = StateProvider<Map<AchievementCategory, int>>((ref) => {
  AchievementCategory.learning: 12,
  AchievementCategory.consistency: 8,
  AchievementCategory.creativity: 6,
  AchievementCategory.social: 4,
  AchievementCategory.milestone: 2,
  AchievementCategory.special: 1,
});

// AI Insights providers
final aiInsightsProvider = StateNotifierProvider<AIInsightsNotifier, List<AIInsight>>((ref) {
  return AIInsightsNotifier();
});

final learningPatternsProvider = StateProvider<Map<String, dynamic>>((ref) => {
  'bestLearningTime': '9:00 - 11:00 AM',
  'preferredDuration': '15-20 minutes',
  'learningStyle': 'Visual + Interactive',
  'breakFrequency': 'Every 15 minutes',
  'performanceImprovement': 23.0,
});

final performanceAnalysisProvider = StateProvider<Map<String, double>>((ref) => {
  'visual': 35.0,
  'auditory': 25.0,
  'kinesthetic': 30.0,
  'reading': 10.0,
});

// Settings providers
final accessibilitySettingsProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final learningPreferencesProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// Progress tracking providers
final dailyActivityProvider = StateProvider<List<DailyActivity>>((ref) => [
  DailyActivity(day: 'Monday', value: 2, date: DateTime.now().subtract(const Duration(days: 6))),
  DailyActivity(day: 'Tuesday', value: 3, date: DateTime.now().subtract(const Duration(days: 5))),
  DailyActivity(day: 'Wednesday', value: 1, date: DateTime.now().subtract(const Duration(days: 4))),
  DailyActivity(day: 'Thursday', value: 4, date: DateTime.now().subtract(const Duration(days: 3))),
  DailyActivity(day: 'Friday', value: 2, date: DateTime.now().subtract(const Duration(days: 2))),
  DailyActivity(day: 'Saturday', value: 3, date: DateTime.now().subtract(const Duration(days: 1))),
  DailyActivity(day: 'Sunday', value: 2, date: DateTime.now()),
]);

final dailyLearningTimeProvider = StateProvider<List<DailyLearningTime>>((ref) => [
  DailyLearningTime(day: 'Monday', minutes: 45, date: DateTime.now().subtract(const Duration(days: 6))),
  DailyLearningTime(day: 'Tuesday', minutes: 58, date: DateTime.now().subtract(const Duration(days: 5))),
  DailyLearningTime(day: 'Wednesday', minutes: 60, date: DateTime.now().subtract(const Duration(days: 4))),
  DailyLearningTime(day: 'Thursday', minutes: 30, date: DateTime.now().subtract(const Duration(days: 3))),
  DailyLearningTime(day: 'Friday', minutes: 75, date: DateTime.now().subtract(const Duration(days: 2))),
  DailyLearningTime(day: 'Saturday', minutes: 50, date: DateTime.now().subtract(const Duration(days: 1))),
  DailyLearningTime(day: 'Sunday', minutes: 65, date: DateTime.now()),
]);

// State Notifiers for complex state management
class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  MoodEntriesNotifier() : super(_generateMockMoodEntries());

  void addMoodEntry(MoodEntry entry) {
    state = [entry, ...state];
  }

  void updateMoodEntry(String id, MoodEntry updatedEntry) {
    state = state.map((entry) {
      if (entry.date.toIso8601String() == id) {
        return updatedEntry;
      }
      return entry;
    }).toList();
  }

  void deleteMoodEntry(String id) {
    state = state.where((entry) => entry.date.toIso8601String() != id).toList();
  }

  static List<MoodEntry> _generateMockMoodEntries() {
    final now = DateTime.now();
    return [
      MoodEntry(
        date: now,
        mood: MoodType.happy,
        energyLevel: 4,
        focusLevel: 4,
        notes: 'Had a great learning session!',
        activities: ['Learning', 'Stories'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 1)),
        mood: MoodType.neutral,
        energyLevel: 3,
        focusLevel: 3,
        notes: 'Math was challenging today',
        activities: ['Math', 'Reading'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 2)),
        mood: MoodType.veryHappy,
        energyLevel: 5,
        focusLevel: 4,
        notes: 'Loved the space story!',
        activities: ['Stories', 'Science'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 3)),
        mood: MoodType.calm,
        energyLevel: 4,
        focusLevel: 5,
        notes: 'Feeling focused and peaceful',
        activities: ['Meditation', 'Art'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 4)),
        mood: MoodType.excited,
        energyLevel: 5,
        focusLevel: 3,
        notes: 'Excited about new adventure story!',
        activities: ['Adventure', 'Exploration'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 5)),
        mood: MoodType.happy,
        energyLevel: 4,
        focusLevel: 4,
        notes: 'Great progress in language skills',
        activities: ['Language', 'Communication'],
      ),
      MoodEntry(
        date: now.subtract(const Duration(days: 6)),
        mood: MoodType.proud,
        energyLevel: 4,
        focusLevel: 4,
        notes: 'Completed my first chapter!',
        activities: ['Reading', 'Achievement'],
      ),
    ];
  }
}

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  AchievementsNotifier() : super(_generateMockAchievements());

  void unlockAchievement(Achievement achievement) {
    state = [achievement, ...state];
  }

  void markAsViewed(String achievementId) {
    state = state.map((achievement) {
      if (achievement.id == achievementId) {
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          iconPath: achievement.iconPath,
          category: achievement.category,
          unlockedAt: achievement.unlockedAt,
          points: achievement.points,
          isNew: false,
        );
      }
      return achievement;
    }).toList();
  }

  static List<Achievement> _generateMockAchievements() {
    final now = DateTime.now();
    return [
      Achievement(
        id: 'story_master',
        title: 'Story Master',
        description: 'Completed 10 stories',
        iconPath: '📚',
        category: AchievementCategory.learning,
        unlockedAt: now,
        points: 100,
        isNew: true,
      ),
      Achievement(
        id: 'focus_champion',
        title: 'Focus Champion',
        description: 'Stayed focused for 30 minutes',
        iconPath: '🎯',
        category: AchievementCategory.consistency,
        unlockedAt: now.subtract(const Duration(days: 1)),
        points: 75,
        isNew: false,
      ),
      Achievement(
        id: 'mood_tracker',
        title: 'Mood Tracker',
        description: 'Logged mood for 7 days',
        iconPath: '😊',
        category: AchievementCategory.consistency,
        unlockedAt: now.subtract(const Duration(days: 2)),
        points: 50,
        isNew: false,
      ),
      Achievement(
        id: 'creative_explorer',
        title: 'Creative Explorer',
        description: 'Completed 5 creative activities',
        iconPath: '🎨',
        category: AchievementCategory.creativity,
        unlockedAt: now.subtract(const Duration(days: 3)),
        points: 80,
        isNew: false,
      ),
      Achievement(
        id: 'social_butterfly',
        title: 'Social Butterfly',
        description: 'Engaged in 3 social stories',
        iconPath: '🦋',
        category: AchievementCategory.social,
        unlockedAt: now.subtract(const Duration(days: 4)),
        points: 60,
        isNew: false,
      ),
    ];
  }
}

class AIInsightsNotifier extends StateNotifier<List<AIInsight>> {
  AIInsightsNotifier() : super(_generateMockInsights());

  void addInsight(AIInsight insight) {
    state = [insight, ...state];
  }

  void markInsightAsRead(String insightId) {
    // Could update insight read status if needed
  }

  static List<AIInsight> _generateMockInsights() {
    final now = DateTime.now();
    return [
      AIInsight(
        id: 'learning_pattern_1',
        title: 'Learning Pattern Analysis',
        content: 'Strong visual learning preference detected with 92% confidence. Performance improves significantly when visual elements are included.',
        type: InsightType.learningPattern,
        generatedAt: now,
        confidence: 0.92,
        recommendations: [
          'Include more visual diagrams in lessons',
          'Use interactive charts and graphs',
          'Incorporate visual storytelling elements',
        ],
        metadata: {
          'pattern_type': 'visual_learning',
          'data_points': 47,
          'trend': 'increasing',
        },
      ),
      AIInsight(
        id: 'mood_correlation_1',
        title: 'Mood Correlation Study',
        content: 'Happy mood states correlate with 34% better retention and engagement. Morning sessions show optimal performance.',
        type: InsightType.moodTrend,
        generatedAt: now.subtract(const Duration(days: 1)),
        confidence: 0.87,
        recommendations: [
          'Schedule challenging topics in the morning',
          'Monitor mood before learning sessions',
          'Use mood-adaptive content delivery',
        ],
        metadata: {
          'correlation_strength': 0.78,
          'optimal_time': 'morning',
          'retention_improvement': 34,
        },
      ),
      AIInsight(
        id: 'focus_analysis_1',
        title: 'Focus Duration Analysis',
        content: 'Optimal focus duration identified as 18 minutes with 5-minute breaks. Attention patterns show consistent improvement.',
        type: InsightType.performanceAnalysis,
        generatedAt: now.subtract(const Duration(days: 2)),
        confidence: 0.89,
        recommendations: [
          'Implement 18-minute learning blocks',
          'Schedule 5-minute movement breaks',
          'Use focus reminder notifications',
        ],
        metadata: {
          'optimal_duration': 18,
          'break_duration': 5,
          'improvement_rate': 23,
        },
      ),
    ];
  }
} 