import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../core/models/flashcard.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/flashcard_session_widget.dart';
import '../providers/flashcard_providers.dart';

/// Flashcards Page - Memory-Based Learning System
/// 
/// Integrates with the memory-to-learning conversion concept by:
/// 1. Creating flashcards from personal memories and family stories
/// 2. Using familiar names, places, and events in questions
/// 3. Adapting difficulty based on student progress
/// 4. Providing spaced repetition for optimal learning

class FlashcardsPage extends ConsumerStatefulWidget {
  const FlashcardsPage({super.key});

  @override
  ConsumerState<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends ConsumerState<FlashcardsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  FlashcardDifficulty _selectedDifficulty = FlashcardDifficulty.easy;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize sample flashcards if none exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSampleFlashcards();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeSampleFlashcards() {
    final flashcards = ref.read(flashcardsProvider);
    if (flashcards.isEmpty) {
      ref.read(flashcardsProvider.notifier).initializeSampleFlashcards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Memory Flashcards',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.highContrastDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.highContrastDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.highContrastDark),
            onPressed: _showCreateFlashcardDialog,
            tooltip: 'Create Memory Flashcard',
          ),
          IconButton(
            icon: const Icon(Icons.analytics, color: AppTheme.highContrastDark),
            onPressed: _showAnalytics,
            tooltip: 'View Analytics',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.pureWhite,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.mediumGray,
              indicatorColor: AppTheme.primaryBlue,
              tabs: const [
                Tab(text: 'Study', icon: Icon(Icons.school)),
                Tab(text: 'Practice', icon: Icon(Icons.quiz)),
                Tab(text: 'Memory Cards', icon: Icon(Icons.memory)),
                Tab(text: 'Progress', icon: Icon(Icons.trending_up)),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStudyTab(),
                _buildPracticeTab(),
                _buildMemoryCardsTab(),
                _buildProgressTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startQuickSession,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Quick Study'),
      ),
    );
  }

  Widget _buildStudyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 16),
          _buildFilterOptions(),
          const SizedBox(height: 16),
          _buildStudyModes(),
          const SizedBox(height: 16),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildPracticeTab() {
    return const FlashcardSessionWidget();
  }

  Widget _buildMemoryCardsTab() {
    final flashcards = ref.watch(flashcardsProvider);
    final personalizedCards = flashcards.where((card) => card.isPersonalized).toList();
    final regularCards = flashcards.where((card) => !card.isPersonalized).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (personalizedCards.isNotEmpty) ...[
            Text(
              'Your Memory Cards',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.highContrastDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flashcards created from your family memories and stories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 16),
            _buildFlashcardGrid(personalizedCards),
            const SizedBox(height: 24),
          ],
          
          Text(
            'Learning Library',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.highContrastDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'General learning flashcards for skill building',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 16),
          _buildFlashcardGrid(regularCards),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    final sessions = ref.watch(flashcardSessionsProvider);
    final progress = ref.watch(flashcardProgressProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressStats(sessions, progress),
          const SizedBox(height: 16),
          _buildProgressCharts(sessions),
          const SizedBox(height: 16),
          _buildMasteryOverview(progress),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Memory-Based Learning',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Flashcards created from your personal stories',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generateMemoryFlashcards,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green.shade600,
              ),
              icon: const Icon(Icons.family_restroom),
              label: const Text('Generate from My Memories'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildFilterOptions() {
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
              'Study Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('All Categories')),
                      ...FlashcardCategory.values.map((category) => 
                        DropdownMenuItem(
                          value: category.name,
                          child: Text(_getCategoryDisplayName(category)),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<FlashcardDifficulty>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    items: FlashcardDifficulty.values.map((difficulty) => 
                      DropdownMenuItem(
                        value: difficulty,
                        child: Text(_getDifficultyDisplayName(difficulty)),
                      ),
                    ).toList(),
                    onChanged: (value) => setState(() => _selectedDifficulty = value!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyModes() {
    final studyModes = [
      {
        'title': 'Memory Review',
        'subtitle': 'Review cards from your family stories',
        'icon': Icons.family_restroom,
        'color': Colors.purple,
        'onTap': () => _startMemoryReview(),
      },
      {
        'title': 'Spaced Repetition',
        'subtitle': 'Cards due for review today',
        'icon': Icons.repeat,
        'color': Colors.blue,
        'onTap': () => _startSpacedRepetition(),
      },
      {
        'title': 'Challenge Mode',
        'subtitle': 'Test your mastery level',
        'icon': Icons.flash_on,
        'color': Colors.orange,
        'onTap': () => _startChallengeMode(),
      },
      {
        'title': 'Learn New',
        'subtitle': 'Discover new concepts',
        'icon': Icons.lightbulb,
        'color': Colors.green,
        'onTap': () => _startLearnNew(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Modes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: studyModes.length,
          itemBuilder: (context, index) {
            final mode = studyModes[index];
            return AnimatedCard(
              onTap: mode['onTap'] as VoidCallback,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (mode['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (mode['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        mode['icon'] as IconData,
                        color: mode['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mode['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode['subtitle'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate(delay: (index * 100).ms).fadeIn().slideY(begin: 0.3);
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final sessions = ref.watch(flashcardSessionsProvider);
    final recentSessions = sessions.take(3).toList();

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recentSessions.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.quiz, color: AppTheme.mediumGray, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No study sessions yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _startQuickSession,
                      child: const Text('Start Your First Session'),
                    ),
                  ],
                ),
              )
            else
              ...recentSessions.map((session) => _buildSessionItem(session)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(FlashcardSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.quiz,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.category != null 
                      ? _getCategoryDisplayName(session.category!)
                      : 'Mixed Categories',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${session.correctAnswers}/${session.totalCards} correct • ${_formatDuration(session.duration)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getAccuracyColor(session.accuracy).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(session.accuracy * 100).toInt()}%',
              style: TextStyle(
                color: _getAccuracyColor(session.accuracy),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardGrid(List<Flashcard> flashcards) {
    if (flashcards.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.quiz, color: AppTheme.mediumGray, size: 48),
            const SizedBox(height: 8),
            Text(
              'No flashcards in this category',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        return FlashcardWidget(
          flashcard: flashcard,
          onTap: () => _previewFlashcard(flashcard),
        );
      },
    );
  }

  Widget _buildProgressStats(List<FlashcardSession> sessions, List<FlashcardProgress> progress) {
    final totalSessions = sessions.length;
    final totalCards = progress.length;
    final masteredCards = progress.where((p) => p.masteryLevel >= 0.8).length;
    final averageAccuracy = sessions.isNotEmpty 
        ? sessions.map((s) => s.accuracy).reduce((a, b) => a + b) / sessions.length
        : 0.0;

    return Row(
      children: [
        Expanded(child: _buildStatCard('Sessions', totalSessions.toString(), Icons.school, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Cards', totalCards.toString(), Icons.quiz, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Mastered', masteredCards.toString(), Icons.check_circle, Colors.purple)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Accuracy', '${(averageAccuracy * 100).toInt()}%', Icons.trending_up, Colors.orange)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCharts(List<FlashcardSession> sessions) {
    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: Center(
                child: Text(
                  'Progress chart would be here\n(using fl_chart library)',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryOverview(List<FlashcardProgress> progress) {
    final categories = <FlashcardCategory, List<FlashcardProgress>>{};
    final flashcards = ref.watch(flashcardsProvider);
    
    for (final p in progress) {
      final flashcard = flashcards.firstWhere(
        (f) => f.id == p.flashcardId,
        orElse: () => Flashcard(
          id: p.flashcardId,
          question: 'Unknown',
          answer: 'Unknown',
          category: FlashcardCategory.math,
          difficulty: FlashcardDifficulty.easy,
          createdAt: DateTime.now(),
        ),
      );
      categories.putIfAbsent(flashcard.category, () => []).add(p);
    }

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mastery by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) {
              final category = entry.key;
              final categoryProgress = entry.value;
              final averageMastery = categoryProgress.isNotEmpty
                  ? categoryProgress.map((p) => p.masteryLevel).reduce((a, b) => a + b) / categoryProgress.length
                  : 0.0;
              
              return _buildMasteryItem(category, averageMastery, categoryProgress.length);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryItem(FlashcardCategory category, double mastery, int cardCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getCategoryDisplayName(category),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$cardCount cards • ${(mastery * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: mastery,
            backgroundColor: AppTheme.lightGray,
            valueColor: AlwaysStoppedAnimation(_getMasteryColor(mastery)),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getCategoryDisplayName(FlashcardCategory category) {
    switch (category) {
      case FlashcardCategory.math:
        return 'Math';
      case FlashcardCategory.reading:
        return 'Reading';
      case FlashcardCategory.science:
        return 'Science';
      case FlashcardCategory.socialSkills:
        return 'Social Skills';
      case FlashcardCategory.vocabulary:
        return 'Vocabulary';
      case FlashcardCategory.memory:
        return 'Memory';
      case FlashcardCategory.problemSolving:
        return 'Problem Solving';
      case FlashcardCategory.emotions:
        return 'Emotions';
    }
  }

  String _getDifficultyDisplayName(FlashcardDifficulty difficulty) {
    switch (difficulty) {
      case FlashcardDifficulty.easy:
        return 'Easy';
      case FlashcardDifficulty.medium:
        return 'Medium';
      case FlashcardDifficulty.hard:
        return 'Hard';
    }
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getMasteryColor(double mastery) {
    if (mastery >= 0.8) return Colors.green;
    if (mastery >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  // Navigation methods
  void _startQuickSession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardSessionWidget(),
      ),
    );
  }

  void _startMemoryReview() {
    final flashcards = ref.read(flashcardsProvider);
    final memoryCards = flashcards.where((card) => card.isPersonalized).toList();
    
    if (memoryCards.isEmpty) {
      _showNoMemoryCardsDialog();
    } else {
      _startSessionWithCards(memoryCards, 'Memory Review');
    }
  }

  void _startSpacedRepetition() {
    final progress = ref.read(flashcardProgressProvider);
    final dueCards = progress.where((p) => p.needsReview).toList();
    
    if (dueCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cards due for review!')),
      );
    } else {
      final flashcards = ref.read(flashcardsProvider);
      final reviewCards = flashcards.where((card) => 
        dueCards.any((p) => p.flashcardId == card.id)
      ).toList();
      _startSessionWithCards(reviewCards, 'Spaced Repetition');
    }
  }

  void _startChallengeMode() {
    final flashcards = ref.read(flashcardsProvider);
    final hardCards = flashcards.where((card) => 
      card.difficulty == FlashcardDifficulty.hard
    ).toList();
    
    if (hardCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No challenge cards available!')),
      );
    } else {
      _startSessionWithCards(hardCards.take(10).toList(), 'Challenge Mode');
    }
  }

  void _startLearnNew() {
    final progress = ref.read(flashcardProgressProvider);
    final flashcards = ref.read(flashcardsProvider);
    final newCards = flashcards.where((card) => 
      !progress.any((p) => p.flashcardId == card.id)
    ).toList();
    
    if (newCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No new cards to learn!')),
      );
    } else {
      _startSessionWithCards(newCards.take(5).toList(), 'Learn New');
    }
  }

  void _startSessionWithCards(List<Flashcard> cards, String sessionType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardSessionWidget(
          initialCards: cards,
          sessionType: sessionType,
        ),
      ),
    );
  }

  void _previewFlashcard(Flashcard flashcard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          flashcard.isPersonalized ? 'Memory Card' : 'Flashcard',
          style: TextStyle(
            color: flashcard.isPersonalized ? Colors.purple : AppTheme.primaryBlue,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (flashcard.memoryContext != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.family_restroom, color: Colors.purple, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        flashcard.memoryContext!,
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Question:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(flashcard.question),
            const SizedBox(height: 12),
            Text(
              'Answer:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(flashcard.answer),
            if (flashcard.hint != null) ...[
              const SizedBox(height: 12),
              Text(
                'Hint:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(flashcard.hint!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startSessionWithCards([flashcard], 'Single Card Review');
            },
            child: const Text('Study This Card'),
          ),
        ],
      ),
    );
  }

  void _generateMemoryFlashcards() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('🧠 Generating flashcards from your memories...'),
            const SizedBox(height: 8),
            const Text(
              'Creating personalized learning cards from your family stories',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    
    // Simulate AI processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close processing dialog
      
      ref.read(flashcardsProvider.notifier).generateMemoryFlashcards();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Memory flashcards generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showCreateFlashcardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Custom Flashcard'),
        content: const Text('Custom flashcard creation dialog would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Custom flashcard creation coming soon!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detailed analytics coming soon!')),
    );
  }

  void _showNoMemoryCardsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Memory Cards'),
        content: const Text(
          'You don\'t have any memory-based flashcards yet. '
          'Would you like to generate some from your family stories?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateMemoryFlashcards();
            },
            child: const Text('Generate Now'),
          ),
        ],
      ),
    );
  }
} 