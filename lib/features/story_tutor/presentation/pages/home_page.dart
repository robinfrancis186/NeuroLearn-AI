import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/widgets/mood_selector.dart';
import '../../../../core/models/emotional_state.dart';
import '../../../../core/models/student_profile.dart';
import '../../../dashboard/presentation/pages/student_dashboard_page.dart';
import '../../../communication/presentation/pages/communication_page.dart';
import '../../../flashcards/presentation/pages/flashcards_page.dart';
import '../../../ar_geography/presentation/pages/ar_geography_page.dart';
import '../../../emotion_engine/emotion_engine_page.dart';
import '../../../caretaker_portal/navigation/caretaker_navigation.dart';
import '../widgets/story_queue_widget.dart';
import '../widgets/student_avatar_widget.dart';
import 'story_session_page.dart';
import 'story_builder_page.dart';
import 'mistral_story_demo.dart';
import 'learning_classroom_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize services if needed
    // Load student profiles
    // Set up emotion monitoring
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(currentStudentProvider);
    final storyQueue = ref.watch(storyQueueProvider);
    final currentMood = ref.watch(storyMoodProvider);
    
    return Scaffold(
      body: SafeArea(
        child: student == null
            ? _buildStudentSelection()
            : _buildMainInterface(student, storyQueue, currentMood),
      ),
    );
  }

  Widget _buildStudentSelection() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.comfortGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome animation
            Container(
              height: 200,
              child: Icon(
                Icons.auto_stories,
                size: 120,
                color: Colors.white,
              ),
            ).animate().scale(
              begin: Offset(0.8, 0.8),
              end: Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.elasticOut,
            ),
            
            const SizedBox(height: 32),
            
            // Welcome message
            Text(
              'Welcome to NeuroLearn AI',
              style: (Theme.of(context).textTheme.displayMedium ?? const TextStyle()).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            
            const SizedBox(height: 16),
            
            Text(
              'Learning Without Limits — One Story at a Time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            
            const SizedBox(height: 48),
            
            // Student selection cards
            Expanded(
              child: _buildStudentCards(),
            ),
            
            const SizedBox(height: 24),
            
            // Add new student button
            AnimatedCard(
              onTap: () => _showAddStudentDialog(),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add New Student',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slide(
              begin: Offset(0, 1),
              end: Offset.zero,
              delay: 800.ms, 
              duration: 600.ms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCards() {
    // This would load from Firebase in a real implementation
    final mockStudents = [
      {'name': 'Alex', 'age': 7, 'avatar': 'default_avatar_1'},
      {'name': 'Maya', 'age': 9, 'avatar': 'default_avatar_2'},
      {'name': 'Sam', 'age': 6, 'avatar': 'default_avatar_3'},
    ];

    return ListView.builder(
      itemCount: mockStudents.length,
      itemBuilder: (context, index) {
        final student = mockStudents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AnimatedCard(
            onTap: () => _selectStudent(student),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  StudentAvatarWidget(
                    avatarPath: student['avatar'] as String,
                    size: 60,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'] as String,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.highContrastDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Age ${student['age']}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: 200 * index))
              .slide(
                begin: Offset(-1, 0),
                end: Offset.zero,
                duration: 600.ms,
              )
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildMainInterface(StudentProfile student, List<String> storyQueue, StoryMood currentMood) {
    return CustomScrollView(
      slivers: [
        // App bar with student info
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: _getMoodGradient(currentMood),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StudentAvatarWidget(
                          avatarPath: student.avatarPath,
                          size: 80,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${student.name}!',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ready for today\'s adventure?',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _showSettings(),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _logout(),
            ),
          ],
        ),
        
        // Mood selector
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling today?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                MoodSelector(
                  currentMood: currentMood,
                  onMoodChanged: (mood) {
                    ref.read(storyMoodProvider.notifier).state = mood;
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Story queue section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Stories',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _refreshStories(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                StoryQueueWidget(
                  stories: storyQueue,
                  onStoryTap: (storyId) => _startStory(storyId),
                ),
              ],
            ),
          ),
        ),
        
        // Quick actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Learning Classroom',
        'subtitle': 'Explore subjects: Maths, Science, Reading & Social Skills',
        'icon': Icons.school,
        'color': Colors.deepPurple,
        'onTap': () => _navigateToLearningClassroom(),
      },
      {
        'title': 'Share Memory',
        'subtitle': 'Turn your family stories into learning adventures',
        'icon': Icons.family_restroom,
        'color': AppTheme.primaryBlue,
        'onTap': () => _navigateToStoryBuilder(),
      },
      {
        'title': 'AR Geography',
        'subtitle': 'Explore the world with hand tracking',
        'icon': Icons.public,
        'color': Colors.purple,
        'onTap': () => _navigateToARGeography(),
      },
      {
        'title': 'Communication',
        'subtitle': 'Express yourself',
        'icon': Icons.chat_bubble,
        'color': AppTheme.lightBlue,
        'onTap': () => _navigateToCommunication(),
      },
      {
        'title': 'Emotion Engine',
        'subtitle': 'AI-powered emotion detection for personalized stories',
        'icon': Icons.psychology,
        'color': Colors.pink,
        'onTap': () => _navigateToEmotionEngine(),
      },
      {
        'title': 'Flashcards',
        'subtitle': 'Practice with personalized flashcards',
        'icon': Icons.quiz,
        'color': Colors.green,
        'onTap': () => _navigateToFlashcards(),
      },
      {
        'title': 'Progress',
        'subtitle': 'See how you\'re doing',
        'icon': Icons.trending_up,
        'color': AppTheme.accentBlue,
        'onTap': () {
          final currentStudent = ref.read(currentStudentProvider);
          if (currentStudent != null) {
            _navigateToProgress(currentStudent);
          }
        },
      },
    ];

    return Column(
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedCard(
            onTap: action['onTap'] as VoidCallback,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (action['color'] as Color).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          action['subtitle'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.mediumGray,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  LinearGradient _getMoodGradient(StoryMood mood) {
    switch (mood) {
      case StoryMood.calm:
        return AppTheme.comfortGradient;
      case StoryMood.excitement:
        return AppTheme.focusGradient;
      case StoryMood.comfort:
        return AppTheme.comfortGradient;
      case StoryMood.adventure:
        return AppTheme.focusGradient;
      case StoryMood.creative:
        return AppTheme.focusGradient;
      case StoryMood.social:
        return AppTheme.comfortGradient;
      case StoryMood.neutral:
        return AppTheme.focusGradient;
    }
  }

  void _selectStudent(Map<String, dynamic> student) {
    // Create a proper StudentProfile to enable the main interface
    final mockProfile = StudentProfile(
      id: student['name'].toString().toLowerCase(),
      name: student['name'] as String,
      age: student['age'] as int,
      avatarPath: student['avatar'] as String,
      cognitiveProfile: CognitiveProfile(
        primaryLearningStyle: LearningStyle.visual,
        attentionProfile: AttentionProfile(
          attentionSpanMinutes: 15,
          needsBreaks: true,
          breakIntervalMinutes: 10,
        ),
        sensoryPreferences: SensoryPreferences(
          preferredVolume: 0.7,
          reducedAnimations: false,
          highContrast: false,
        ),
        communicationNeeds: CommunicationNeeds(
          needsVisualSupports: true,
          prefersShorterSentences: true,
        ),
      ),
      favoriteCharacters: ['Friendly Dragon', 'Wise Owl', 'Adventure Cat'],
      preferredTopics: ['stories', 'adventure', 'learning'],
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    
    // Update the provider to trigger UI change
    ref.read(currentStudentProvider.notifier).state = mockProfile;
    
    // Add some sample stories to the queue
    ref.read(storyQueueProvider.notifier).state = [
      'The Magical Forest Adventure',
      'Space Explorer Mission',
      'Underwater Discovery',
      'Dragon Friend Quest',
    ];
    
    print('Selected student: ${student['name']} - Profile created successfully');
  }

  void _showAddStudentDialog() {
    // Navigate to student creation flow
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CaretakerPortal(),
      ),
    );
  }

  void _logout() {
    ref.read(currentStudentProvider.notifier).state = null;
  }

  void _refreshStories() {
    // Refresh story queue based on current mood and profile
  }

  void _startStory(String storyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StorySessionPage(storyId: storyId),
      ),
    );
  }

  void _navigateToStoryBuilder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryBuilderPage(),
      ),
    );
  }

  void _navigateToCommunication() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CommunicationPage(),
      ),
    );
  }

  void _navigateToFlashcards() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardsPage(),
      ),
    );
  }

  void _navigateToProgress(StudentProfile student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDashboardPage(student: student),
      ),
    );
  }

  void _navigateToARGeography() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ARGeographyPage(),
      ),
    );
  }

  void _navigateToMistralDemo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MistralStoryDemo(),
      ),
    );
  }

  void _navigateToEmotionEngine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmotionEnginePage(),
      ),
    );
  }

  void _navigateToLearningClassroom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LearningClassroomPage(),
      ),
    );
  }
} 