# LangChain Integration Guide for NeuroLearn AI

This guide explains how to implement and use the LangChain flows in the NeuroLearn AI Flutter application.

## Overview

The LangChain integration adds two powerful AI flows to NeuroLearn AI:

1. **Story Generation Flow**: `Student data → Personalized prompt → LLM → Story generation`
2. **Progress Summary Flow**: `Parent inputs → IEP map → Progress summaries`

## Architecture

```
┌─────────────────┐    HTTP API    ┌─────────────────┐
│   Flutter App   │ ◄────────────► │ LangChain API   │
│                 │                │                 │
│ ┌─────────────┐ │                │ ┌─────────────┐ │
│ │LangChain    │ │                │ │Story Chain  │ │
│ │Service      │ │                │ │Progress     │ │
│ │             │ │                │ │Chain        │ │
│ └─────────────┘ │                │ └─────────────┘ │
└─────────────────┘                └─────────────────┘
```

## Quick Start

### 1. Backend Setup

```bash
cd backend
chmod +x setup.sh
./setup.sh
```

### 2. Start the Backend

```bash
cd backend
source venv/bin/activate
python main.py
```

The backend will be available at `http://localhost:8000`

### 3. Flutter Integration

The Flutter app already includes the `LangChainService`. To use it:

```dart
// Initialize the service in main.dart
await LangChainService.initialize();

// Use in your Flutter components
final story = await LangChainService.instance.generatePersonalizedStory(
  student: studentProfile,
  learningObjective: "Basic addition with numbers 1-10",
  subject: "mathematics", 
  mood: StoryMood.adventure,
  memoryContext: {
    'location': 'park',
    'people': 'mom, dad',
    'matter': 'feeding ducks'
  }
);
```

## LangChain Flow Details

### Story Generation Flow

**Input**: Student profile with neurodivergent traits, learning preferences, and optional memory context
**Process**: 
1. Student data is processed and formatted
2. Personalized prompt is created based on cognitive profile
3. LLM generates story with interaction points
4. Response is parsed into structured format

**Output**: Complete story with learning points, interactions, and adaptation notes

**Example Usage**:
```dart
final story = await LangChainService.instance.generatePersonalizedStory(
  student: StudentProfile(
    name: "Alex",
    age: 8,
    cognitiveProfile: CognitiveProfile(
      neurodivergentTraits: ["ADHD", "visual_processing"],
      primaryLearningStyle: LearningStyle.visual,
      attentionProfile: AttentionProfile(
        attentionSpanMinutes: 15,
        bestFocusTime: "morning",
        distractionSensitivity: "high"
      )
    )
  ),
  learningObjective: "Understanding addition with visual grouping",
  subject: "mathematics",
  mood: StoryMood.adventure
);

print("Generated story: ${story.title}");
print("Learning points: ${story.learningPoints}");
print("Interaction points: ${story.interactionPoints.length}");
```

### Progress Summary Flow

**Input**: Student profile, IEP goals, progress data, and parent observations
**Process**:
1. Multiple analysis chains run in parallel
2. IEP goals are evaluated against performance data
3. Learning insights are generated from patterns
4. Parent input is integrated into recommendations

**Output**: Comprehensive progress report with actionable insights

**Example Usage**:
```dart
final summary = await LangChainService.instance.generateProgressSummary(
  student: studentProfile,
  iepGoals: [
    IEPGoal(
      id: "math_goal_1",
      description: "Improve basic addition skills",
      targetCriteria: "8 out of 10 problems correct",
      currentProgress: 0.65,
      deadline: "2024-06-30",
      category: "academic"
    )
  ],
  progressData: ProgressData(
    sessionCount: 25,
    comprehensionScores: [0.6, 0.7, 0.75],
    engagementScores: [0.8, 0.85, 0.9],
    achievements: ["Completed chapter book", "Mastered addition 1-5"]
  ),
  parentInput: ParentInput(
    observations: "More excited about math lately",
    concerns: ["Still struggles with focus"],
    celebrations: ["Read book to sister"]
  )
);

print("Overall progress: ${summary.overallProgressScore}");
print("IEP goals: ${summary.iepGoalProgress.length}");
print("Insights: ${summary.learningInsights.length}");
```

## Integration Points in Flutter App

### 1. Story Builder Integration

Update the story builder to use LangChain for enhanced story generation:

```dart
// In story_builder_page.dart
void _generateLangChainStory() async {
  try {
    final story = await LangChainService.instance.generatePersonalizedStory(
      student: widget.student,
      learningObjective: _getLearningObjective(),
      subject: _getSubject(),
      mood: _getSelectedMood(),
      memoryContext: {
        'location': _locationController.text,
        'people': _peopleController.text,
        'matter': _matterController.text,
      }
    );
    
    // Use the generated story
    _showLangChainStory(story);
  } catch (e) {
    _showError('LangChain story generation failed: $e');
  }
}
```

### 2. Dashboard Integration

Add progress summaries to the student dashboard:

```dart
// In student_dashboard_page.dart
void _generateProgressSummary() async {
  final summary = await LangChainService.instance.generateProgressSummary(
    student: widget.student,
    iepGoals: _getIEPGoals(),
    progressData: _getProgressData(),
    parentInput: _getParentInput()
  );
  
  // Display in dashboard
  _showProgressSummary(summary);
}
```

### 3. AI Insights Tab Enhancement

Use LangChain insights in the AI Insights tab:

```dart
// Enhanced AI insights with LangChain
Widget _buildLangChainInsights() {
  return FutureBuilder<LangChainProgressSummary>(
    future: _getLangChainSummary(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            ...snapshot.data!.learningInsights.map((insight) => 
              _buildInsightCard(insight)
            ),
          ],
        );
      }
      return CircularProgressIndicator();
    },
  );
}
```

## Testing the Integration

### Backend Testing

Run the test suite to verify LangChain flows:

```bash
cd backend
python examples/test_requests.py
```

### Flutter Testing

Test the integration in your Flutter app:

```dart
// Test story generation
void testStoryGeneration() async {
  final isHealthy = await LangChainService.instance.isBackendHealthy();
  if (!isHealthy) {
    print('LangChain backend is not available');
    return;
  }
  
  final story = await LangChainService.instance.generatePersonalizedStory(
    student: _getTestStudent(),
    learningObjective: "Test objective",
    subject: "mathematics",
    mood: StoryMood.adventure
  );
  
  print('Story generated: ${story.title}');
}
```

## Error Handling

The integration includes comprehensive error handling:

```dart
try {
  final story = await LangChainService.instance.generatePersonalizedStory(
    // ... parameters
  );
} on LangChainException catch (e) {
  // Handle LangChain-specific errors
  print('LangChain error: ${e.message}');
} catch (e) {
  // Handle general errors
  print('General error: $e');
}
```

## Performance Considerations

1. **Caching**: Consider caching story responses for reuse
2. **Timeouts**: LangChain calls may take 10-30 seconds
3. **Background Processing**: Run LangChain calls in background threads
4. **Fallback**: Always have fallback content ready

## Configuration

### Environment Variables

Backend configuration in `.env`:
```env
OPENAI_API_KEY=your_openai_api_key_here
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY=your_langsmith_api_key_here
PORT=8000
```

### Flutter Configuration

Configure the backend URL in `LangChainService`:
```dart
// For development
_baseUrl = 'http://localhost:8000';

// For production
_baseUrl = 'https://your-production-url.com';
```

## Production Deployment

### Backend Deployment

1. **Docker Setup**:
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python", "main.py"]
```

2. **Cloud Deployment**: Deploy to AWS, GCP, or Heroku
3. **Security**: Use proper CORS settings and API authentication

### Flutter Configuration

Update the Flutter app for production:
```dart
class AppConfig {
  static const String langchainBaseUrl = 
    String.fromEnvironment('LANGCHAIN_URL', 
      defaultValue: 'http://localhost:8000'
    );
}
```

## Monitoring and Analytics

Track LangChain usage:

```dart
class LangChainAnalytics {
  static void trackStoryGeneration(String studentId, Duration duration) {
    // Track story generation metrics
  }
  
  static void trackProgressSummary(String studentId, Duration duration) {
    // Track progress summary metrics
  }
}
```

## Troubleshooting

### Common Issues

1. **Backend Not Responding**
   - Check if backend is running: `curl http://localhost:8000/health`
   - Verify environment variables are set

2. **OpenAI API Errors**
   - Check API key is valid
   - Verify rate limits aren't exceeded

3. **Timeout Errors**
   - Increase timeout values for complex requests
   - Consider request queuing for multiple users

### Debug Mode

Enable debug logging:
```dart
class LangChainService {
  static bool debugMode = true;
  
  void _log(String message) {
    if (debugMode) print('[LangChain] $message');
  }
}
```

## Future Enhancements

1. **Streaming Responses**: Implement streaming for real-time story generation
2. **Offline Mode**: Cache generated content for offline use
3. **Multi-language**: Support multiple languages for stories
4. **Voice Integration**: Convert stories to speech automatically
5. **Visual Generation**: Add image generation for story illustrations

## Support

For help with LangChain integration:
1. Check the backend logs for error details
2. Use the test suite to verify functionality
3. Review the API documentation at `http://localhost:8000/docs`
4. Ensure all dependencies are properly installed

This integration brings powerful AI capabilities to NeuroLearn AI, enabling personalized learning experiences that adapt to each student's unique neurodivergent profile. 