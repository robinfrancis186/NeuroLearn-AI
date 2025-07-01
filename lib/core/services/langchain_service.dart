import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_profile.dart';
import '../models/story_session.dart';
import '../models/progress_data.dart';
import '../models/emotional_state.dart';
import '../config/app_config.dart';

class LangChainService {
  static LangChainService? _instance;
  static LangChainService get instance => _instance!;
  
  late String _baseUrl;
  bool _isInitialized = false;
  
  static Future<void> initialize() async {
    _instance = LangChainService._();
    await _instance!._init();
  }
  
  LangChainService._();
  
  Future<void> _init() async {
    // Configure backend URL - Updated for Mistral 7B backend
    _baseUrl = 'http://127.0.0.1:8002';  // Updated to match our running server
    _isInitialized = true;
  }
  
  /// Mistral 7B Story Generation - Updated for new backend structure
  Future<LangChainStoryResponse> generatePersonalizedStory({
    required StudentProfile student,
    required String learningObjective,
    required String subject,
    required StoryMood mood,
    String? previousStoryContext,
    Map<String, String>? memoryContext,
  }) async {
    if (!_isInitialized) throw Exception('LangChainService not initialized');
    
    try {
      // Updated request structure to match our new backend
      final requestData = {
        'student_name': student.name,
        'age': student.age,
        'neurodivergent_traits': student.cognitiveProfile.neurodivergentTraits,
        'learning_style': student.cognitiveProfile.primaryLearningStyle.toString().split('.').last,
        'attention_span': student.cognitiveProfile.attentionProfile.attentionSpanMinutes.toString(),
        'communication_needs': _formatCommunicationNeeds(student.cognitiveProfile.communicationNeeds),
        'sensory_preferences': _formatSensoryPreferences(student.cognitiveProfile.sensoryPreferences),
        'favorite_characters': student.favoriteCharacters,
        'preferred_topics': student.preferredTopics,
        'learning_objective': learningObjective,
        'subject': subject,
        'mood': mood.toString().split('.').last,
        'previous_context': previousStoryContext ?? '',
        'memory_context': memoryContext?.toString() ?? '',
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/generate-story'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LangChainStoryResponse.fromJson(data);
      } else {
        throw LangChainException('Story generation failed: ${response.statusCode} - ${response.body}');
      }
      
    } catch (e) {
      throw LangChainException('Failed to connect to Mistral backend: $e');
    }
  }
  
  /// Mistral 7B Progress Summary - Updated for new backend structure
  Future<LangChainProgressSummary> generateProgressSummary({
    required StudentProfile student,
    required List<Map<String, dynamic>> progressData,
    required List<Map<String, dynamic>> learningInsights,
    String timePeriod = 'Q1 2024',
    Map<String, dynamic>? visualProgressData,
  }) async {
    if (!_isInitialized) throw Exception('LangChainService not initialized');
    
    try {
      // Updated request structure for new backend
      final requestData = {
        'student_name': student.name,
        'time_period': timePeriod,
        'progress_data': progressData,
        'learning_insights': learningInsights,
        'visual_progress_data': visualProgressData ?? {},
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/generate-progress-summary'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LangChainProgressSummary.fromJson(data);
      } else {
        throw LangChainException('Progress summary generation failed: ${response.statusCode} - ${response.body}');
      }
      
    } catch (e) {
      throw LangChainException('Failed to connect to Mistral backend: $e');
    }
  }
  
  /// Health check for the Mistral backend
  Future<bool> isBackendHealthy() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Helper methods for formatting data
  
  String _formatCommunicationNeeds(CommunicationNeeds needs) {
    List<String> formatted = [];
    if (needs.prefersShorterSentences) formatted.add('prefers shorter sentences');
    if (needs.needsVisualSupports) formatted.add('needs visual supports');
    if (needs.usesAAC) formatted.add('uses AAC');
    if (needs.needsRepetition) formatted.add('needs repetition');
    if (needs.communicationMethods.isNotEmpty) formatted.add('methods: ${needs.communicationMethods.join(", ")}');
    return formatted.join('; ');
  }
  
  String _formatSensoryPreferences(SensoryPreferences prefs) {
    List<String> formatted = [];
    if (prefs.auditorySensitivity) formatted.add('auditory sensitive');
    if (prefs.visualSensitivity) formatted.add('visual sensitive');
    if (prefs.tactileSensitivity) formatted.add('tactile sensitive');
    formatted.add('volume: ${prefs.preferredVolume}');
    if (prefs.reducedAnimations) formatted.add('reduced animations');
    if (prefs.highContrast) formatted.add('high contrast');
    return formatted.join('; ');
  }
  
  // Private helper methods for data conversion
  
  Map<String, dynamic> _convertStudentProfile(StudentProfile student) {
    return {
      'id': student.id,
      'name': student.name,
      'age': student.age,
      'cognitive_profile': {
        'neurodivergent_traits': student.cognitiveProfile.neurodivergentTraits,
        'primary_learning_style': student.cognitiveProfile.primaryLearningStyle.toString().split('.').last,
        'attention_profile': {
          'attention_span_minutes': student.cognitiveProfile.attentionProfile.attentionSpanMinutes,
          'needs_breaks': student.cognitiveProfile.attentionProfile.needsBreaks,
          'break_interval_minutes': student.cognitiveProfile.attentionProfile.breakIntervalMinutes,
          'distraction_triggers': student.cognitiveProfile.attentionProfile.distractionTriggers,
        },
        'sensory_preferences': {
          'auditory_sensitivity': student.cognitiveProfile.sensoryPreferences.auditorySensitivity,
          'visual_sensitivity': student.cognitiveProfile.sensoryPreferences.visualSensitivity,
          'tactile_sensitivity': student.cognitiveProfile.sensoryPreferences.tactileSensitivity,
          'preferred_volume': student.cognitiveProfile.sensoryPreferences.preferredVolume,
        },
        'communication_needs': {
          'prefers_shorter_sentences': student.cognitiveProfile.communicationNeeds.prefersShorterSentences,
          'needs_visual_supports': student.cognitiveProfile.communicationNeeds.needsVisualSupports,
          'uses_aac': student.cognitiveProfile.communicationNeeds.usesAAC,
          'communication_methods': student.cognitiveProfile.communicationNeeds.communicationMethods,
        },
        'skill_levels': student.cognitiveProfile.skillLevels,
        'support_strategies': student.cognitiveProfile.supportStrategies,
      },
      'favorite_characters': student.favoriteCharacters,
      'preferred_topics': student.preferredTopics,
      'learning_progress': student.learningProgress,
    };
  }
  
  Map<String, dynamic> _convertIEPGoal(IEPGoal goal) {
    return {
      'id': goal.id,
      'description': goal.description,
      'target_criteria': goal.targetCriteria,
      'current_progress': goal.currentProgress,
      'deadline': goal.deadline,
      'category': goal.category,
    };
  }
  
  Map<String, dynamic> _convertProgressData(ProgressData data) {
    return {
      'session_count': data.sessionCount,
      'total_time_minutes': data.totalTimeMinutes,
      'comprehension_scores': data.comprehensionScores,
      'engagement_scores': data.engagementScores,
      'mood_trends': data.moodTrends,
      'achievements': data.achievements,
      'areas_of_strength': data.areasOfStrength,
      'areas_needing_support': data.areasNeedingSupport,
    };
  }
  
  Map<String, dynamic> _convertParentInput(ParentInput input) {
    return {
      'observations': input.observations,
      'concerns': input.concerns,
      'celebrations': input.celebrations,
      'home_activities': input.homeActivities,
      'questions': input.questions,
    };
  }
}

// Response models for LangChain integration

class LangChainStoryResponse {
  final String title;
  final String content;
  final List<String> characters;
  final List<String> learningPoints;
  final List<InteractionPoint> interactionPoints;
  final List<String> vocabularyWords;
  final List<String> comprehensionQuestions;
  final String adaptationNotes;
  final int estimatedDurationMinutes;
  final String difficultyLevel;
  
  LangChainStoryResponse({
    required this.title,
    required this.content,
    required this.characters,
    required this.learningPoints,
    required this.interactionPoints,
    required this.vocabularyWords,
    required this.comprehensionQuestions,
    required this.adaptationNotes,
    required this.estimatedDurationMinutes,
    required this.difficultyLevel,
  });
  
  factory LangChainStoryResponse.fromJson(Map<String, dynamic> json) {
    return LangChainStoryResponse(
      title: json['title'] ?? 'Learning Story',
      content: json['content'] ?? '',
      characters: List<String>.from(json['characters'] ?? []),
      learningPoints: List<String>.from(json['learning_points'] ?? []),
      interactionPoints: (json['interaction_points'] as List<dynamic>?)
          ?.map((item) => InteractionPoint.fromJson(item))
          .toList() ?? [],
      vocabularyWords: List<String>.from(json['vocabulary_words'] ?? []),
      comprehensionQuestions: List<String>.from(json['comprehension_questions'] ?? []),
      adaptationNotes: json['adaptation_notes'] ?? '',
      estimatedDurationMinutes: json['estimated_duration_minutes'] ?? 15,
      difficultyLevel: json['difficulty_level'] ?? 'beginner',
    );
  }
}

class InteractionPoint {
  final String type;
  final String prompt;
  final List<String> expectedResponses;
  
  InteractionPoint({
    required this.type,
    required this.prompt,
    required this.expectedResponses,
  });
  
  factory InteractionPoint.fromJson(Map<String, dynamic> json) {
    return InteractionPoint(
      type: json['type'] ?? 'question',
      prompt: json['prompt'] ?? '',
      expectedResponses: List<String>.from(json['expected_responses'] ?? []),
    );
  }
}

class LangChainProgressSummary {
  final String studentName;
  final String timePeriod;
  final String overview;
  final double overallProgressScore;
  final List<IEPGoalProgress> iepGoalProgress;
  final List<LearningInsight> insights;
  final String parentCollaborationSummary;
  final List<String> celebrationHighlights;
  final List<String> areasForFocus;
  final List<String> recommendedHomeActivities;
  final List<String> nextMeetingTalkingPoints;
  final Map<String, dynamic>? visualData;
  
  LangChainProgressSummary({
    required this.studentName,
    required this.timePeriod,
    required this.overview,
    required this.overallProgressScore,
    required this.iepGoalProgress,
    required this.insights,
    required this.parentCollaborationSummary,
    required this.celebrationHighlights,
    required this.areasForFocus,
    required this.recommendedHomeActivities,
    required this.nextMeetingTalkingPoints,
    this.visualData,
  });
  
  factory LangChainProgressSummary.fromJson(Map<String, dynamic> json) {
    return LangChainProgressSummary(
      studentName: json['student_name'] ?? 'Student',
      timePeriod: json['time_period'] ?? 'Report',
      overview: json['overview'] ?? '',
      overallProgressScore: (json['overall_progress_score'] ?? 0.0).toDouble(),
      iepGoalProgress: (json['iep_goal_progress'] as List<dynamic>?)
          ?.map((item) => IEPGoalProgress.fromJson(item))
          .toList() ?? [],
      insights: (json['insights'] as List<dynamic>?)
          ?.map((item) => LearningInsight.fromJson(item))
          .toList() ?? [],
      parentCollaborationSummary: json['parent_collaboration_summary'] ?? '',
      celebrationHighlights: List<String>.from(json['celebration_highlights'] ?? []),
      areasForFocus: List<String>.from(json['areas_for_focus'] ?? []),
      recommendedHomeActivities: List<String>.from(json['recommended_home_activities'] ?? []),
      nextMeetingTalkingPoints: List<String>.from(json['next_meeting_talking_points'] ?? []),
      visualData: json['visual_data'] != null ? Map<String, dynamic>.from(json['visual_data']) : null,
    );
  }
}

class IEPGoalProgress {
  final String goalId;
  final String goalDescription;
  final double currentProgress;
  final double progressChange;
  final String status;
  final List<String> evidence;
  final List<String> nextSteps;
  
  IEPGoalProgress({
    required this.goalId,
    required this.goalDescription,
    required this.currentProgress,
    required this.progressChange,
    required this.status,
    required this.evidence,
    required this.nextSteps,
  });
  
  factory IEPGoalProgress.fromJson(Map<String, dynamic> json) {
    return IEPGoalProgress(
      goalId: json['goal_id'] ?? '',
      goalDescription: json['goal_description'] ?? '',
      currentProgress: (json['current_progress'] ?? 0.0).toDouble(),
      progressChange: (json['progress_change'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'unknown',
      evidence: List<String>.from(json['evidence'] ?? []),
      nextSteps: List<String>.from(json['next_steps'] ?? []),
    );
  }
}

class LearningInsight {
  final String category;
  final String insight;
  final String supportingData;
  final String recommendation;
  final String priority;
  
  LearningInsight({
    required this.category,
    required this.insight,
    required this.supportingData,
    required this.recommendation,
    required this.priority,
  });
  
  factory LearningInsight.fromJson(Map<String, dynamic> json) {
    return LearningInsight(
      category: json['category'] ?? '',
      insight: json['insight'] ?? '',
      supportingData: json['supporting_data'] ?? '',
      recommendation: json['recommendation'] ?? '',
      priority: json['priority'] ?? 'medium',
    );
  }
}

// Supporting models

class IEPGoal {
  final String id;
  final String description;
  final String targetCriteria;
  final double currentProgress;
  final String deadline;
  final String category;
  
  IEPGoal({
    required this.id,
    required this.description,
    required this.targetCriteria,
    required this.currentProgress,
    required this.deadline,
    required this.category,
  });
}

class ProgressData {
  final int sessionCount;
  final int totalTimeMinutes;
  final List<double> comprehensionScores;
  final List<double> engagementScores;
  final List<String> moodTrends;
  final List<String> achievements;
  final List<String> areasOfStrength;
  final List<String> areasNeedingSupport;
  
  ProgressData({
    required this.sessionCount,
    required this.totalTimeMinutes,
    required this.comprehensionScores,
    required this.engagementScores,
    required this.moodTrends,
    required this.achievements,
    required this.areasOfStrength,
    required this.areasNeedingSupport,
  });
}

class ParentInput {
  final String observations;
  final List<String> concerns;
  final List<String> celebrations;
  final List<String> homeActivities;
  final List<String> questions;
  
  ParentInput({
    required this.observations,
    required this.concerns,
    required this.celebrations,
    required this.homeActivities,
    required this.questions,
  });
}

class LangChainException implements Exception {
  final String message;
  LangChainException(this.message);
  
  @override
  String toString() => 'LangChainException: $message';
} 