import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/services/langchain_service.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/widgets/mood_selector.dart';

enum StoryMood { calm, excitement, comfort, adventure, creative, social, neutral }

class LangChainStoryPage extends ConsumerStatefulWidget {
  final StudentProfile student;
  
  const LangChainStoryPage({
    super.key,
    required this.student,
  });

  @override
  ConsumerState<LangChainStoryPage> createState() => _LangChainStoryPageState();
}

class _LangChainStoryPageState extends ConsumerState<LangChainStoryPage> {
  bool _isGenerating = false;
  String _selectedSubject = 'social_skills';
  String _learningObjective = 'Learn about friendship and cooperation';
  StoryMood _selectedMood = StoryMood.adventure;
  LangChainStoryResponse? _generatedStory;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: SafeArea(
        child: _generatedStory != null
            ? _buildStoryDisplay()
            : _buildStoryGenerator(),
      ),
    );
  }

  Widget _buildStoryGenerator() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.focusGradient,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'AI Story Generator',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Student info
            AnimatedCard(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                          child: Text(
                            widget.student.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.student.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Age ${widget.student.age} • ${widget.student.cognitiveProfile.primaryLearningStyle.name} learner',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.student.favoriteCharacters.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Favorite Characters:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: widget.student.favoriteCharacters.take(3).map((character) => 
                          Chip(
                            label: Text(character),
                            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                          ),
                        ).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Story settings
            AnimatedCard(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Story Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Subject selection
                    Text(
                      'Subject',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: const [
                        DropdownMenuItem(value: 'social_skills', child: Text('Social Skills')),
                        DropdownMenuItem(value: 'reading', child: Text('Reading')),
                        DropdownMenuItem(value: 'math', child: Text('Math')),
                        DropdownMenuItem(value: 'science', child: Text('Science')),
                        DropdownMenuItem(value: 'emotional_regulation', child: Text('Emotional Regulation')),
                      ],
                      onChanged: (value) => setState(() => _selectedSubject = value!),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Learning objective
                    Text(
                      'Learning Objective',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _learningObjective,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        hintText: 'What should the student learn from this story?',
                      ),
                      maxLines: 2,
                      onChanged: (value) => _learningObjective = value,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Mood selection
                    Text(
                      'Story Mood',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: StoryMood.values.map((mood) => 
                        FilterChip(
                          label: Text(mood.name.toUpperCase()),
                          selected: _selectedMood == mood,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedMood = mood);
                          },
                          selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                          checkmarkColor: AppTheme.primaryBlue,
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Generating Story...'),
                        ],
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome),
                          SizedBox(width: 8),
                          Text('Generate AI Story'),
                        ],
                      ),
              ),
            ),
            
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStoryDisplay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withOpacity(0.8),
            Colors.white,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => setState(() => _generatedStory = null),
                ),
                Expanded(
                  child: Text(
                    _generatedStory!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _generateStory,
                ),
              ],
            ),
          ),
          
          // Story content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story content
                    Text(
                      _generatedStory!.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Learning points
                    if (_generatedStory!.learningPoints.isNotEmpty) ...[
                      Text(
                        '🎯 Learning Points:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(_generatedStory!.learningPoints.map((point) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $point'),
                        ),
                      )),
                      const SizedBox(height: 16),
                    ],
                    
                    // Vocabulary
                    if (_generatedStory!.vocabularyWords.isNotEmpty) ...[
                      Text(
                        '📚 New Vocabulary:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _generatedStory!.vocabularyWords.map((word) =>
                          Chip(
                            label: Text(word),
                            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                          ),
                        ).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Future<void> _generateStory() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final story = await LangChainService.instance.generatePersonalizedStory(
        student: widget.student,
        learningObjective: _learningObjective,
        subject: _selectedSubject,
        mood: _selectedMood,
      );
      
      setState(() {
        _generatedStory = story;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate story. Please check if the backend is running and try again.';
        _isGenerating = false;
      });
    }
  }
} 