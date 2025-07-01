import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 6)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String question;
  
  @HiveField(2)
  final String answer;
  
  @HiveField(3)
  final FlashcardCategory category;
  
  @HiveField(4)
  final FlashcardDifficulty difficulty;
  
  @HiveField(5)
  final String? hint;
  
  @HiveField(6)
  final String? image;
  
  @HiveField(7)
  final List<String> tags;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final String? memoryContext; // Connection to personal memory
  
  @HiveField(10)
  final bool isPersonalized; // Generated from family memories

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.difficulty,
    this.hint,
    this.image,
    this.tags = const [],
    required this.createdAt,
    this.memoryContext,
    this.isPersonalized = false,
  });
}

@HiveType(typeId: 7)
enum FlashcardCategory {
  @HiveField(0)
  math,
  @HiveField(1)
  reading,
  @HiveField(2)
  science,
  @HiveField(3)
  socialSkills,
  @HiveField(4)
  vocabulary,
  @HiveField(5)
  memory,
  @HiveField(6)
  problemSolving,
  @HiveField(7)
  emotions,
}

@HiveType(typeId: 8)
enum FlashcardDifficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
}

@HiveType(typeId: 9)
class FlashcardSession extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime startTime;
  
  @HiveField(2)
  final DateTime? endTime;
  
  @HiveField(3)
  final List<FlashcardAttempt> attempts;
  
  @HiveField(4)
  final FlashcardCategory? category;
  
  @HiveField(5)
  final int totalCards;
  
  @HiveField(6)
  final int correctAnswers;

  FlashcardSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.attempts = const [],
    this.category,
    required this.totalCards,
    this.correctAnswers = 0,
  });

  double get accuracy => totalCards > 0 ? correctAnswers / totalCards : 0.0;
  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);
}

@HiveType(typeId: 10)
class FlashcardAttempt extends HiveObject {
  @HiveField(0)
  final String flashcardId;
  
  @HiveField(1)
  final String userAnswer;
  
  @HiveField(2)
  final bool isCorrect;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final Duration responseTime;
  
  @HiveField(5)
  final bool usedHint;

  FlashcardAttempt({
    required this.flashcardId,
    required this.userAnswer,
    required this.isCorrect,
    required this.timestamp,
    required this.responseTime,
    this.usedHint = false,
  });
}

@HiveType(typeId: 11)
class FlashcardProgress extends HiveObject {
  @HiveField(0)
  final String flashcardId;
  
  @HiveField(1)
  final int timesShown;
  
  @HiveField(2)
  final int timesCorrect;
  
  @HiveField(3)
  final DateTime lastShown;
  
  @HiveField(4)
  final DateTime? nextReview;
  
  @HiveField(5)
  final double masteryLevel; // 0.0 to 1.0

  FlashcardProgress({
    required this.flashcardId,
    this.timesShown = 0,
    this.timesCorrect = 0,
    required this.lastShown,
    this.nextReview,
    this.masteryLevel = 0.0,
  });

  double get accuracy => timesShown > 0 ? timesCorrect / timesShown : 0.0;
  bool get needsReview => nextReview == null || DateTime.now().isAfter(nextReview!);
} 