import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import '../models/student_profile.dart';
import '../models/story_session.dart';
import '../models/emotional_state.dart';
import '../config/app_config.dart';

class AIService {
  static AIService? _instance;
  static AIService get instance => _instance!;
  
  bool _isInitialized = false;
  
  static Future<void> initialize() async {
    _instance = AIService._();
    await _instance!._init();
  }
  
  AIService._();
  
  Future<void> _init() async {
    // Initialize OpenAI API using configuration
    OpenAI.apiKey = AppConfig.openAiApiKey;
    if (AppConfig.openAiOrganizationId.isNotEmpty && 
        AppConfig.openAiOrganizationId != 'YOUR_ORGANIZATION_ID_HERE') {
      OpenAI.organization = AppConfig.openAiOrganizationId;
    }
    
    _isInitialized = true;
  }
  
  /// Generates a personalized story based on student profile and learning objectives
  Future<StoryResponse> generateStory({
    required StudentProfile student,
    required String learningObjective,
    required String subject,
    required StoryMood mood,
    String? previousStoryContext,
  }) async {
    if (!_isInitialized) throw Exception('AIService not initialized');
    
    try {
      final prompt = _buildStoryPrompt(
        student: student,
        learningObjective: learningObjective,
        subject: subject,
        mood: mood,
        previousContext: previousStoryContext,
      );
      
      final completion = await OpenAI.instance.chat.create(
        model: "gpt-4",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 1500,
        temperature: 0.8,
        topP: 1,
      );
      
      final content = completion.choices.first.message.content?.first.text ?? '';
      return _parseStoryResponse(content);
      
    } catch (e) {
      throw AIServiceException('Failed to generate story: $e');
    }
  }
  
  /// Adapts story content in real-time based on student interaction
  Future<String> adaptStoryContent({
    required String currentStory,
    required List<StoryInteraction> interactions,
    required EmotionalState? currentEmotion,
    required StudentProfile student,
  }) async {
    try {
      final adaptationPrompt = _buildAdaptationPrompt(
        currentStory: currentStory,
        interactions: interactions,
        emotion: currentEmotion,
        student: student,
      );
      
      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(adaptationPrompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 800,
        temperature: 0.7,
      );
      
      return completion.choices.first.message.content?.first.text ?? currentStory;
      
    } catch (e) {
      return currentStory; // Return original story if adaptation fails
    }
  }
  
  /// Generates interactive questions for story comprehension
  Future<List<StoryQuestion>> generateQuestions({
    required String storyContent,
    required StudentProfile student,
    required String learningObjective,
  }) async {
    try {
      final questionPrompt = _buildQuestionPrompt(
        storyContent: storyContent,
        student: student,
        learningObjective: learningObjective,
      );
      
      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(questionPrompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 1000,
        temperature: 0.6,
      );
      
      final content = completion.choices.first.message.content?.first.text ?? '';
      return _parseQuestions(content);
      
    } catch (e) {
      return []; // Return empty list if question generation fails
    }
  }
  
  /// Converts learning content into story format
  Future<String> convertToStory({
    required String rawContent,
    required StudentProfile student,
    required StoryMood mood,
  }) async {
    try {
      final conversionPrompt = _buildConversionPrompt(
        rawContent: rawContent,
        student: student,
        mood: mood,
      );
      
      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(conversionPrompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 1200,
        temperature: 0.8,
      );
      
      return completion.choices.first.message.content?.first.text ?? rawContent;
      
    } catch (e) {
      return rawContent;
    }
  }
  
  /// Analyzes student responses for comprehension scoring
  Future<ComprehensionAnalysis> analyzeComprehension({
    required String studentResponse,
    required String expectedAnswer,
    required String questionContext,
  }) async {
    try {
      final analysisPrompt = _buildAnalysisPrompt(
        studentResponse: studentResponse,
        expectedAnswer: expectedAnswer,
        context: questionContext,
      );
      
      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(analysisPrompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        maxTokens: 500,
        temperature: 0.3,
      );
      
      final content = completion.choices.first.message.content?.first.text ?? '';
      return _parseComprehensionAnalysis(content);
      
    } catch (e) {
      return ComprehensionAnalysis(
        score: 0.5,
        feedback: 'Unable to analyze response',
        suggestions: [],
      );
    }
  }
  
  String _buildStoryPrompt({
    required StudentProfile student,
    required String learningObjective,
    required String subject,
    required StoryMood mood,
    String? previousContext,
  }) {
    final ageGroup = student.age <= 8 ? 'young child' : 'child';
    final traits = student.cognitiveProfile.neurodivergentTraits.join(', ');
    final favorites = student.favoriteCharacters.join(', ');
    
    return """
Create an engaging, educational story for a ${student.age}-year-old $ageGroup named ${student.name}.

STUDENT PROFILE:
- Age: ${student.age}
- Neurodivergent traits: $traits
- Learning style: ${student.cognitiveProfile.primaryLearningStyle}
- Attention span: ${student.cognitiveProfile.attentionProfile.attentionSpanMinutes} minutes
- Communication needs: ${student.cognitiveProfile.communicationNeeds.prefersShorterSentences ? 'Short sentences' : 'Normal sentences'}
- Favorite characters: $favorites
- Sensory preferences: ${student.cognitiveProfile.sensoryPreferences.toJson()}

STORY REQUIREMENTS:
- Subject: $subject
- Learning objective: $learningObjective
- Story mood: ${mood.toString().split('.').last}
- Previous context: ${previousContext ?? 'None'}

GUIDELINES:
1. Use simple, clear language appropriate for the age
2. Include interactive elements (questions, choices)
3. Make abstract concepts concrete through characters and scenarios
4. Include emotional connection points
5. Provide positive reinforcement opportunities
6. Keep paragraphs short (2-3 sentences max)
7. Use repetition for key concepts
8. Include sensory details but respect sensitivities

FORMAT:
Return a JSON object with:
- title: Story title
- content: Main story content with [INTERACTION] markers for interactive moments
- characters: List of main characters
- learningPoints: Key concepts covered
- interactionPoints: Suggested interaction moments
- adaptationNotes: How to modify based on student response

Story mood should be: ${_getMoodDescription(mood)}
""";
  }
  
  String _buildAdaptationPrompt({
    required String currentStory,
    required List<StoryInteraction> interactions,
    required EmotionalState? emotion,
    required StudentProfile student,
  }) {
    final interactionSummary = interactions.map((i) => 
      '${i.type}: ${i.content} (correct: ${i.isCorrect})'
    ).join('\n');
    
    final emotionalContext = emotion != null 
      ? 'Current emotion: ${emotion.recommendedMood} (${emotion.valence})' 
      : 'No emotion data';
    
    return """
Adapt the following story content based on student interactions and emotional state:

CURRENT STORY:
$currentStory

STUDENT INTERACTIONS:
$interactionSummary

EMOTIONAL STATE:
$emotionalContext

STUDENT PROFILE:
- Attention span: ${student.cognitiveProfile.attentionProfile.attentionSpanMinutes} minutes
- Learning style: ${student.cognitiveProfile.primaryLearningStyle}
- Communication needs: ${student.cognitiveProfile.communicationNeeds.toJson()}

ADAPTATION RULES:
1. If student is struggling (low correct responses), simplify language
2. If student is bored (low engagement), add more interactive elements
3. If student is anxious, provide more comfort and reassurance
4. If student is excited, maintain energy but focus attention
5. If attention span exceeded, suggest a break or shorter content

Return the adapted story content that addresses the student's current state and needs.
""";
  }
  
  String _buildQuestionPrompt({
    required String storyContent,
    required StudentProfile student,
    required String learningObjective,
  }) {
    return """
Generate 3-5 interactive questions based on this story to assess comprehension of: $learningObjective

STORY:
$storyContent

STUDENT INFO:
- Age: ${student.age}
- Learning style: ${student.cognitiveProfile.primaryLearningStyle}
- Communication needs: ${student.cognitiveProfile.communicationNeeds.toJson()}

QUESTION REQUIREMENTS:
1. Age-appropriate language
2. Mix of question types (multiple choice, yes/no, open-ended)
3. Include visual/gesture options for AAC users if needed
4. Provide positive feedback for all attempts
5. Allow multiple ways to demonstrate understanding

FORMAT:
Return JSON array with objects containing:
- question: The question text
- type: "multiple_choice", "yes_no", "open_ended", "gesture"
- options: Array of possible answers (for multiple choice)
- correctAnswer: The correct answer
- feedback: Encouraging feedback for correct answers
- hint: Gentle hint for incorrect answers
- visualSupports: Suggested visual aids
""";
  }
  
  String _buildConversionPrompt({
    required String rawContent,
    required StudentProfile student,
    required StoryMood mood,
  }) {
    return """
Convert this educational content into an engaging story format:

CONTENT TO CONVERT:
$rawContent

STUDENT PROFILE:
- Age: ${student.age}
- Favorite characters: ${student.favoriteCharacters.join(', ')}
- Preferred topics: ${student.preferredTopics.join(', ')}

STORY MOOD: ${mood.toString().split('.').last}

REQUIREMENTS:
1. Maintain all educational content
2. Create relatable characters and scenarios
3. Use narrative structure (beginning, middle, end)
4. Include dialogue and action
5. Make abstract concepts concrete
6. Add emotional engagement points
7. Keep language age-appropriate
8. Include opportunities for interaction

Return the story version that makes the content memorable and engaging.
""";
  }
  
  String _buildAnalysisPrompt({
    required String studentResponse,
    required String expectedAnswer,
    required String context,
  }) {
    return """
Analyze this student response for comprehension and provide supportive feedback:

QUESTION CONTEXT: $context
EXPECTED ANSWER: $expectedAnswer
STUDENT RESPONSE: $studentResponse

ANALYSIS CRITERIA:
1. Comprehension level (0.0 to 1.0)
2. Key concepts understood
3. Areas needing support
4. Positive aspects to reinforce
5. Gentle suggestions for improvement

FORMAT:
Return JSON with:
- score: Numerical score (0.0 to 1.0)
- feedback: Encouraging feedback message
- suggestions: Array of support strategies
- strengths: What the student did well
- nextSteps: Recommended follow-up activities

Keep feedback positive and constructive, focusing on effort and progress.
""";
  }
  
  String _getMoodDescription(StoryMood mood) {
    switch (mood) {
      case StoryMood.calm:
        return 'Peaceful, soothing, and focused';
      case StoryMood.excitement:
        return 'Energetic, motivating, and upbeat';
      case StoryMood.comfort:
        return 'Safe, secure, and reassuring';
      case StoryMood.adventure:
        return 'Curious, exploratory, and discovery-focused';
      case StoryMood.creative:
        return 'Imaginative, expressive, and artistic';
      case StoryMood.social:
        return 'Connected, communicative, and relationship-focused';
      case StoryMood.neutral:
        return 'Balanced and adaptable';
    }
  }
  
  StoryResponse _parseStoryResponse(String content) {
    try {
      final json = jsonDecode(content);
      return StoryResponse.fromJson(json);
    } catch (e) {
      // Fallback parsing if JSON fails
      return StoryResponse(
        title: 'Generated Story',
        content: content,
        characters: [],
        learningPoints: [],
        interactionPoints: [],
        adaptationNotes: '',
      );
    }
  }
  
  List<StoryQuestion> _parseQuestions(String content) {
    try {
      final json = jsonDecode(content) as List;
      return json.map((q) => StoryQuestion.fromJson(q)).toList();
    } catch (e) {
      return [];
    }
  }
  
  ComprehensionAnalysis _parseComprehensionAnalysis(String content) {
    try {
      final json = jsonDecode(content);
      return ComprehensionAnalysis.fromJson(json);
    } catch (e) {
      return ComprehensionAnalysis(
        score: 0.5,
        feedback: content,
        suggestions: [],
      );
    }
  }
}

class StoryResponse {
  final String title;
  final String content;
  final List<String> characters;
  final List<String> learningPoints;
  final List<String> interactionPoints;
  final String adaptationNotes;
  
  StoryResponse({
    required this.title,
    required this.content,
    required this.characters,
    required this.learningPoints,
    required this.interactionPoints,
    required this.adaptationNotes,
  });
  
  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      title: json['title'] ?? 'Story',
      content: json['content'] ?? '',
      characters: List<String>.from(json['characters'] ?? []),
      learningPoints: List<String>.from(json['learningPoints'] ?? []),
      interactionPoints: List<String>.from(json['interactionPoints'] ?? []),
      adaptationNotes: json['adaptationNotes'] ?? '',
    );
  }
}

class StoryQuestion {
  final String question;
  final String type;
  final List<String> options;
  final String correctAnswer;
  final String feedback;
  final String hint;
  final List<String> visualSupports;
  
  StoryQuestion({
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.feedback,
    required this.hint,
    required this.visualSupports,
  });
  
  factory StoryQuestion.fromJson(Map<String, dynamic> json) {
    return StoryQuestion(
      question: json['question'] ?? '',
      type: json['type'] ?? 'open_ended',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      feedback: json['feedback'] ?? 'Great job!',
      hint: json['hint'] ?? 'Try again!',
      visualSupports: List<String>.from(json['visualSupports'] ?? []),
    );
  }
}

class ComprehensionAnalysis {
  final double score;
  final String feedback;
  final List<String> suggestions;
  final List<String> strengths;
  final List<String> nextSteps;
  
  ComprehensionAnalysis({
    required this.score,
    required this.feedback,
    required this.suggestions,
    this.strengths = const [],
    this.nextSteps = const [],
  });
  
  factory ComprehensionAnalysis.fromJson(Map<String, dynamic> json) {
    return ComprehensionAnalysis(
      score: json['score']?.toDouble() ?? 0.0,
      feedback: json['feedback'] ?? '',
      suggestions: List<String>.from(json['suggestions'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
      nextSteps: List<String>.from(json['nextSteps'] ?? []),
    );
  }
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);
  
  @override
  String toString() => 'AIServiceException: $message';
} 