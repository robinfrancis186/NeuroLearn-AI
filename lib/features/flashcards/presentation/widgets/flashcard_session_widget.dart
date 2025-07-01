import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../core/models/flashcard.dart';
import '../providers/flashcard_providers.dart';
import 'flashcard_widget.dart';

class FlashcardSessionWidget extends ConsumerStatefulWidget {
  final List<Flashcard>? initialCards;
  final String? sessionType;

  const FlashcardSessionWidget({
    super.key,
    this.initialCards,
    this.sessionType,
  });

  @override
  ConsumerState<FlashcardSessionWidget> createState() => _FlashcardSessionWidgetState();
}

class _FlashcardSessionWidgetState extends ConsumerState<FlashcardSessionWidget> {
  bool _isSessionStarted = false;
  bool _showAnswer = false;
  String _userAnswer = '';
  final TextEditingController _answerController = TextEditingController();
  bool _usedHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _initializeSession() {
    if (widget.initialCards != null && widget.initialCards!.isNotEmpty) {
      ref.read(sessionStateProvider.notifier).startSession(widget.initialCards!);
      setState(() {
        _isSessionStarted = true;
      });
    } else {
      _showCardSelectionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionStateProvider);

    if (!_isSessionStarted) {
      return _buildSessionSetup();
    }

    if (sessionState.currentCard == null) {
      return _buildSessionComplete();
    }

    return Scaffold(
      backgroundColor: AppTheme.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.sessionType ?? 'Flashcard Study',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.highContrastDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.highContrastDark),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: AppTheme.highContrastDark),
            onPressed: _showAnswer ? null : _showHint,
            tooltip: 'Show Hint',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(sessionState),
          
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Session stats
                  _buildSessionStats(sessionState),
                  
                  const SizedBox(height: 20),
                  
                  // Flashcard
                  Expanded(
                    child: Center(
                      child: FlashcardWidget(
                        flashcard: sessionState.currentCard!,
                        showAnswer: _showAnswer,
                        isInteractive: false,
                        onTap: () => setState(() => _showAnswer = !_showAnswer),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Answer input and controls
                  if (!_showAnswer) ...[
                    _buildAnswerInput(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ] else ...[
                    _buildAnswerFeedback(sessionState),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSetup() {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Study Session'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 24),
              Text(
                'Ready to Study?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select flashcards to start your learning session',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _showCardSelectionDialog,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Choose Cards'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionComplete() {
    final sessionState = ref.watch(sessionStateProvider);
    final accuracy = sessionState.accuracy;
    final correctAnswers = sessionState.correctAnswers;
    final totalCards = sessionState.cards.length;

    return Scaffold(
      backgroundColor: AppTheme.lightBlue.withOpacity(0.1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedCard(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        accuracy >= 0.8 ? Icons.celebration : Icons.thumb_up,
                        size: 80,
                        color: accuracy >= 0.8 ? Colors.amber : AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Session Complete!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You got $correctAnswers out of $totalCards correct',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(accuracy * 100).toInt()}% accuracy',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _getAccuracyColor(accuracy),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back to Library'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _restartSession,
                              child: const Text('Study Again'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().scale(duration: 600.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(SessionState sessionState) {
    final progress = sessionState.cards.isNotEmpty 
        ? (sessionState.currentIndex + 1) / sessionState.cards.length
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${sessionState.currentIndex + 1} of ${sessionState.cards.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${sessionState.correctAnswers}/${sessionState.attempts.length} correct',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.lightGray,
            valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats(SessionState sessionState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          'Cards Left',
          '${sessionState.cards.length - sessionState.currentIndex - 1}',
          Icons.quiz,
          Colors.blue,
        ),
        _buildStatItem(
          'Correct',
          '${sessionState.correctAnswers}',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatItem(
          'Accuracy',
          '${(sessionState.accuracy * 100).toInt()}%',
          Icons.trending_up,
          _getAccuracyColor(sessionState.accuracy),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Answer:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Type your answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
              ),
              onChanged: (value) => setState(() => _userAnswer = value),
              onSubmitted: (_) => _submitAnswer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _userAnswer.trim().isEmpty ? null : _submitAnswer,
            icon: const Icon(Icons.send),
            label: const Text('Submit Answer'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _showAnswer = true),
            icon: const Icon(Icons.visibility),
            label: const Text('Show Answer'),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerFeedback(SessionState sessionState) {
    final currentCard = sessionState.currentCard!;
    final isLastCard = sessionState.isLastCard;

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            if (_userAnswer.isNotEmpty) ...[
              Text(
                'Your Answer: $_userAnswer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            Text(
              'Correct Answer: ${currentCard.answer}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'How did you do?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _markAnswer(false),
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text('Incorrect'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAnswer(true),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Correct'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            
            if (isLastCard) ...[
              const SizedBox(height: 12),
              Text(
                'This is the last card!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCardSelectionDialog() {
    final flashcards = ref.read(flashcardsProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Study Cards'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              Text(
                'Choose how many cards to study:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildQuickOption('Quick Review', '5 cards', 5, flashcards),
                    _buildQuickOption('Short Session', '10 cards', 10, flashcards),
                    _buildQuickOption('Medium Session', '15 cards', 15, flashcards),
                    _buildQuickOption('Long Session', '20 cards', 20, flashcards),
                    _buildQuickOption('All Cards', '${flashcards.length} cards', flashcards.length, flashcards),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOption(String title, String subtitle, int count, List<Flashcard> allCards) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);
        final cards = allCards.take(count).toList();
        if (cards.isNotEmpty) {
          ref.read(sessionStateProvider.notifier).startSession(cards);
          setState(() {
            _isSessionStarted = true;
          });
        }
      },
    );
  }

  void _showHint() {
    final currentCard = ref.read(sessionStateProvider).currentCard;
    if (currentCard?.hint != null) {
      setState(() {
        _usedHint = true;
      });
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber),
              const SizedBox(width: 8),
              const Text('Hint'),
            ],
          ),
          content: Text(currentCard!.hint!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!'),
            ),
          ],
        ),
      );
    }
  }

  void _submitAnswer() {
    setState(() {
      _showAnswer = true;
    });
  }

  void _markAnswer(bool isCorrect) {
    final sessionState = ref.read(sessionStateProvider);
    
    // Submit the answer
    ref.read(sessionStateProvider.notifier).submitAnswer(
      _userAnswer.trim(),
      isCorrect,
      usedHint: _usedHint,
    );
    
    // Update flashcard progress
    ref.read(flashcardProgressProvider.notifier).updateProgress(
      sessionState.currentCard!.id,
      isCorrect,
    );
    
    // Move to next card or complete session
    if (sessionState.hasNextCard) {
      ref.read(sessionStateProvider.notifier).nextCard();
      setState(() {
        _showAnswer = false;
        _userAnswer = '';
        _usedHint = false;
        _answerController.clear();
      });
    } else {
      // Session complete - save session data
      _saveSession();
    }
  }

  void _saveSession() {
    final sessionState = ref.read(sessionStateProvider);
    
    final session = FlashcardSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: sessionState.startTime!,
      endTime: DateTime.now(),
      attempts: sessionState.attempts,
      totalCards: sessionState.cards.length,
      correctAnswers: sessionState.correctAnswers,
    );
    
    ref.read(flashcardSessionsProvider.notifier).addSession(session);
  }

  void _restartSession() {
    final sessionState = ref.read(sessionStateProvider);
    ref.read(sessionStateProvider.notifier).startSession(sessionState.cards);
    setState(() {
      _showAnswer = false;
      _userAnswer = '';
      _usedHint = false;
      _answerController.clear();
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Study Session?'),
        content: const Text('Your progress will be saved, but the session will end.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Studying'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit session
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.orange;
    return Colors.red;
  }
} 