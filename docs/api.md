# API Reference 📚

## Overview

NeuroLearn AI provides a comprehensive API for managing student profiles, emotion detection, story generation, and analytics. This document covers all available endpoints and integration patterns.

## Base URLs

- **Development**: `http://localhost:8000`
- **Staging**: `https://staging-api.neurolearn-ai.com`
- **Production**: `https://api.neurolearn-ai.com`

## Authentication

All API requests require authentication using Bearer tokens:

```http
Authorization: Bearer <your_api_token>
```

### Getting an API Token

```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure_password"
}
```

## Core APIs

### 1. Student Management

#### Create Student Profile

```http
POST /api/v1/students
Content-Type: application/json

{
  "name": "Alex Johnson",
  "age": 8,
  "avatarPath": "avatar_1.png",
  "cognitiveProfile": {
    "primaryLearningStyle": "visual",
    "attentionProfile": {
      "attentionSpanMinutes": 15,
      "needsBreaks": true,
      "breakIntervalMinutes": 10
    },
    "sensoryPreferences": {
      "preferredVolume": 0.7,
      "reducedAnimations": false,
      "highContrast": false
    }
  }
}
```

**Response:**
```json
{
  "id": "student_123",
  "name": "Alex Johnson",
  "age": 8,
  "createdAt": "2024-01-15T10:30:00Z",
  "cognitiveProfile": { ... }
}
```

#### Get Student Profile

```http
GET /api/v1/students/{student_id}
```

#### Update Student Profile

```http
PUT /api/v1/students/{student_id}
Content-Type: application/json

{
  "cognitiveProfile": {
    "attentionProfile": {
      "attentionSpanMinutes": 20
    }
  }
}
```

### 2. Emotion Engine

#### Record Emotion Data

```http
POST /api/v1/emotions
Content-Type: application/json

{
  "studentId": "student_123",
  "detectedEmotions": [
    {
      "label": "happiness",
      "confidence": 0.87,
      "metadata": {
        "source": "facial_detection"
      }
    }
  ],
  "valence": "positive",
  "arousal": 0.8,
  "source": "facial"
}
```

#### Get Emotion History

```http
GET /api/v1/emotions/{student_id}?limit=50&from=2024-01-15&to=2024-01-16
```

#### Get Emotion Analytics

```http
GET /api/v1/emotions/{student_id}/analytics
```

**Response:**
```json
{
  "emotionCounts": {
    "happiness": 15,
    "neutral": 10,
    "sadness": 2
  },
  "positiveRatio": 0.75,
  "emotionalStability": 0.82,
  "dominantMood": "excitement",
  "recommendations": [
    {
      "type": "story_mood",
      "value": "adventure",
      "confidence": 0.9
    }
  ]
}
```

### 3. Story Generation

#### Generate Story

```http
POST /api/v1/stories/generate
Content-Type: application/json

{
  "studentId": "student_123",
  "mood": "adventure",
  "educationalObjective": "basic_math",
  "personalContext": {
    "familyMembers": ["Mom", "Dad", "Sister Emma"],
    "favoriteCharacters": ["Dragon", "Owl"],
    "interests": ["space", "animals"]
  },
  "difficulty": "age_appropriate"
}
```

**Response:**
```json
{
  "storyId": "story_456",
  "title": "Emma and the Space Dragon's Math Adventure",
  "content": "Once upon a time, Emma and her family...",
  "educationalElements": [
    {
      "concept": "addition",
      "context": "counting stars",
      "line": 15
    }
  ],
  "estimatedDuration": 8,
  "mood": "adventure"
}
```

#### Get Story Queue

```http
GET /api/v1/students/{student_id}/stories/queue
```

#### Save Story Session

```http
POST /api/v1/stories/{story_id}/sessions
Content-Type: application/json

{
  "studentId": "student_123",
  "completionRate": 0.85,
  "engagementScore": 0.92,
  "emotionalResponses": [
    {
      "timestamp": "2024-01-15T10:35:00Z",
      "emotion": "excitement",
      "confidence": 0.88
    }
  ],
  "duration": 480
}
```

### 4. Communication Tools

#### Save Communication Session

```http
POST /api/v1/communication/sessions
Content-Type: application/json

{
  "studentId": "student_123",
  "type": "visual_board",
  "wordsUsed": ["happy", "play", "friend"],
  "messageBuilt": "I am happy to play with friend",
  "duration": 120,
  "timestamp": "2024-01-15T10:40:00Z"
}
```

#### Get Communication Analytics

```http
GET /api/v1/communication/{student_id}/analytics
```

### 5. Progress Analytics

#### Get Learning Progress

```http
GET /api/v1/students/{student_id}/progress
```

**Response:**
```json
{
  "overallProgress": 0.68,
  "weeklyActivity": {
    "storiesCompleted": 12,
    "averageEngagement": 0.85,
    "totalLearningTime": 240
  },
  "skillAreas": {
    "reading": 0.75,
    "math": 0.60,
    "communication": 0.80
  },
  "emotionalWellbeing": {
    "positiveEmotionRatio": 0.78,
    "stabilityScore": 0.85
  }
}
```

## WebSocket APIs

### Real-time Emotion Detection

```javascript
const ws = new WebSocket('wss://api.neurolearn-ai.com/ws/emotions');

ws.onopen = function() {
  // Send authentication
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'your_api_token'
  }));
  
  // Start emotion detection session
  ws.send(JSON.stringify({
    type: 'start_detection',
    studentId: 'student_123'
  }));
};

ws.onmessage = function(event) {
  const data = JSON.parse(event.data);
  
  if (data.type === 'emotion_detected') {
    console.log('Emotion detected:', data.emotion);
    // Handle emotion data
  }
};
```

### Live Story Generation

```javascript
const storyWs = new WebSocket('wss://api.neurolearn-ai.com/ws/stories');

storyWs.send(JSON.stringify({
  type: 'generate_story',
  studentId: 'student_123',
  mood: 'calm',
  stream: true
}));

storyWs.onmessage = function(event) {
  const data = JSON.parse(event.data);
  
  if (data.type === 'story_chunk') {
    // Append story content as it's generated
    appendToStory(data.content);
  }
};
```

## Error Handling

All API endpoints follow a consistent error response format:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid student age. Must be between 3 and 18.",
    "details": {
      "field": "age",
      "value": 25,
      "constraint": "range:3-18"
    }
  },
  "timestamp": "2024-01-15T10:45:00Z",
  "requestId": "req_abc123"
}
```

### Common Error Codes

- `AUTHENTICATION_ERROR` (401): Invalid or expired token
- `AUTHORIZATION_ERROR` (403): Insufficient permissions
- `VALIDATION_ERROR` (400): Invalid request data
- `NOT_FOUND` (404): Resource not found
- `RATE_LIMIT_EXCEEDED` (429): Too many requests
- `INTERNAL_ERROR` (500): Server error

## Rate Limits

- **Authentication**: 10 requests per minute
- **Story Generation**: 5 requests per minute per student
- **Emotion Detection**: 30 requests per minute per student
- **Analytics**: 100 requests per hour

## SDKs and Libraries

### Flutter/Dart SDK

```dart
import 'package:neurolearn_ai_sdk/neurolearn_ai_sdk.dart';

final client = NeuroLearnClient(
  baseUrl: 'https://api.neurolearn-ai.com',
  apiKey: 'your_api_key',
);

// Generate a story
final story = await client.stories.generate(
  studentId: 'student_123',
  mood: StoryMood.adventure,
  educationalObjective: 'basic_math',
);

// Start emotion detection
final emotionStream = client.emotions.startDetection('student_123');
emotionStream.listen((emotion) {
  print('Detected: ${emotion.primaryEmotion}');
});
```

### JavaScript SDK

```javascript
import { NeuroLearnClient } from 'neurolearn-ai-js';

const client = new NeuroLearnClient({
  baseUrl: 'https://api.neurolearn-ai.com',
  apiKey: 'your_api_key'
});

// Create student profile
const student = await client.students.create({
  name: 'Alex Johnson',
  age: 8,
  cognitiveProfile: { ... }
});

// Get emotion analytics
const analytics = await client.emotions.getAnalytics(student.id);
```

### Python SDK

```python
from neurolearn_ai import NeuroLearnClient

client = NeuroLearnClient(
    base_url='https://api.neurolearn-ai.com',
    api_key='your_api_key'
)

# Generate story
story = client.stories.generate(
    student_id='student_123',
    mood='adventure',
    educational_objective='basic_math'
)

# Get progress data
progress = client.students.get_progress('student_123')
```

## Webhooks

Configure webhooks to receive real-time notifications:

### Story Completion

```http
POST /api/v1/webhooks
Content-Type: application/json

{
  "url": "https://your-app.com/webhooks/story-completed",
  "events": ["story.completed"],
  "secret": "webhook_secret_key"
}
```

**Webhook Payload:**
```json
{
  "event": "story.completed",
  "timestamp": "2024-01-15T10:50:00Z",
  "data": {
    "studentId": "student_123",
    "storyId": "story_456",
    "completionRate": 1.0,
    "engagementScore": 0.92
  }
}
```

### Emotion Alert

```json
{
  "event": "emotion.alert",
  "timestamp": "2024-01-15T10:55:00Z",
  "data": {
    "studentId": "student_123",
    "alertType": "sustained_negative_emotion",
    "duration": 300,
    "recommendation": "calming_intervention"
  }
}
```

## Testing

### API Testing with cURL

```bash
# Test authentication
curl -X POST https://api.neurolearn-ai.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'

# Test story generation
curl -X POST https://api.neurolearn-ai.com/api/v1/stories/generate \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{"studentId":"student_123","mood":"adventure"}'
```

### Postman Collection

Import our Postman collection for complete API testing:
[Download Collection](https://api.neurolearn-ai.com/postman/collection.json)

## API Versioning

We use semantic versioning for our API:

- **v1**: Current stable version
- **v2**: Next major version (beta)

Breaking changes are introduced only in major versions. Minor versions add features while maintaining backward compatibility.

## Support

- **Documentation Issues**: [GitHub Issues](https://github.com/neurolearn-ai/docs/issues)
- **API Support**: api-support@neurolearn-ai.com
- **Developer Discord**: [Join here](https://discord.gg/neurolearn-ai)

---

*Last updated: January 15, 2024* 