import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/langchain_service.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/emotional_state.dart';

class MistralStoryDemo extends ConsumerStatefulWidget {
  const MistralStoryDemo({Key? key}) : super(key: key);

  @override
  ConsumerState<MistralStoryDemo> createState() => _MistralStoryDemoState();
}

class _MistralStoryDemoState extends ConsumerState<MistralStoryDemo> {
  bool _isConnected = false;
  bool _isCheckingConnection = true;
  bool _isGeneratingStory = false;
  LangChainStoryResponse? _generatedStory;
  String _selectedSubject = 'science';
  String _selectedMood = 'excitement';
  String _learningObjective = 'understanding solar system';
  
  final List<String> _subjects = ['science', 'math', 'reading', 'social_skills'];
  final List<String> _moods = ['calm', 'excitement', 'comfort', 'adventure', 'creative', 'social', 'neutral'];

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
  }

  Future<void> _checkBackendConnection() async {
    setState(() => _isCheckingConnection = true);
    try {
      await LangChainService.initialize();
      final isHealthy = await LangChainService.instance.isBackendHealthy();
      setState(() {
        _isConnected = isHealthy;
        _isCheckingConnection = false;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isCheckingConnection = false;
      });
    }
  }

  Future<void> _generateStory() async {
    if (!_isConnected) return;

    setState(() => _isGeneratingStory = true);

    try {
      final now = DateTime.now();
      final testProfile = StudentProfile(
        id: 'test_student',
        name: 'Alex',
        age: 8,
        avatarPath: 'assets/avatars/default.png',
        cognitiveProfile: CognitiveProfile(
          neurodivergentTraits: ['ADHD'],
          primaryLearningStyle: LearningStyle.visual,
          attentionProfile: AttentionProfile(
            attentionSpanMinutes: 15,
            distractionTriggers: ['loud noises'],
            focusStrategies: ['visual cues'],
            needsBreaks: true,
            breakIntervalMinutes: 10,
          ),
          sensoryPreferences: SensoryPreferences(
            visualSensitivity: false,
            auditorySensitivity: true,
            tactileSensitivity: false,
            preferredVolume: 0.5,
            reducedAnimations: false,
            highContrast: false,
          ),
          communicationNeeds: CommunicationNeeds(
            usesAAC: false,
            needsVisualSupports: true,
            prefersShorterSentences: true,
            needsRepetition: false,
            communicationMethods: ['verbal', 'visual'],
          ),
          skillLevels: {'reading': 0.7, 'math': 0.6},
          supportStrategies: ['visual supports', 'frequent breaks'],
        ),
        favoriteCharacters: ['dinosaurs', 'robots'],
        preferredTopics: ['space', 'animals'],
        learningProgress: {},
        parentEmail: null,
        teacherEmail: null,
        createdAt: now,
        lastActiveAt: now,
        isActive: true,
      );

      final story = await LangChainService.instance.generatePersonalizedStory(
        student: testProfile,
        learningObjective: _learningObjective,
        subject: _selectedSubject,
        mood: StoryMood.values.firstWhere((m) => m.name == _selectedMood),
        previousStoryContext: null,
        memoryContext: {},
      );

      setState(() {
        _generatedStory = story;
        _isGeneratingStory = false;
      });
    } catch (e) {
      setState(() => _isGeneratingStory = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating story: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistral 7B Story Generator'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backend Status
            Card(
              color: _isConnected ? Colors.green[50] : Colors.red[50],
              child: ListTile(
                leading: Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                title: Text(
                  _isConnected ? 'Mistral Backend: Connected' : 'Mistral Backend: Disconnected',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                subtitle: Text(_isConnected 
                  ? 'Ready to generate stories with Mistral 7B' 
                  : 'Check if backend is running on port 8002'),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _checkBackendConnection,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (_isConnected) ...[
              // Story Configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Story Settings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Subject selection
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                        items: _subjects.map((subject) => 
                          DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          ),
                        ).toList(),
                        onChanged: (value) => setState(() => _selectedSubject = value!),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Learning objective
                      TextFormField(
                        initialValue: _learningObjective,
                        decoration: const InputDecoration(
                          labelText: 'Learning Objective',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _learningObjective = value,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Mood selection
                      DropdownButtonFormField<String>(
                        value: _selectedMood,
                        decoration: const InputDecoration(
                          labelText: 'Story Mood',
                          border: OutlineInputBorder(),
                        ),
                        items: _moods.map((mood) => 
                          DropdownMenuItem(
                            value: mood,
                            child: Text(mood),
                          ),
                        ).toList(),
                        onChanged: (value) => setState(() => _selectedMood = value!),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Generate button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isGeneratingStory ? null : _generateStory,
                          icon: _isGeneratingStory 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                          label: Text(_isGeneratingStory ? 'Generating Story...' : 'Generate Story with Mistral 7B'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Story display
            if (_generatedStory != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.book, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _generatedStory!.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          Text(
                            _generatedStory!.content,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          if (_generatedStory!.characters.isNotEmpty) ...[
                            const Text(
                              'Characters:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(_generatedStory!.characters.join(', ')),
                            const SizedBox(height: 12),
                          ],
                          
                          if (_generatedStory!.learningPoints.isNotEmpty) ...[
                            const Text(
                              'Learning Points:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...(_generatedStory!.learningPoints.map((point) => 
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• '),
                                    Expanded(child: Text(point)),
                                  ],
                                ),
                              ),
                            )),
                            const SizedBox(height: 12),
                          ],
                          
                          if (_generatedStory!.vocabularyWords.isNotEmpty) ...[
                            const Text(
                              'Vocabulary Words:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: _generatedStory!.vocabularyWords.map((word) =>
                                Chip(
                                  label: Text(word),
                                  backgroundColor: Colors.blue[100],
                                ),
                              ).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 