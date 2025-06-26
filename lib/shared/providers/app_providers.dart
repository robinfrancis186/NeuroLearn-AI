import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/student_profile.dart';
import '../../core/models/story_session.dart';
import '../../core/models/emotional_state.dart';
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

// Settings providers
final accessibilitySettingsProvider = StateProvider<AccessibilitySettings>((ref) => AccessibilitySettings());
final voiceSettingsProvider = StateProvider<VoiceSettings>((ref) => VoiceSettings());

// Accessibility settings model
class AccessibilitySettings {
  final bool highContrast;
  final bool dyslexicFont;
  final double fontSize;
  final bool reducedMotion;
  final bool screenReader;
  
  AccessibilitySettings({
    this.highContrast = false,
    this.dyslexicFont = false,
    this.fontSize = 1.0,
    this.reducedMotion = false,
    this.screenReader = false,
  });
  
  AccessibilitySettings copyWith({
    bool? highContrast,
    bool? dyslexicFont,
    double? fontSize,
    bool? reducedMotion,
    bool? screenReader,
  }) {
    return AccessibilitySettings(
      highContrast: highContrast ?? this.highContrast,
      dyslexicFont: dyslexicFont ?? this.dyslexicFont,
      fontSize: fontSize ?? this.fontSize,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      screenReader: screenReader ?? this.screenReader,
    );
  }
}

// Voice settings model
class VoiceSettings {
  final String selectedVoiceId;
  final double speechRate;
  final double pitch;
  final double volume;
  final bool enableVoiceCloning;
  
  VoiceSettings({
    this.selectedVoiceId = 'default',
    this.speechRate = 0.5,
    this.pitch = 1.0,
    this.volume = 0.8,
    this.enableVoiceCloning = false,
  });
  
  VoiceSettings copyWith({
    String? selectedVoiceId,
    double? speechRate,
    double? pitch,
    double? volume,
    bool? enableVoiceCloning,
  }) {
    return VoiceSettings(
      selectedVoiceId: selectedVoiceId ?? this.selectedVoiceId,
      speechRate: speechRate ?? this.speechRate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      enableVoiceCloning: enableVoiceCloning ?? this.enableVoiceCloning,
    );
  }
} 