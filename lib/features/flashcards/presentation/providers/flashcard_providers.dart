import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/flashcard.dart';

const _uuid = Uuid();

// Main flashcard providers
final flashcardsProvider = StateNotifierProvider<FlashcardsNotifier, List<Flashcard>>(
  (ref) => FlashcardsNotifier(),
);

final flashcardSessionsProvider = StateNotifierProvider<FlashcardSessionsNotifier, List<FlashcardSession>>(
  (ref) => FlashcardSessionsNotifier(),
);

final flashcardProgressProvider = StateNotifierProvider<FlashcardProgressNotifier, List<FlashcardProgress>>(
  (ref) => FlashcardProgressNotifier(),
);

// Current session provider
final currentSessionProvider = StateProvider<FlashcardSession?>((ref) => null);

// Session state provider
final sessionStateProvider = StateNotifierProvider<SessionStateNotifier, SessionState>(
  (ref) => SessionStateNotifier(),
);

class SessionState {
  final List<Flashcard> cards;
  final int currentIndex;
  final List<FlashcardAttempt> attempts;
  final bool isFlipped;
  final DateTime? startTime;

  SessionState({
    this.cards = const [],
    this.currentIndex = 0,
    this.attempts = const [],
    this.isFlipped = false,
    this.startTime,
  });

  SessionState copyWith({
    List<Flashcard>? cards,
    int? currentIndex,
    List<FlashcardAttempt>? attempts,
    bool? isFlipped,
    DateTime? startTime,
  }) {
    return SessionState(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      attempts: attempts ?? this.attempts,
      isFlipped: isFlipped ?? this.isFlipped,
      startTime: startTime ?? this.startTime,
    );
  }

  Flashcard? get currentCard => currentIndex < cards.length ? cards[currentIndex] : null;
  bool get isLastCard => currentIndex >= cards.length - 1;
  bool get hasNextCard => currentIndex < cards.length - 1;
  int get correctAnswers => attempts.where((a) => a.isCorrect).length;
  double get accuracy => attempts.isNotEmpty ? correctAnswers / attempts.length : 0.0;
}

class SessionStateNotifier extends StateNotifier<SessionState> {
  SessionStateNotifier() : super(SessionState());

  void startSession(List<Flashcard> cards) {
    state = SessionState(
      cards: cards,
      currentIndex: 0,
      attempts: [],
      isFlipped: false,
      startTime: DateTime.now(),
    );
  }

  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  void nextCard() {
    if (state.hasNextCard) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isFlipped: false,
      );
    }
  }

  void previousCard() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        isFlipped: false,
      );
    }
  }

  void submitAnswer(String answer, bool isCorrect, {bool usedHint = false}) {
    final attempt = FlashcardAttempt(
      flashcardId: state.currentCard!.id,
      userAnswer: answer,
      isCorrect: isCorrect,
      timestamp: DateTime.now(),
      responseTime: DateTime.now().difference(state.startTime!),
      usedHint: usedHint,
    );

    state = state.copyWith(
      attempts: [...state.attempts, attempt],
    );
  }

  void resetSession() {
    state = SessionState();
  }
}

class FlashcardsNotifier extends StateNotifier<List<Flashcard>> {
  FlashcardsNotifier() : super([]);

  void initializeSampleFlashcards() {
    final sampleCards = _generateSampleFlashcards();
    state = sampleCards;
  }

  void addFlashcard(Flashcard flashcard) {
    state = [...state, flashcard];
  }

  void removeFlashcard(String id) {
    state = state.where((card) => card.id != id).toList();
  }

  void updateFlashcard(Flashcard updatedCard) {
    state = [
      for (final card in state)
        if (card.id == updatedCard.id) updatedCard else card,
    ];
  }

  void generateMemoryFlashcards() {
    final memoryCards = _generateMemoryBasedFlashcards();
    state = [...state, ...memoryCards];
  }

  List<Flashcard> _generateSampleFlashcards() {
    return [
      // Math cards
      Flashcard(
        id: _uuid.v4(),
        question: 'What is 2 + 3?',
        answer: '5',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Count on your fingers',
        tags: ['addition', 'basic'],
        createdAt: DateTime.now(),
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'What is 7 × 8?',
        answer: '56',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Think of 7 × 7 + 7',
        tags: ['multiplication', 'times table'],
        createdAt: DateTime.now(),
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'What is the square root of 64?',
        answer: '8',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.hard,
        hint: 'What number times itself equals 64?',
        tags: ['square root', 'advanced'],
        createdAt: DateTime.now(),
      ),

      // Reading cards
      Flashcard(
        id: _uuid.v4(),
        question: 'What does the word "happy" mean?',
        answer: 'Feeling joy or pleasure',
        category: FlashcardCategory.reading,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Think about how you feel when you smile',
        tags: ['vocabulary', 'emotions'],
        createdAt: DateTime.now(),
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'What is a synonym for "big"?',
        answer: 'Large, huge, enormous',
        category: FlashcardCategory.reading,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Words that mean the same thing',
        tags: ['synonyms', 'vocabulary'],
        createdAt: DateTime.now(),
      ),

      // Science cards
      Flashcard(
        id: _uuid.v4(),
        question: 'What do plants need to grow?',
        answer: 'Water, sunlight, air, and nutrients',
        category: FlashcardCategory.science,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Think about what you would need to stay healthy',
        tags: ['plants', 'biology'],
        createdAt: DateTime.now(),
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'How many planets are in our solar system?',
        answer: '8',
        category: FlashcardCategory.science,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Pluto is no longer considered a planet',
        tags: ['space', 'planets'],
        createdAt: DateTime.now(),
      ),

      // Social Skills cards
      Flashcard(
        id: _uuid.v4(),
        question: 'What should you say when someone gives you something?',
        answer: 'Thank you',
        category: FlashcardCategory.socialSkills,
        difficulty: FlashcardDifficulty.easy,
        hint: 'A polite response when receiving',
        tags: ['manners', 'politeness'],
        createdAt: DateTime.now(),
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'How do you show you\'re listening to someone?',
        answer: 'Look at them, nod, and ask questions',
        category: FlashcardCategory.socialSkills,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Use your eyes and body language',
        tags: ['listening', 'communication'],
        createdAt: DateTime.now(),
      ),

      // Emotions cards
      Flashcard(
        id: _uuid.v4(),
        question: 'How can you calm down when you feel angry?',
        answer: 'Take deep breaths, count to 10, or talk to someone',
        category: FlashcardCategory.emotions,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Think about ways to relax your body and mind',
        tags: ['anger management', 'coping'],
        createdAt: DateTime.now(),
      ),
    ];
  }

  List<Flashcard> _generateMemoryBasedFlashcards() {
    // These are personalized flashcards based on family memories
    return [
      Flashcard(
        id: _uuid.v4(),
        question: 'If Dad has 3 cookies and Mom gives him 2 more, how many cookies does Dad have?',
        answer: '5',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Think about Dad\'s favorite snacks',
        tags: ['family', 'addition', 'cookies'],
        createdAt: DateTime.now(),
        memoryContext: 'From the story about baking cookies with family',
        isPersonalized: true,
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'When Grandma visits, what do we do to show we care?',
        answer: 'We hug her, listen to her stories, and spend time together',
        category: FlashcardCategory.socialSkills,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Think about how you make Grandma feel special',
        tags: ['family', 'love', 'respect'],
        createdAt: DateTime.now(),
        memoryContext: 'From memories of Grandma\'s visits',
        isPersonalized: true,
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'At the park with Emma, how many swings were empty if there were 6 swings total and 4 were being used?',
        answer: '2',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Take away the used swings from the total',
        tags: ['subtraction', 'park', 'Emma'],
        createdAt: DateTime.now(),
        memoryContext: 'From the park adventure story',
        isPersonalized: true,
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'What did we learn about sharing when playing with toys at home?',
        answer: 'Sharing makes everyone happy and we can play together',
        category: FlashcardCategory.socialSkills,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Remember what happened when everyone got a turn',
        tags: ['sharing', 'home', 'toys'],
        createdAt: DateTime.now(),
        memoryContext: 'From the toy sharing memory',
        isPersonalized: true,
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'In the kitchen with Mom, how many ingredients did we use to make pancakes?',
        answer: '5 (flour, milk, eggs, sugar, and baking powder)',
        category: FlashcardCategory.math,
        difficulty: FlashcardDifficulty.medium,
        hint: 'Count each thing we put in the bowl',
        tags: ['counting', 'kitchen', 'cooking'],
        createdAt: DateTime.now(),
        memoryContext: 'From the pancake cooking memory',
        isPersonalized: true,
      ),
      Flashcard(
        id: _uuid.v4(),
        question: 'How did you feel when your pet came to comfort you?',
        answer: 'Happy, loved, and not alone anymore',
        category: FlashcardCategory.emotions,
        difficulty: FlashcardDifficulty.easy,
        hint: 'Think about the warm feeling inside',
        tags: ['emotions', 'pets', 'comfort'],
        createdAt: DateTime.now(),
        memoryContext: 'From the pet comfort memory',
        isPersonalized: true,
      ),
    ];
  }
}

class FlashcardSessionsNotifier extends StateNotifier<List<FlashcardSession>> {
  FlashcardSessionsNotifier() : super(_generateSampleSessions());

  void addSession(FlashcardSession session) {
    state = [session, ...state];
  }

  void updateSession(FlashcardSession updatedSession) {
    state = [
      for (final session in state)
        if (session.id == updatedSession.id) updatedSession else session,
    ];
  }

  static List<FlashcardSession> _generateSampleSessions() {
    return [
      FlashcardSession(
        id: _uuid.v4(),
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        totalCards: 10,
        correctAnswers: 8,
        category: FlashcardCategory.math,
      ),
      FlashcardSession(
        id: _uuid.v4(),
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().subtract(const Duration(days: 1, hours: -1)),
        totalCards: 15,
        correctAnswers: 12,
        category: FlashcardCategory.reading,
      ),
      FlashcardSession(
        id: _uuid.v4(),
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 2, hours: -1)),
        totalCards: 8,
        correctAnswers: 6,
        category: FlashcardCategory.socialSkills,
      ),
    ];
  }
}

class FlashcardProgressNotifier extends StateNotifier<List<FlashcardProgress>> {
  FlashcardProgressNotifier() : super(_generateSampleProgress());

  void updateProgress(String flashcardId, bool wasCorrect) {
    final existingIndex = state.indexWhere((p) => p.flashcardId == flashcardId);
    
    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = FlashcardProgress(
        flashcardId: flashcardId,
        timesShown: existing.timesShown + 1,
        timesCorrect: existing.timesCorrect + (wasCorrect ? 1 : 0),
        lastShown: DateTime.now(),
        nextReview: _calculateNextReview(existing.masteryLevel, wasCorrect),
        masteryLevel: _calculateMasteryLevel(existing, wasCorrect),
      );
      
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex) updated else state[i],
      ];
    } else {
      final newProgress = FlashcardProgress(
        flashcardId: flashcardId,
        timesShown: 1,
        timesCorrect: wasCorrect ? 1 : 0,
        lastShown: DateTime.now(),
        nextReview: _calculateNextReview(0.0, wasCorrect),
        masteryLevel: wasCorrect ? 0.2 : 0.1,
      );
      
      state = [...state, newProgress];
    }
  }

  DateTime _calculateNextReview(double currentMastery, bool wasCorrect) {
    // Spaced repetition algorithm
    int daysToAdd;
    if (wasCorrect) {
      if (currentMastery >= 0.8) {
        daysToAdd = 7; // Weekly review for mastered cards
      } else if (currentMastery >= 0.5) {
        daysToAdd = 3; // 3-day review for intermediate
      } else {
        daysToAdd = 1; // Daily review for new cards
      }
    } else {
      daysToAdd = 1; // Review again tomorrow if incorrect
    }
    
    return DateTime.now().add(Duration(days: daysToAdd));
  }

  double _calculateMasteryLevel(FlashcardProgress existing, bool wasCorrect) {
    final newAccuracy = (existing.timesCorrect + (wasCorrect ? 1 : 0)) / (existing.timesShown + 1);
    
    // Increase mastery more slowly, require consistency
    if (wasCorrect) {
      return (existing.masteryLevel + newAccuracy * 0.1).clamp(0.0, 1.0);
    } else {
      return (existing.masteryLevel - 0.1).clamp(0.0, 1.0);
    }
  }

  static List<FlashcardProgress> _generateSampleProgress() {
    return [
      FlashcardProgress(
        flashcardId: 'sample-1',
        timesShown: 5,
        timesCorrect: 4,
        lastShown: DateTime.now().subtract(const Duration(days: 1)),
        nextReview: DateTime.now().add(const Duration(days: 2)),
        masteryLevel: 0.6,
      ),
      FlashcardProgress(
        flashcardId: 'sample-2',
        timesShown: 8,
        timesCorrect: 7,
        lastShown: DateTime.now().subtract(const Duration(hours: 3)),
        nextReview: DateTime.now().add(const Duration(days: 5)),
        masteryLevel: 0.85,
      ),
      FlashcardProgress(
        flashcardId: 'sample-3',
        timesShown: 3,
        timesCorrect: 1,
        lastShown: DateTime.now().subtract(const Duration(hours: 6)),
        nextReview: DateTime.now(),
        masteryLevel: 0.2,
      ),
    ];
  }
} 