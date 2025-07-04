# System Architecture 🏗️

## Overview

NeuroLearn AI is designed as a modern, scalable, and accessible educational platform with a focus on neurodivergent learners. The architecture emphasizes real-time emotion processing, adaptive content generation, and privacy-first design.

## High-Level Architecture

```mermaid
graph TB
    subgraph "Frontend Layer"
        FW[Flutter Web App]
        FW --> |Real-time| WS[WebSocket Connection]
        FW --> |REST API| API[API Gateway]
    end
    
    subgraph "Backend Services"
        API --> |Route| AUTH[Auth Service]
        API --> |Route| STORY[Story Service]
        API --> |Route| EMOTION[Emotion Service]
        API --> |Route| ANALYTICS[Analytics Service]
        
        WS --> |Stream| REALTIME[Real-time Engine]
        REALTIME --> EMOTION
        REALTIME --> STORY
    end
    
    subgraph "AI/ML Layer"
        STORY --> |Generate| MISTRAL[Mistral 7B]
        EMOTION --> |Process| MLKIT[Google ML Kit]
        ANALYTICS --> |Analyze| ML[ML Analytics]
    end
    
    subgraph "Data Layer"
        AUTH --> |Store| DB[(PostgreSQL)]
        STORY --> |Cache| REDIS[(Redis)]
        EMOTION --> |Local| LOCAL[(Local Storage)]
        ANALYTICS --> |Time Series| INFLUX[(InfluxDB)]
    end
```

## Frontend Architecture

### Flutter Web Application

#### Layer Structure

```
lib/
├── main.dart                 # Application entry point
├── app/                      # Application configuration
│   ├── app.dart             # Main app widget
│   ├── router.dart          # Navigation routing
│   └── theme.dart           # Application theming
├── core/                     # Core business logic
│   ├── models/              # Data models
│   ├── services/            # Business logic services
│   ├── utils/               # Utility functions
│   └── constants/           # Application constants
├── features/                 # Feature modules
│   ├── emotion_engine/      # Emotion detection feature
│   ├── story_tutor/         # Story generation feature
│   ├── communication/       # Communication tools
│   ├── dashboard/           # Analytics dashboard
│   └── shared/              # Shared feature components
└── shared/                   # Shared application components
    ├── widgets/             # Reusable UI components
    ├── themes/              # Theme configurations
    └── providers/           # State management
```

#### State Management Pattern

Using **Riverpod** for predictable state management:

```dart
// Provider Definition
final emotionServiceProvider = Provider<EmotionService>((ref) {
  return EmotionService.instance;
});

final currentEmotionProvider = StreamProvider<EmotionalState?>((ref) {
  final service = ref.watch(emotionServiceProvider);
  return service.emotionStream;
});

// Consumer Usage
class EmotionDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emotionAsync = ref.watch(currentEmotionProvider);
    
    return emotionAsync.when(
      data: (emotion) => EmotionCard(emotion: emotion),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
    );
  }
}
```

#### Component Architecture

```mermaid
graph TD
    APP[App Root] --> |Provides| PROVIDERS[Global Providers]
    APP --> |Routes to| FEATURES[Feature Pages]
    
    FEATURES --> |Contains| WIDGETS[Feature Widgets]
    FEATURES --> |Uses| SERVICES[Core Services]
    
    WIDGETS --> |Compose| SHARED[Shared Widgets]
    SERVICES --> |Access| MODELS[Data Models]
    
    SHARED --> |Style with| THEMES[Theme System]
    MODELS --> |Validate with| UTILS[Utility Functions]
```

### Design Patterns

#### 1. Feature-Based Organization

Each feature is self-contained with its own:
- **Presentation Layer**: Pages and widgets
- **Business Logic**: Services and providers
- **Data Layer**: Models and repositories

```dart
// Feature structure example
features/emotion_engine/
├── presentation/
│   ├── pages/
│   │   └── emotion_engine_page.dart
│   └── widgets/
│       ├── emotion_display.dart
│       └── mood_analytics.dart
├── domain/
│   ├── entities/
│   │   └── emotion_state.dart
│   └── repositories/
│       └── emotion_repository.dart
└── data/
    ├── models/
    │   └── emotion_model.dart
    └── sources/
        └── emotion_api.dart
```

#### 2. Repository Pattern

Abstraction layer for data access:

```dart
abstract class EmotionRepository {
  Stream<EmotionalState> get emotionStream;
  Future<void> saveEmotion(EmotionalState emotion);
  Future<List<EmotionalState>> getHistory(String studentId);
}

class EmotionRepositoryImpl implements EmotionRepository {
  final EmotionLocalDataSource _localDataSource;
  final EmotionRemoteDataSource _remoteDataSource;
  
  EmotionRepositoryImpl(this._localDataSource, this._remoteDataSource);
  
  @override
  Stream<EmotionalState> get emotionStream => 
      _localDataSource.emotionStream;
  
  @override
  Future<void> saveEmotion(EmotionalState emotion) async {
    await _localDataSource.saveEmotion(emotion);
    await _remoteDataSource.saveEmotion(emotion);
  }
}
```

#### 3. Service Locator Pattern

Dependency injection using Riverpod:

```dart
final emotionRepositoryProvider = Provider<EmotionRepository>((ref) {
  return EmotionRepositoryImpl(
    ref.watch(emotionLocalDataSourceProvider),
    ref.watch(emotionRemoteDataSourceProvider),
  );
});

final emotionServiceProvider = Provider<EmotionService>((ref) {
  return EmotionService(ref.watch(emotionRepositoryProvider));
});
```

## Backend Architecture

### Microservices Design

#### Service Breakdown

```mermaid
graph LR
    subgraph "API Gateway"
        GATEWAY[Kong/Nginx]
    end
    
    subgraph "Core Services"
        AUTH[Authentication Service]
        STUDENT[Student Management Service]
        STORY[Story Generation Service]
        EMOTION[Emotion Processing Service]
        ANALYTICS[Analytics Service]
    end
    
    subgraph "Supporting Services"
        NOTIFICATION[Notification Service]
        FILE[File Storage Service]
        CACHE[Cache Service]
    end
    
    GATEWAY --> AUTH
    GATEWAY --> STUDENT
    GATEWAY --> STORY
    GATEWAY --> EMOTION
    GATEWAY --> ANALYTICS
    
    STORY --> NOTIFICATION
    EMOTION --> CACHE
    ANALYTICS --> FILE
```

#### Service Responsibilities

1. **Authentication Service**
   - User authentication and authorization
   - JWT token management
   - Role-based access control
   - Session management

2. **Student Management Service**
   - Student profile CRUD operations
   - Cognitive profile management
   - Learning preferences
   - Progress tracking

3. **Story Generation Service**
   - AI-powered story creation
   - Template management
   - Content adaptation
   - Educational objective mapping

4. **Emotion Processing Service**
   - Real-time emotion analysis
   - Mood pattern detection
   - Intervention recommendations
   - Historical data processing

5. **Analytics Service**
   - Learning analytics
   - Progress reporting
   - Predictive modeling
   - Dashboard data aggregation

### Data Architecture

#### Database Design

```mermaid
erDiagram
    STUDENTS ||--o{ EMOTION_STATES : has
    STUDENTS ||--o{ STORY_SESSIONS : participates
    STUDENTS ||--o{ COMMUNICATION_SESSIONS : uses
    
    STUDENTS {
        uuid id PK
        string name
        int age
        jsonb cognitive_profile
        timestamp created_at
        timestamp updated_at
    }
    
    EMOTION_STATES {
        uuid id PK
        uuid student_id FK
        string valence
        float arousal
        jsonb detected_emotions
        string source
        timestamp created_at
    }
    
    STORY_SESSIONS {
        uuid id PK
        uuid student_id FK
        uuid story_id
        float completion_rate
        float engagement_score
        int duration_seconds
        timestamp started_at
        timestamp completed_at
    }
    
    STORIES {
        uuid id PK
        string title
        text content
        string mood
        jsonb educational_elements
        timestamp created_at
    }
    
    COMMUNICATION_SESSIONS {
        uuid id PK
        uuid student_id FK
        string session_type
        jsonb data
        int duration_seconds
        timestamp created_at
    }
```

#### Data Flow Architecture

```mermaid
graph TD
    subgraph "Data Sources"
        CAMERA[Camera Input] --> ML[ML Kit Processing]
        USER[User Interactions] --> WEB[Web Events]
        STORY[Story Sessions] --> ANALYTICS_DATA[Analytics Data]
    end
    
    subgraph "Processing Layer"
        ML --> EMOTION_PROC[Emotion Processing]
        WEB --> EVENT_PROC[Event Processing]
        ANALYTICS_DATA --> AGG[Data Aggregation]
    end
    
    subgraph "Storage Layer"
        EMOTION_PROC --> LOCAL[Local Storage]
        EMOTION_PROC --> REDIS[Redis Cache]
        EVENT_PROC --> POSTGRES[PostgreSQL]
        AGG --> INFLUX[InfluxDB]
    end
    
    subgraph "API Layer"
        LOCAL --> REST[REST API]
        REDIS --> REST
        POSTGRES --> REST
        INFLUX --> REST
        
        REST --> WS[WebSocket]
    end
```

## AI/ML Architecture

### Emotion Detection Pipeline

```mermaid
graph TD
    CAMERA[Camera Stream] --> PREPROCESS[Image Preprocessing]
    PREPROCESS --> DETECTION[Face Detection]
    DETECTION --> EXTRACTION[Feature Extraction]
    EXTRACTION --> CLASSIFICATION[Emotion Classification]
    CLASSIFICATION --> CONFIDENCE[Confidence Scoring]
    CONFIDENCE --> MAPPING[Mood Mapping]
    MAPPING --> RECOMMENDATION[Story Recommendation]
```

#### ML Kit Integration

```dart
class EmotionDetectionPipeline {
  final FaceDetector _faceDetector;
  final EmotionClassifier _emotionClassifier;
  
  Future<EmotionalState?> processFrame(CameraImage image) async {
    // Step 1: Detect faces
    final faces = await _faceDetector.processImage(
      InputImage.fromCameraImage(image)
    );
    
    if (faces.isEmpty) return null;
    
    // Step 2: Extract facial features
    final primaryFace = _selectPrimaryFace(faces);
    final features = await _extractFeatures(primaryFace);
    
    // Step 3: Classify emotions
    final emotions = await _emotionClassifier.classify(features);
    
    // Step 4: Create emotional state
    return _createEmotionalState(emotions);
  }
}
```

### Story Generation Architecture

```mermaid
graph TD
    INPUT[Story Request] --> CONTEXT[Context Building]
    CONTEXT --> TEMPLATE[Template Selection]
    TEMPLATE --> GENERATION[AI Generation]
    GENERATION --> VALIDATION[Content Validation]
    VALIDATION --> ADAPTATION[Adaptive Refinement]
    ADAPTATION --> OUTPUT[Story Output]
    
    subgraph "AI Models"
        GENERATION --> MISTRAL[Mistral 7B]
        VALIDATION --> SAFETY[Safety Classifier]
        ADAPTATION --> EDUCATION[Educational Mapper]
    end
```

#### Mistral Integration

```python
class StoryGenerator:
    def __init__(self, mistral_client: MistralClient):
        self.client = mistral_client
        
    async def generate_story(
        self, 
        student_profile: StudentProfile,
        mood: StoryMood,
        educational_objective: str
    ) -> Story:
        
        # Build context
        context = self._build_context(student_profile, mood)
        
        # Generate with Mistral
        prompt = self._create_prompt(context, educational_objective)
        response = await self.client.chat.complete(
            model="mistral-7b-instruct",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7
        )
        
        # Validate and adapt
        story_content = response.choices[0].message.content
        validated_story = await self._validate_content(story_content)
        
        return self._create_story_object(validated_story, mood)
```

## Security Architecture

### Authentication & Authorization

```mermaid
graph TD
    CLIENT[Client Request] --> GATEWAY[API Gateway]
    GATEWAY --> AUTH_CHECK{Valid Token?}
    AUTH_CHECK -->|No| REJECT[401 Unauthorized]
    AUTH_CHECK -->|Yes| ROLE_CHECK{Has Permission?}
    ROLE_CHECK -->|No| FORBIDDEN[403 Forbidden]
    ROLE_CHECK -->|Yes| SERVICE[Forward to Service]
    
    subgraph "Token Validation"
        JWT[JWT Validation]
        REFRESH[Token Refresh]
        REVOKE[Token Revocation]
    end
    
    AUTH_CHECK --> JWT
    JWT --> REFRESH
    JWT --> REVOKE
```

### Data Privacy

#### Local-First Architecture

```dart
class PrivacyFirstDataManager {
  // Emotion data stays local
  final LocalEmotionStorage _localEmotion;
  
  // Only aggregated analytics sent to server
  final AnalyticsService _analytics;
  
  Future<void> processEmotion(EmotionalState emotion) async {
    // Store locally
    await _localEmotion.save(emotion);
    
    // Send only anonymized analytics
    final anonymizedData = _anonymize(emotion);
    await _analytics.track(anonymizedData);
  }
  
  Map<String, dynamic> _anonymize(EmotionalState emotion) {
    return {
      'valence': emotion.valence,
      'arousal_range': _discretizeArousal(emotion.arousal),
      'session_id': _generateSessionId(),
      // No student ID or personal data
    };
  }
}
```

## Performance Architecture

### Caching Strategy

```mermaid
graph TD
    REQUEST[Client Request] --> L1[Browser Cache]
    L1 -->|Miss| L2[CDN Cache]
    L2 -->|Miss| L3[Redis Cache]
    L3 -->|Miss| DB[Database]
    
    DB --> L3
    L3 --> L2
    L2 --> L1
    L1 --> CLIENT
    
    subgraph "Cache Layers"
        L1_TTL[5 minutes]
        L2_TTL[1 hour]
        L3_TTL[24 hours]
    end
```

### Real-time Processing

```dart
class RealTimeEmotionProcessor {
  final StreamController<EmotionalState> _controller;
  Timer? _processingTimer;
  
  void startProcessing() {
    _processingTimer = Timer.periodic(
      Duration(milliseconds: 2000), // 2-second intervals
      (_) => _processCurrentFrame(),
    );
  }
  
  Future<void> _processCurrentFrame() async {
    if (_isProcessing) return; // Skip if already processing
    
    _isProcessing = true;
    try {
      final emotion = await _detectEmotion();
      if (emotion != null) {
        _controller.add(emotion);
        await _updateRecommendations(emotion);
      }
    } finally {
      _isProcessing = false;
    }
  }
}
```

## Scalability Architecture

### Horizontal Scaling

```mermaid
graph TD
    subgraph "Load Balancer"
        LB[Nginx/HAProxy]
    end
    
    subgraph "Frontend Replicas"
        FE1[Flutter App Instance 1]
        FE2[Flutter App Instance 2]
        FE3[Flutter App Instance 3]
    end
    
    subgraph "Backend Services"
        API1[API Service 1]
        API2[API Service 2]
        API3[API Service 3]
    end
    
    subgraph "Database Cluster"
        MASTER[PostgreSQL Master]
        REPLICA1[Read Replica 1]
        REPLICA2[Read Replica 2]
    end
    
    LB --> FE1
    LB --> FE2
    LB --> FE3
    
    FE1 --> API1
    FE2 --> API2
    FE3 --> API3
    
    API1 --> MASTER
    API2 --> REPLICA1
    API3 --> REPLICA2
```

### Auto-scaling Configuration

```yaml
# Kubernetes HPA configuration
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: neurolearn-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: neurolearn-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

## Deployment Architecture

### Container Strategy

```dockerfile
# Multi-stage build for Flutter Web
FROM node:18-alpine as flutter-build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=flutter-build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Infrastructure as Code

```yaml
# Docker Compose for development
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "8087:80"
    depends_on:
      - api
      
  api:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/neurolearn
    depends_on:
      - db
      - redis
      
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: neurolearn
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
      
volumes:
  postgres_data:
```

## Monitoring & Observability

### Application Metrics

```dart
class MetricsCollector {
  static final _instance = MetricsCollector._();
  static MetricsCollector get instance => _instance;
  
  void trackEmotionDetection(EmotionalState emotion) {
    // Track detection latency
    _trackLatency('emotion_detection', emotion.processingTime);
    
    // Track emotion distribution
    _trackCounter('emotion_detected', {
      'emotion': emotion.primaryEmotion,
      'confidence': emotion.confidence.toString(),
    });
  }
  
  void trackStoryGeneration(String storyId, Duration generationTime) {
    _trackLatency('story_generation', generationTime);
    _trackCounter('story_generated');
  }
}
```

### Health Checks

```python
@app.get("/health")
async def health_check():
    checks = {
        "database": await check_database(),
        "redis": await check_redis(),
        "mistral_api": await check_mistral_api(),
        "ml_kit": check_ml_kit_availability(),
    }
    
    healthy = all(checks.values())
    status_code = 200 if healthy else 503
    
    return JSONResponse(
        content={"status": "healthy" if healthy else "unhealthy", "checks": checks},
        status_code=status_code
    )
```

## Future Architecture Considerations

### Edge Computing

```mermaid
graph TD
    DEVICE[Edge Device] --> LOCAL_ML[Local ML Processing]
    LOCAL_ML --> SYNC[Data Sync Service]
    SYNC --> CLOUD[Cloud Services]
    
    subgraph "Edge Capabilities"
        EMOTION_LOCAL[Local Emotion Detection]
        STORY_CACHE[Story Caching]
        OFFLINE[Offline Mode]
    end
    
    LOCAL_ML --> EMOTION_LOCAL
    LOCAL_ML --> STORY_CACHE
    LOCAL_ML --> OFFLINE
```

### WebAssembly Integration

```dart
// Future: WASM-based ML inference
import 'dart:html' as html;
import 'package:js/js.dart';

@JS('loadEmotionModel')
external Future<void> loadEmotionModel();

@JS('detectEmotion')
external dynamic detectEmotionWasm(dynamic imageData);

class WasmEmotionDetector {
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (!_initialized) {
      await loadEmotionModel();
      _initialized = true;
    }
  }
  
  Future<EmotionalState?> detectEmotion(html.ImageData imageData) async {
    final result = detectEmotionWasm(imageData);
    return EmotionalState.fromWasmResult(result);
  }
}
```

---

*This architecture documentation is living and evolves with the system. Last updated: January 15, 2024* 