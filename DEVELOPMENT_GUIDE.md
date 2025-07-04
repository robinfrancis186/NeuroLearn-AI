# Development Guide 👨‍💻

## Overview

This guide provides comprehensive information for developers working on NeuroLearn AI. It covers coding standards, project structure, development workflow, and best practices for building inclusive educational technology.

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [Project Structure](#project-structure)
3. [Coding Standards](#coding-standards)
4. [Development Workflow](#development-workflow)
5. [Testing Strategy](#testing-strategy)
6. [Performance Guidelines](#performance-guidelines)
7. [Accessibility Requirements](#accessibility-requirements)
8. [Contribution Guidelines](#contribution-guidelines)

## Development Environment Setup

### Required Tools

```bash
# Flutter SDK
flutter --version  # Should be >=3.16.0

# Dart SDK
dart --version     # Should be >=3.1.0

# Development Tools
code --version     # Visual Studio Code (recommended)
git --version      # Git for version control

# Docker (for backend)
docker --version   # For containerized development
```

### IDE Configuration

**Visual Studio Code Extensions:**
```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "gruntfuggly.todo-tree",
    "streetsidesoftware.code-spell-checker",
    "alexisvt.flutter-snippets",
    "nash.awesome-flutter-snippets"
  ]
}
```

**Settings Configuration (.vscode/settings.json):**
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "files.associations": {
    "*.dart": "dart"
  },
  "emmet.includeLanguages": {
    "dart": "html"
  }
}
```

### Environment Variables

Create `.env` file in project root:
```bash
# API Configuration
MISTRAL_API_KEY=your_mistral_api_key
OPENAI_API_KEY=your_openai_api_key

# Database
DATABASE_URL=postgresql://localhost:5432/neurolearn_dev

# Features Flags
ENABLE_EMOTION_ENGINE=true
ENABLE_DEBUG_LOGGING=true
ENABLE_PERFORMANCE_MONITORING=false

# Development
API_BASE_URL=http://localhost:8000
WEB_PORT=8087
```

## Project Structure

### Frontend Architecture

```
lib/
├── main.dart                          # Application entry point
├── app/                               # Application configuration
│   ├── app.dart                      # Main App widget
│   ├── router/                       # Navigation configuration
│   │   ├── app_router.dart          # GoRouter configuration
│   │   └── route_names.dart         # Route constants
│   └── theme/                        # Application theming
│       ├── app_theme.dart           # Main theme configuration
│       ├── color_schemes.dart       # Color definitions
│       └── text_themes.dart         # Typography definitions
├── core/                             # Core business logic
│   ├── constants/                    # Application constants
│   │   ├── app_constants.dart       # General constants
│   │   ├── api_endpoints.dart       # API endpoint definitions
│   │   └── asset_paths.dart         # Asset path constants
│   ├── models/                       # Data models
│   │   ├── student_profile.dart     # Student profile model
│   │   ├── emotional_state.dart     # Emotion detection model
│   │   ├── story.dart               # Story model
│   │   └── communication_session.dart
│   ├── services/                     # Business logic services
│   │   ├── emotion_service.dart     # Emotion detection service
│   │   ├── story_service.dart       # Story generation service
│   │   ├── api_service.dart         # HTTP client service
│   │   └── storage_service.dart     # Local storage service
│   ├── utils/                        # Utility functions
│   │   ├── date_utils.dart          # Date manipulation utilities
│   │   ├── validation_utils.dart    # Input validation
│   │   └── accessibility_utils.dart # Accessibility helpers
│   └── exceptions/                   # Custom exceptions
│       ├── api_exceptions.dart      # API-related exceptions
│       └── validation_exceptions.dart
├── features/                         # Feature modules
│   ├── authentication/              # Authentication feature
│   │   ├── data/                    # Data layer
│   │   │   ├── repositories/        # Repository implementations
│   │   │   └── datasources/         # Data sources
│   │   ├── domain/                  # Domain layer
│   │   │   ├── entities/            # Domain entities
│   │   │   ├── repositories/        # Repository interfaces
│   │   │   └── usecases/            # Business use cases
│   │   └── presentation/            # Presentation layer
│   │       ├── pages/               # Screen widgets
│   │       ├── widgets/             # Feature-specific widgets
│   │       └── providers/           # State management
│   ├── emotion_engine/              # Emotion detection feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── emotion_detection_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── emotion_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── ml_kit_emotion_source.dart
│   │   │       └── local_emotion_source.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── detected_emotion.dart
│   │   │   ├── repositories/
│   │   │   │   └── emotion_repository.dart
│   │   │   └── usecases/
│   │   │       ├── start_emotion_detection.dart
│   │   │       └── get_emotion_analytics.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── emotion_engine_page.dart
│   │       ├── widgets/
│   │       │   ├── emotion_display.dart
│   │       │   ├── mood_analytics_panel.dart
│   │       │   └── story_mood_recommendation.dart
│   │       └── providers/
│   │           └── emotion_provider.dart
│   ├── story_tutor/                 # Story generation feature
│   ├── communication/               # Communication tools
│   ├── dashboard/                   # Analytics dashboard
│   └── shared/                      # Shared feature components
├── shared/                          # Shared application components
│   ├── widgets/                     # Reusable UI components
│   │   ├── buttons/
│   │   │   ├── neuro_button.dart    # Accessible button component
│   │   │   └── icon_button.dart     # Icon button variant
│   │   ├── cards/
│   │   │   └── neuro_card.dart      # Standard card component
│   │   ├── forms/
│   │   │   ├── neuro_text_field.dart
│   │   │   └── neuro_dropdown.dart
│   │   ├── layout/
│   │   │   ├── neuro_scaffold.dart  # Main scaffold wrapper
│   │   │   └── responsive_layout.dart
│   │   └── accessibility/
│   │       ├── semantic_wrapper.dart
│   │       └── focus_manager.dart
│   ├── providers/                   # Global state management
│   │   ├── app_state_provider.dart  # Global app state
│   │   ├── user_preferences_provider.dart
│   │   └── connectivity_provider.dart
│   └── extensions/                  # Dart extensions
│       ├── context_extensions.dart  # BuildContext extensions
│       ├── string_extensions.dart   # String utilities
│       └── datetime_extensions.dart
└── l10n/                           # Internationalization
    ├── app_en.arb                  # English translations
    ├── app_es.arb                  # Spanish translations
    └── app_localizations.dart      # Generated localizations
```

### Backend Architecture

```
backend/
├── app/
│   ├── main.py                     # FastAPI application entry
│   ├── core/                       # Core backend functionality
│   │   ├── config.py              # Configuration management
│   │   ├── database.py            # Database configuration
│   │   ├── security.py            # Authentication/authorization
│   │   └── exceptions.py          # Custom exceptions
│   ├── api/                        # API endpoints
│   │   ├── v1/                    # API version 1
│   │   │   ├── endpoints/
│   │   │   │   ├── students.py    # Student management
│   │   │   │   ├── emotions.py    # Emotion data
│   │   │   │   ├── stories.py     # Story generation
│   │   │   │   └── analytics.py   # Analytics endpoints
│   │   │   └── api.py             # API router configuration
│   │   └── dependencies.py        # Dependency injection
│   ├── models/                     # Database models
│   │   ├── student.py             # Student model
│   │   ├── emotion.py             # Emotion data model
│   │   ├── story.py               # Story model
│   │   └── session.py             # Session model
│   ├── schemas/                    # Pydantic schemas
│   │   ├── student.py             # Student request/response schemas
│   │   ├── emotion.py             # Emotion schemas
│   │   └── story.py               # Story schemas
│   ├── services/                   # Business logic services
│   │   ├── mistral_service.py     # Mistral AI integration
│   │   ├── emotion_service.py     # Emotion processing
│   │   └── analytics_service.py   # Analytics processing
│   └── utils/                      # Utility functions
│       ├── validators.py          # Input validation
│       └── helpers.py             # General helpers
├── chains/                         # LangChain integration
│   ├── story_generation_chain.py  # Story generation chain
│   └── progress_summary_chain.py  # Progress analysis chain
├── tests/                          # Test files
│   ├── unit/                      # Unit tests
│   ├── integration/               # Integration tests
│   └── conftest.py                # Test configuration
├── migrations/                     # Database migrations
├── requirements.txt                # Python dependencies
└── Dockerfile                     # Container configuration
```

## Coding Standards

### Dart/Flutter Standards

**Naming Conventions:**
```dart
// Classes - PascalCase
class EmotionDetectionService {}
class StudentProfile {}

// Variables and functions - camelCase
String studentName = 'Alex';
void processEmotion() {}

// Constants - lowerCamelCase with descriptive names
const double maxConfidenceThreshold = 0.85;
const Duration detectionInterval = Duration(seconds: 2);

// Private members - underscore prefix
String _privateVariable;
void _privateMethod() {}

// Files - snake_case
// emotion_detection_service.dart
// student_profile_model.dart
```

**Code Organization:**
```dart
// Import order: Dart libraries, Flutter libraries, Package imports, Local imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../core/models/emotional_state.dart';
import '../shared/widgets/neuro_card.dart';

class EmotionDisplayWidget extends StatelessWidget {
  // Constructor parameters
  const EmotionDisplayWidget({
    Key? key,
    required this.emotion,
    this.showConfidence = true,
  }) : super(key: key);

  // Public fields
  final EmotionalState emotion;
  final bool showConfidence;

  // Build method
  @override
  Widget build(BuildContext context) {
    return NeuroCard(
      child: _buildEmotionContent(),
    );
  }

  // Private methods
  Widget _buildEmotionContent() {
    // Implementation
  }
}
```

**Documentation Standards:**
```dart
/// Service responsible for detecting and processing emotions from camera input.
/// 
/// This service integrates with Google ML Kit for face detection and implements
/// the FER+ emotion classification system for neurodivergent learners.
/// 
/// Example usage:
/// ```dart
/// final service = EmotionService.instance;
/// await service.startDetection();
/// service.emotionStream.listen((emotion) {
///   print('Detected: ${emotion.primaryEmotion}');
/// });
/// ```
class EmotionService {
  /// Starts the emotion detection process.
  /// 
  /// Returns a [Future] that completes when detection is successfully started.
  /// Throws [CameraException] if camera access is denied.
  /// Throws [MLKitException] if ML Kit models fail to load.
  Future<void> startDetection() async {
    // Implementation
  }

  /// Stream of detected emotions with confidence scores.
  /// 
  /// Emits a new [EmotionalState] every 2 seconds during active detection.
  /// The stream will emit null if no face is detected.
  Stream<EmotionalState?> get emotionStream => _emotionController.stream;
}
```

### Python/Backend Standards

**Code Style:**
```python
# Follow PEP 8 style guide
# Use black formatter for consistency

from typing import List, Optional, Dict, Any
from datetime import datetime
from pydantic import BaseModel, Field
from fastapi import APIRouter, Depends, HTTPException


class EmotionRequest(BaseModel):
    """Request model for emotion data submission."""
    
    student_id: str = Field(..., description="Unique student identifier")
    detected_emotions: List[DetectedEmotion] = Field(
        ..., 
        description="List of detected emotions with confidence scores"
    )
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    
    class Config:
        """Pydantic configuration."""
        schema_extra = {
            "example": {
                "student_id": "student_123",
                "detected_emotions": [
                    {
                        "label": "happiness",
                        "confidence": 0.87
                    }
                ],
                "timestamp": "2024-01-15T10:30:00Z"
            }
        }


async def process_emotion_data(
    emotion_data: EmotionRequest,
    db: Database = Depends(get_database),
    current_user: User = Depends(get_current_user)
) -> EmotionResponse:
    """
    Process incoming emotion detection data.
    
    Args:
        emotion_data: The emotion detection request
        db: Database dependency
        current_user: Authenticated user
        
    Returns:
        EmotionResponse: Processed emotion data with recommendations
        
    Raises:
        HTTPException: If student not found or processing fails
    """
    try:
        # Validate student exists
        student = await db.get_student(emotion_data.student_id)
        if not student:
            raise HTTPException(
                status_code=404, 
                detail="Student not found"
            )
        
        # Process emotion data
        processed_emotion = await emotion_service.process(emotion_data)
        
        # Store in database
        await db.save_emotion_state(processed_emotion)
        
        return EmotionResponse(
            emotion_id=processed_emotion.id,
            recommendations=await generate_recommendations(processed_emotion)
        )
        
    except Exception as e:
        logger.error(f"Failed to process emotion data: {e}")
        raise HTTPException(
            status_code=500,
            detail="Failed to process emotion data"
        )
```

## Development Workflow

### Git Workflow

**Branch Naming Convention:**
```bash
# Feature branches
feature/emotion-engine-ml-kit
feature/story-generation-mistral
feature/accessibility-improvements

# Bug fixes
bugfix/camera-permission-handling
bugfix/story-loading-timeout

# Hotfixes
hotfix/security-vulnerability-fix

# Release branches
release/v1.2.0
```

**Commit Message Format:**
```bash
# Format: <type>(<scope>): <description>
# Types: feat, fix, docs, style, refactor, test, chore

feat(emotion): add real-time emotion detection with ML Kit
fix(story): resolve story generation timeout issues
docs(api): update emotion detection endpoint documentation
test(emotion): add unit tests for emotion classification
refactor(ui): improve accessibility of communication widgets
style(lint): fix linting issues in emotion service
chore(deps): update Flutter to version 3.16.0
```

### Development Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-awesome-feature
   ```

2. **Development Loop**
   ```bash
   # Make changes
   flutter analyze                    # Check for issues
   flutter test                      # Run tests
   flutter test integration_test/    # Run integration tests
   ```

3. **Code Review Checklist**
   - [ ] Code follows style guidelines
   - [ ] Tests are included and passing
   - [ ] Documentation is updated
   - [ ] Accessibility requirements met
   - [ ] Performance impact considered
   - [ ] Error handling implemented

4. **Pull Request Template**
   ```markdown
   ## Description
   Brief description of changes made.

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   - [ ] Unit tests added/updated
   - [ ] Integration tests added/updated
   - [ ] Manual testing completed

   ## Accessibility
   - [ ] Screen reader compatibility verified
   - [ ] High contrast mode tested
   - [ ] Keyboard navigation functional
   - [ ] Touch target sizes appropriate (44x44px minimum)

   ## Screenshots
   [If applicable, add screenshots or recordings]
   ```

## Testing Strategy

### Unit Testing

**Test Structure:**
```dart
// test/unit/emotion_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neurolearn_ai/core/services/emotion_service.dart';

import '../mocks/mock_camera_controller.dart';
import '../mocks/mock_face_detector.dart';

void main() {
  group('EmotionService', () {
    late EmotionService emotionService;
    late MockCameraController mockCamera;
    late MockFaceDetector mockFaceDetector;

    setUp(() {
      mockCamera = MockCameraController();
      mockFaceDetector = MockFaceDetector();
      emotionService = EmotionService(
        camera: mockCamera,
        faceDetector: mockFaceDetector,
      );
    });

    tearDown(() {
      emotionService.dispose();
    });

    group('startDetection', () {
      test('should start emotion detection successfully', () async {
        // Arrange
        when(mockCamera.initialize()).thenAnswer((_) async => true);
        when(mockFaceDetector.initialize()).thenAnswer((_) async => true);

        // Act
        await emotionService.startDetection();

        // Assert
        expect(emotionService.isDetecting, isTrue);
        verify(mockCamera.initialize()).called(1);
        verify(mockFaceDetector.initialize()).called(1);
      });

      test('should throw CameraException when camera fails to initialize', () async {
        // Arrange
        when(mockCamera.initialize()).thenThrow(CameraException('Failed'));

        // Act & Assert
        expect(
          () => emotionService.startDetection(),
          throwsA(isA<CameraException>()),
        );
      });
    });

    group('processEmotionFrame', () {
      test('should return null when no face detected', () async {
        // Arrange
        when(mockFaceDetector.detectFaces(any)).thenAnswer((_) async => []);

        // Act
        final result = await emotionService.processEmotionFrame(mockImage);

        // Assert
        expect(result, isNull);
      });

      test('should return EmotionalState when face detected', () async {
        // Arrange
        final mockFace = MockFace();
        when(mockFace.smilingProbability).thenReturn(0.8);
        when(mockFaceDetector.detectFaces(any)).thenAnswer((_) async => [mockFace]);

        // Act
        final result = await emotionService.processEmotionFrame(mockImage);

        // Assert
        expect(result, isA<EmotionalState>());
        expect(result?.primaryEmotion, equals(DetectedEmotion.happiness));
      });
    });
  });
}
```

### Integration Testing

**End-to-End Test Example:**
```dart
// integration_test/emotion_engine_test.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:neurolearn_ai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Emotion Engine Integration Tests', () {
    testWidgets('Complete emotion detection flow', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Emotion Engine
      await tester.tap(find.text('Emotion Engine'));
      await tester.pumpAndSettle();

      // Mock camera permission
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/camera'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'initialize') {
            return {'cameraId': 1};
          }
          return null;
        },
      );

      // Start emotion detection
      await tester.tap(find.text('Start Detection'));
      await tester.pumpAndSettle();

      // Verify UI elements are present
      expect(find.text('Emotion Status'), findsOneWidget);
      expect(find.text('Current Emotion'), findsOneWidget);
      expect(find.text('Stop Detection'), findsOneWidget);

      // Simulate emotion detection
      // (In real implementation, would need camera feed simulation)

      // Stop detection
      await tester.tap(find.text('Stop Detection'));
      await tester.pumpAndSettle();

      // Verify detection stopped
      expect(find.text('Start Detection'), findsOneWidget);
    });

    testWidgets('Accessibility features work correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test semantic labels
      final emotionEngineFinder = find.bySemanticsLabel('Emotion Engine');
      expect(emotionEngineFinder, findsOneWidget);

      // Test high contrast mode
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('High Contrast'));
      await tester.pumpAndSettle();

      // Verify high contrast applied
      // (Check theme changes, color values, etc.)
    });
  });
}
```

### Performance Testing

**Widget Performance Test:**
```dart
// test/performance/emotion_widget_performance_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Emotion Widget Performance Tests', () {
    testWidgets('EmotionDisplay renders within performance budget', (WidgetTester tester) async {
      const testEmotion = EmotionalState(
        primaryEmotion: DetectedEmotion.happiness,
        confidence: 0.85,
        valence: EmotionalValence.positive,
        arousal: 0.7,
      );

      // Measure build time
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmotionDisplay(emotion: testEmotion),
          ),
        ),
      );
      
      stopwatch.stop();

      // Assert build time is under 16ms (60fps)
      expect(stopwatch.elapsedMilliseconds, lessThan(16));
    });

    testWidgets('Rapid emotion updates maintain smooth animation', (WidgetTester tester) async {
      final emotionController = StreamController<EmotionalState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamBuilder<EmotionalState>(
              stream: emotionController.stream,
              builder: (context, snapshot) {
                return EmotionDisplay(emotion: snapshot.data);
              },
            ),
          ),
        ),
      );

      // Send rapid emotion updates
      final emotions = [
        EmotionalState(primaryEmotion: DetectedEmotion.happiness, confidence: 0.8),
        EmotionalState(primaryEmotion: DetectedEmotion.sadness, confidence: 0.7),
        EmotionalState(primaryEmotion: DetectedEmotion.surprise, confidence: 0.9),
      ];

      for (final emotion in emotions) {
        emotionController.add(emotion);
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify no frame drops
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}
```

## Performance Guidelines

### Flutter Performance Best Practices

**Widget Optimization:**
```dart
// ✅ Good: Use const constructors
class GoodWidget extends StatelessWidget {
  const GoodWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Text('Hello World');
  }
}

// ✅ Good: Extract expensive builds to methods
class OptimizedListView extends StatelessWidget {
  const OptimizedListView({Key? key, required this.items}) : super(key: key);
  
  final List<String> items;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: _buildListItem,
    );
  }
  
  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(title: Text(items[index]));
  }
}

// ❌ Bad: Creating widgets in build method
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expensiveWidget = ExpensiveWidget(); // Creates new instance every build
    return Container(child: expensiveWidget);
  }
}
```

**State Management Optimization:**
```dart
// ✅ Good: Use selective rebuilds
class OptimizedCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild when count changes
    final count = ref.watch(counterProvider.select((state) => state.count));
    
    return Text('Count: $count');
  }
}

// ✅ Good: Dispose resources properly
class EmotionWidget extends StatefulWidget {
  @override
  _EmotionWidgetState createState() => _EmotionWidgetState();
}

class _EmotionWidgetState extends State<EmotionWidget> {
  late StreamSubscription _emotionSubscription;
  
  @override
  void initState() {
    super.initState();
    _emotionSubscription = EmotionService.instance.emotionStream.listen(_onEmotion);
  }
  
  @override
  void dispose() {
    _emotionSubscription.cancel(); // Prevent memory leaks
    super.dispose();
  }
  
  void _onEmotion(EmotionalState emotion) {
    // Handle emotion update
  }
}
```

## Accessibility Requirements

### WCAG 2.1 AA Compliance

**Color and Contrast:**
```dart
class AccessibilityColors {
  // Ensure minimum 4.5:1 contrast ratio
  static const Color primaryText = Color(0xFF000000);     // Black
  static const Color primaryBackground = Color(0xFFFFFFFF); // White
  static const Color secondaryText = Color(0xFF757575);   // Gray 600
  
  // High contrast alternatives
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastBackground = Color(0xFFFFFFFF);
  static const Color highContrastAccent = Color(0xFF0000FF);
  
  static Color getTextColor(bool highContrast) {
    return highContrast ? highContrastText : primaryText;
  }
}
```

**Touch Targets:**
```dart
class AccessibilityConstants {
  // Minimum touch target size (44x44 logical pixels)
  static const double minTouchTarget = 44.0;
  
  // Recommended spacing between interactive elements
  static const double minSpacing = 8.0;
}

class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
  }) : super(key: key);
  
  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticLabel;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        height: AccessibilityConstants.minTouchTarget,
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
```

**Screen Reader Support:**
```dart
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    Key? key,
    required this.title,
    required this.content,
    this.onTap,
  }) : super(key: key);
  
  final String title;
  final String content;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $content',
      hint: onTap != null ? 'Double tap to open' : null,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                ExcludeSemantics(
                  child: Text(content),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Contribution Guidelines

### Getting Started

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/neurolearn-ai.git
   cd neurolearn-ai
   ```

2. **Set Up Development Environment**
   ```bash
   flutter pub get
   flutter analyze
   flutter test
   ```

3. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Making Changes

1. **Follow Coding Standards**
   - Use provided linting configuration
   - Write comprehensive tests
   - Update documentation

2. **Test Your Changes**
   ```bash
   # Run all tests
   flutter test
   
   # Run integration tests
   flutter test integration_test/
   
   # Check accessibility
   flutter analyze --suggestions
   ```

3. **Update Documentation**
   - API changes require documentation updates
   - Add example usage for new features
   - Update relevant README sections

### Submitting Changes

1. **Create Pull Request**
   - Use provided PR template
   - Include screenshots/recordings for UI changes
   - Link related issues

2. **Code Review Process**
   - Address reviewer feedback
   - Ensure CI passes
   - Maintain clean commit history

3. **Merge Requirements**
   - [ ] All tests passing
   - [ ] Code review approved
   - [ ] Documentation updated
   - [ ] Accessibility verified

### Community Guidelines

- **Be Respectful**: Treat all contributors with respect
- **Be Inclusive**: Consider neurodivergent users in all decisions
- **Be Constructive**: Provide helpful feedback and suggestions
- **Be Patient**: Remember we're all learning and growing

---

*This development guide is a living document that evolves with our project. Last updated: January 15, 2024* 