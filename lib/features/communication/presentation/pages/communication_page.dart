import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/providers/app_providers.dart';

class CommunicationPage extends ConsumerStatefulWidget {
  const CommunicationPage({super.key});

  @override
  ConsumerState<CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends ConsumerState<CommunicationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _selectedWords = [];
  final List<String> _conversationHistory = [];
  String _currentEmotion = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Communication Helper',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.highContrastDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.highContrastDark),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.mediumGray,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Visual Board'),
            Tab(icon: Icon(Icons.sentiment_satisfied), text: 'Emotions'),
            Tab(icon: Icon(Icons.chat), text: 'Social Skills'),
            Tab(icon: Icon(Icons.volume_up), text: 'Voice Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisualBoard(),
          _buildEmotionExpression(),
          _buildSocialSkills(),
          _buildVoicePractice(),
        ],
      ),
    );
  }

  Widget _buildVisualBoard() {
    final categories = [
      {'name': 'Feelings', 'items': ['😊 Happy', '😢 Sad', '😡 Angry', '😰 Worried', '😴 Tired', '🤗 Excited']},
      {'name': 'Needs', 'items': ['🍎 Hungry', '💧 Thirsty', '🚽 Bathroom', '🛌 Rest', '🤝 Help', '🔇 Quiet']},
      {'name': 'Actions', 'items': ['▶️ Start', '⏹️ Stop', '👍 Like', '👎 Dislike', '🔄 Again', '✅ Done']},
      {'name': 'Places', 'items': ['🏠 Home', '🏫 School', '🏪 Store', '🏥 Doctor', '🌳 Outside', '🚗 Car']},
    ];

    return Column(
      children: [
        // Selected words display
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryBlue, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Message:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
                              Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedWords.map((word) => Chip(
                      label: Text(word),
                      onDeleted: () => _removeWord(word),
                      backgroundColor: AppTheme.lightBlue.withOpacity(0.3),
                    )),
                    if (_selectedWords.isEmpty)
                      Text(
                        'Tap words below to build your message',
                        style: TextStyle(color: AppTheme.mediumGray),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectedWords.isNotEmpty ? _speakMessage : null,
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Speak'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _selectedWords.isNotEmpty ? _clearMessage : null,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mediumGray,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2),
        
        // Category tabs and words
        Expanded(
          child: DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelColor: AppTheme.primaryBlue,
                  unselectedLabelColor: AppTheme.mediumGray,
                  indicatorColor: AppTheme.primaryBlue,
                  tabs: categories.map((cat) => Tab(text: cat['name'] as String)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.map((category) {
                      final items = category['items'] as List<String>;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return AnimatedCard(
                              onTap: () => _addWord(item),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.lightGray),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.split(' ')[0],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.split(' ').skip(1).join(' '),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ).animate(delay: (index * 50).ms).fadeIn().scale();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionExpression() {
    final emotions = [
      {'emoji': '😊', 'name': 'Happy', 'color': Colors.green},
      {'emoji': '😢', 'name': 'Sad', 'color': Colors.blue},
      {'emoji': '😡', 'name': 'Angry', 'color': Colors.red},
      {'emoji': '😰', 'name': 'Worried', 'color': Colors.orange},
      {'emoji': '😴', 'name': 'Tired', 'color': Colors.purple},
      {'emoji': '🤗', 'name': 'Excited', 'color': Colors.pink},
      {'emoji': '😕', 'name': 'Confused', 'color': Colors.brown},
      {'emoji': '😌', 'name': 'Calm', 'color': Colors.teal},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 16),
          if (_currentEmotion.isNotEmpty)
            AnimatedCard(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryBlue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sentiment_satisfied, color: AppTheme.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      'I am feeling $_currentEmotion',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().scale(),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                final isSelected = _currentEmotion == emotion['name'];
                
                return AnimatedCard(
                  onTap: () => _selectEmotion(emotion['name'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? (emotion['color'] as Color).withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? emotion['color'] as Color
                            : AppTheme.lightGray,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emotion['emoji'] as String,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emotion['name'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? emotion['color'] as Color
                                : AppTheme.highContrastDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (index * 100).ms).fadeIn().scale();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSkills() {
    final scenarios = [
      {
        'title': 'Asking for Help',
        'scenario': 'You need help with something difficult',
        'options': ['Can you help me?', 'I need assistance', 'Please help'],
      },
      {
        'title': 'Making Friends',
        'scenario': 'You want to talk to someone new',
        'options': ['Hi, I\'m...', 'Would you like to play?', 'What\'s your name?'],
      },
      {
        'title': 'Sharing Feelings',
        'scenario': 'Someone asks how you feel',
        'options': ['I feel good', 'I\'m a bit sad', 'I\'m excited!'],
      },
      {
        'title': 'Problem Solving',
        'scenario': 'There\'s a disagreement',
        'options': ['Let\'s work together', 'How can we fix this?', 'I understand'],
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Social Skills',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: scenarios.length,
              itemBuilder: (context, index) {
                final scenario = scenarios[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AnimatedCard(
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
                            scenario['title'] as String,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scenario['scenario'] as String,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'What would you say?',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...(scenario['options'] as List<String>).map((option) =>
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => _practicePhrase(option),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryBlue,
                                    side: BorderSide(color: AppTheme.primaryBlue),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(option),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: (index * 200).ms).fadeIn().slideY(begin: 0.3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoicePractice() {
    final exercises = [
      {'title': 'Breathing Exercise', 'instruction': 'Take deep breaths: In... Out...', 'icon': Icons.air},
      {'title': 'Volume Control', 'instruction': 'Practice speaking softly, then loudly', 'icon': Icons.volume_up},
      {'title': 'Clear Speech', 'instruction': 'Say each word slowly and clearly', 'icon': Icons.record_voice_over},
      {'title': 'Greeting Practice', 'instruction': 'Practice saying "Hello" in different ways', 'icon': Icons.waving_hand},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Practice',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AnimatedCard(
                    onTap: () => _startVoiceExercise(exercise['title'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              exercise['icon'] as IconData,
                              color: AppTheme.lightBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise['title'] as String,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exercise['instruction'] as String,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.mediumGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.play_arrow, color: AppTheme.primaryBlue),
                        ],
                      ),
                    ),
                  ).animate(delay: (index * 150).ms).fadeIn().slideX(begin: 0.3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addWord(String word) {
    setState(() {
      _selectedWords.add(word);
    });
  }

  void _removeWord(String word) {
    setState(() {
      _selectedWords.remove(word);
    });
  }

  void _speakMessage() {
    final message = _selectedWords.join(' ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speaking: "$message"'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
    // Here you would integrate with TTS
  }

  void _clearMessage() {
    setState(() {
      _selectedWords.clear();
    });
  }

  void _selectEmotion(String emotion) {
    setState(() {
      _currentEmotion = emotion;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are feeling $emotion'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _practicePhrase(String phrase) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great choice: "$phrase"'),
        backgroundColor: AppTheme.accentBlue,
        action: SnackBarAction(
          label: 'Practice',
          textColor: Colors.white,
          onPressed: () {
            // Start voice practice for this phrase
          },
        ),
      ),
    );
  }

  void _startVoiceExercise(String exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic, size: 48, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text('Tap the microphone when ready to practice'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Starting $exercise'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
              icon: const Icon(Icons.mic),
              label: const Text('Start Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 