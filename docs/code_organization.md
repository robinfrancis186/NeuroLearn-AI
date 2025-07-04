# Code Organization Guide 📁

## Overview

This document outlines the code organization strategy for NeuroLearn AI, ensuring maintainable, scalable, and accessible code structure. The project follows Clean Architecture principles with feature-based organization.

## Current Project Structure

### Root Directory Structure

```
NeuroLearn AI/
├── README.md                           # Project overview and setup instructions
├── DEVELOPMENT_GUIDE.md               # Development guidelines and standards
├── pubspec.yaml                       # Flutter dependencies and configuration
├── pubspec.lock                       # Locked dependency versions
├── analysis_options.yaml             # Dart/Flutter linting rules
├── .gitignore                         # Git ignore patterns
├── .env.example                       # Environment variables template
├── lib/                               # Flutter application source code
├── test/                              # Unit and widget tests
├── integration_test/                  # Integration tests
├── web/                               # Web-specific files
├── assets/                            # Application assets
├── docs/                              # Project documentation
├── backend/                           # Python FastAPI backend
├── scripts/                           # Automation scripts
└── .vscode/                           # VS Code configuration
```

### Frontend Structure (`lib/`)

#### Main Application Files

```
lib/
├── main.dart                          # Application entry point
├── app/
│   ├── app.dart                      # Main App widget configuration
│   ├── router/
│   │   ├── app_router.dart          # GoRouter configuration
│   │   ├── route_names.dart         # Route name constants
│   │   └── route_guards.dart        # Navigation guards
│   └── theme/
│       ├── app_theme.dart           # Main theme configuration
│       ├── color_schemes.dart       # Color palette definitions
│       ├── text_themes.dart         # Typography styles
│       └── neuro_theme_data.dart    # Neurodivergent-specific theming
```

#### Core Layer (`lib/core/`)

The core layer contains business logic, models, and utilities shared across features.

```
lib/core/
├── constants/
│   ├── app_constants.dart           # Application-wide constants
│   ├── api_endpoints.dart           # API endpoint definitions
│   ├── asset_paths.dart             # Asset path constants
│   ├── neuro_constants.dart         # Neurodivergent-specific constants
│   └── storage_keys.dart            # Local storage key constants
├── models/
│   ├── emotional_state.dart         # Emotion detection models
│   ├── student_profile.dart         # Student profile models
│   ├── story.dart                   # Story-related models
│   ├── cognitive_profile.dart       # Cognitive assessment models
│   ├── communication_session.dart   # Communication models
│   └── learning_session.dart        # Learning session models
├── services/
│   ├── emotion_service.dart         # Emotion detection service
│   ├── story_service.dart           # Story generation service
│   ├── api_service.dart             # HTTP client service
│   ├── storage_service.dart         # Local storage service
│   ├── analytics_service.dart       # Analytics tracking service
│   └── accessibility_service.dart   # Accessibility utilities
├── utils/
│   ├── date_utils.dart              # Date/time utilities
│   ├── validation_utils.dart        # Input validation
│   ├── accessibility_utils.dart     # A11y helper functions
│   ├── emotion_utils.dart           # Emotion processing utilities
│   └── performance_utils.dart       # Performance monitoring
├── exceptions/
│   ├── api_exceptions.dart          # API-related exceptions
│   ├── emotion_exceptions.dart      # Emotion processing exceptions
│   └── validation_exceptions.dart   # Validation exceptions
└── extensions/
    ├── context_extensions.dart      # BuildContext extensions
    ├── string_extensions.dart       # String utilities
    ├── datetime_extensions.dart     # DateTime utilities
    └── emotion_extensions.dart      # Emotion-specific extensions
```

#### Features Layer (`lib/features/`)

Each feature follows Clean Architecture with data, domain, and presentation layers.

```
lib/features/
├── authentication/
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   └── auth_response_model.dart
│   │   ├── repositories/
│   │   │   └── auth_repository_impl.dart
│   │   └── datasources/
│   │       ├── auth_remote_datasource.dart
│   │       └── auth_local_datasource.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.dart
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   └── usecases/
│   │       ├── login_user.dart
│   │       ├── logout_user.dart
│   │       └── register_user.dart
│   └── presentation/
│       ├── pages/
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       ├── widgets/
│       │   ├── login_form.dart
│       │   └── auth_button.dart
│       └── providers/
│           └── auth_provider.dart
├── emotion_engine/
│   ├── data/
│   │   ├── models/
│   │   │   ├── ml_kit_face_model.dart
│   │   │   └── emotion_history_model.dart
│   │   ├── repositories/
│   │   │   └── emotion_repository_impl.dart
│   │   └── datasources/
│   │       ├── ml_kit_emotion_source.dart
│   │       ├── camera_data_source.dart
│   │       └── local_emotion_source.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── detected_emotion.dart
│   │   │   ├── emotion_analytics.dart
│   │   │   └── intervention_recommendation.dart
│   │   ├── repositories/
│   │   │   └── emotion_repository.dart
│   │   └── usecases/
│   │       ├── start_emotion_detection.dart
│   │       ├── stop_emotion_detection.dart
│   │       ├── get_emotion_analytics.dart
│   │       └── generate_intervention_recommendation.dart
│   └── presentation/
│       ├── pages/
│       │   └── emotion_engine_page.dart
│       ├── widgets/
│       │   ├── emotion_display.dart
│       │   ├── camera_preview_widget.dart
│       │   ├── mood_analytics_panel.dart
│       │   ├── story_mood_recommendation.dart
│       │   ├── intervention_card.dart
│       │   └── emotion_history_chart.dart
│       └── providers/
│           ├── emotion_provider.dart
│           ├── camera_provider.dart
│           └── analytics_provider.dart
├── story_tutor/
│   ├── data/
│   │   ├── models/
│   │   │   ├── story_model.dart
│   │   │   ├── story_session_model.dart
│   │   │   └── mistral_response_model.dart
│   │   ├── repositories/
│   │   │   └── story_repository_impl.dart
│   │   └── datasources/
│   │       ├── mistral_api_source.dart
│   │       ├── story_template_source.dart
│   │       └── local_story_source.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── story.dart
│   │   │   ├── story_session.dart
│   │   │   └── educational_objective.dart
│   │   ├── repositories/
│   │   │   └── story_repository.dart
│   │   └── usecases/
│   │       ├── generate_story.dart
│   │       ├── save_story_session.dart
│   │       └── get_story_recommendations.dart
│   └── presentation/
│       ├── pages/
│       │   ├── home_page.dart
│       │   ├── story_builder_page.dart
│       │   ├── story_reader_page.dart
│       │   └── story_library_page.dart
│       ├── widgets/
│       │   ├── story_card.dart
│       │   ├── story_builder_form.dart
│       │   ├── story_reader.dart
│       │   ├── progress_indicator.dart
│       │   └── story_controls.dart
│       └── providers/
│           ├── story_provider.dart
│           ├── story_session_provider.dart
│           └── library_provider.dart
├── communication/
│   ├── data/
│   │   ├── models/
│   │   │   ├── communication_word_model.dart
│   │   │   └── message_model.dart
│   │   ├── repositories/
│   │   │   └── communication_repository_impl.dart
│   │   └── datasources/
│   │       ├── word_database_source.dart
│   │       └── communication_history_source.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── communication_word.dart
│   │   │   ├── message.dart
│   │   │   └── communication_category.dart
│   │   ├── repositories/
│   │   │   └── communication_repository.dart
│   │   └── usecases/
│   │       ├── get_words_by_category.dart
│   │       ├── build_message.dart
│   │       └── save_communication_session.dart
│   └── presentation/
│       ├── pages/
│       │   ├── communication_page.dart
│       │   ├── visual_board_page.dart
│       │   └── speech_practice_page.dart
│       ├── widgets/
│       │   ├── communication_board.dart
│       │   ├── word_tile.dart
│       │   ├── message_builder.dart
│       │   ├── category_selector.dart
│       │   └── speech_practice_widget.dart
│       └── providers/
│           ├── communication_provider.dart
│           ├── message_builder_provider.dart
│           └── speech_provider.dart
├── dashboard/
│   └── [Similar structure for analytics and progress tracking]
├── flashcards/
│   └── [Similar structure for flashcard learning]
└── ar_geography/
    └── [Similar structure for AR geography features]
```

#### Shared Layer (`lib/shared/`)

Reusable components used across multiple features.

```
lib/shared/
├── widgets/
│   ├── buttons/
│   │   ├── neuro_button.dart          # Main button component
│   │   ├── neuro_icon_button.dart     # Icon button variant
│   │   ├── neuro_floating_button.dart # Floating action button
│   │   └── adaptive_button.dart       # Platform-adaptive button
│   ├── cards/
│   │   ├── neuro_card.dart           # Standard card component
│   │   ├── metric_card.dart          # Analytics metric display
│   │   ├── progress_card.dart        # Progress tracking card
│   │   └── info_card.dart            # Information display card
│   ├── forms/
│   │   ├── neuro_text_field.dart     # Accessible text input
│   │   ├── neuro_dropdown.dart       # Dropdown selector
│   │   ├── neuro_slider.dart         # Range slider input
│   │   ├── neuro_checkbox.dart       # Checkbox input
│   │   └── neuro_radio.dart          # Radio button input
│   ├── layout/
│   │   ├── neuro_scaffold.dart       # Main scaffold wrapper
│   │   ├── responsive_layout.dart    # Responsive layout helper
│   │   ├── safe_area_wrapper.dart    # Safe area handling
│   │   └── adaptive_padding.dart     # Responsive padding
│   ├── navigation/
│   │   ├── neuro_app_bar.dart        # Accessible app bar
│   │   ├── neuro_bottom_navigation.dart # Bottom navigation
│   │   ├── neuro_drawer.dart         # Navigation drawer
│   │   └── breadcrumb_navigation.dart # Breadcrumb trail
│   ├── feedback/
│   │   ├── loading_indicator.dart    # Loading states
│   │   ├── error_display.dart        # Error handling UI
│   │   ├── success_message.dart      # Success feedback
│   │   └── neuro_snackbar.dart       # Toast notifications
│   ├── accessibility/
│   │   ├── semantic_wrapper.dart     # Semantic labeling
│   │   ├── focus_manager.dart        # Focus management
│   │   ├── screen_reader_text.dart   # Screen reader only text
│   │   └── high_contrast_wrapper.dart # High contrast support
│   ├── animations/
│   │   ├── fade_transition.dart      # Fade animations
│   │   ├── slide_transition.dart     # Slide animations
│   │   ├── scale_transition.dart     # Scale animations
│   │   └── reduced_motion_wrapper.dart # Motion sensitivity
│   └── charts/
│       ├── line_chart.dart           # Progress line charts
│       ├── bar_chart.dart            # Bar chart displays
│       ├── pie_chart.dart            # Pie chart visualizations
│       └── emotion_timeline.dart     # Emotion history chart
├── providers/
│   ├── app_state_provider.dart       # Global application state
│   ├── user_preferences_provider.dart # User settings
│   ├── connectivity_provider.dart    # Network connectivity
│   ├── theme_provider.dart           # Theme management
│   └── accessibility_provider.dart   # Accessibility settings
├── mixins/
│   ├── validation_mixin.dart         # Input validation helpers
│   ├── analytics_mixin.dart          # Analytics tracking
│   ├── accessibility_mixin.dart      # A11y helper methods
│   └── performance_mixin.dart        # Performance monitoring
└── enums/
    ├── app_enums.dart                # General application enums
    ├── emotion_enums.dart            # Emotion-related enums
    ├── story_enums.dart              # Story-related enums
    └── accessibility_enums.dart      # Accessibility enums
```

### Backend Structure (`backend/`)

```
backend/
├── app/
│   ├── main.py                       # FastAPI application entry
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py                # Configuration settings
│   │   ├── database.py              # Database connection
│   │   ├── security.py              # Auth & security
│   │   ├── exceptions.py            # Custom exceptions
│   │   └── middleware.py            # Custom middleware
│   ├── api/
│   │   ├── __init__.py
│   │   ├── dependencies.py          # Dependency injection
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── api.py               # Main API router
│   │       └── endpoints/
│   │           ├── __init__.py
│   │           ├── auth.py          # Authentication endpoints
│   │           ├── students.py      # Student management
│   │           ├── emotions.py      # Emotion data endpoints
│   │           ├── stories.py       # Story generation
│   │           ├── communication.py # Communication data
│   │           └── analytics.py     # Analytics endpoints
│   ├── models/
│   │   ├── __init__.py
│   │   ├── base.py                  # Base model class
│   │   ├── user.py                  # User model
│   │   ├── student.py               # Student model
│   │   ├── emotion.py               # Emotion data model
│   │   ├── story.py                 # Story model
│   │   ├── communication.py         # Communication model
│   │   └── analytics.py             # Analytics model
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── auth.py                  # Auth schemas
│   │   ├── student.py               # Student schemas
│   │   ├── emotion.py               # Emotion schemas
│   │   ├── story.py                 # Story schemas
│   │   └── analytics.py             # Analytics schemas
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth_service.py          # Authentication logic
│   │   ├── student_service.py       # Student management
│   │   ├── emotion_service.py       # Emotion processing
│   │   ├── story_service.py         # Story generation
│   │   ├── mistral_service.py       # Mistral AI integration
│   │   └── analytics_service.py     # Analytics processing
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── validators.py            # Input validation
│   │   ├── helpers.py               # General utilities
│   │   ├── email.py                 # Email utilities
│   │   └── encryption.py            # Encryption utilities
│   └── tests/
│       ├── __init__.py
│       ├── conftest.py              # Test configuration
│       ├── unit/                    # Unit tests
│       ├── integration/             # Integration tests
│       └── e2e/                     # End-to-end tests
├── chains/                          # LangChain integrations
│   ├── __init__.py
│   ├── story_generation_chain.py    # Story generation chain
│   ├── progress_summary_chain.py    # Progress analysis
│   └── intervention_chain.py        # Intervention recommendations
├── migrations/                      # Database migrations
│   └── alembic/
├── scripts/                         # Utility scripts
│   ├── setup.sh                     # Environment setup
│   ├── migrate.py                   # Database migration
│   └── seed_data.py                 # Test data seeding
├── requirements.txt                 # Python dependencies
├── requirements-dev.txt             # Development dependencies
├── Dockerfile                       # Container configuration
├── docker-compose.yml               # Development compose
└── pytest.ini                      # Test configuration
```

### Asset Organization (`assets/`)

```
assets/
├── images/
│   ├── avatars/                     # Student avatar images
│   ├── emotions/                    # Emotion icons and illustrations
│   ├── stories/                     # Story illustrations
│   ├── communication/               # Communication symbols
│   └── ui/                          # UI graphics and icons
├── fonts/
│   ├── OpenDyslexic/               # Dyslexia-friendly font
│   ├── ComicNeue/                  # Readable sans-serif font
│   └── Roboto/                     # Default system font
├── audio/
│   ├── sounds/                     # UI sound effects
│   ├── music/                      # Background music
│   └── voices/                     # Voice samples
├── animations/
│   ├── lottie/                     # Lottie animation files
│   └── rive/                       # Rive animation files
├── data/
│   ├── communication_words.json    # Communication vocabulary
│   ├── story_templates.json        # Story templates
│   └── emotion_mappings.json       # Emotion classification data
└── config/
    ├── app_config.json             # App configuration
    └── feature_flags.json          # Feature toggles
```

### Documentation Structure (`docs/`)

```
docs/
├── api.md                          # API documentation
├── architecture.md                # System architecture
├── deployment.md                  # Deployment guide
├── troubleshooting.md             # Common issues and solutions
├── widgets.md                     # Widget catalog
├── neurodivergence.md             # Neurodivergence support guide
├── code_organization.md           # This file
├── accessibility/
│   ├── guidelines.md              # Accessibility guidelines
│   ├── testing.md                 # A11y testing procedures
│   └── wcag_compliance.md         # WCAG compliance checklist
├── design/
│   ├── design_system.md           # Design system documentation
│   ├── color_palette.md           # Color usage guidelines
│   └── typography.md              # Typography guidelines
├── development/
│   ├── setup.md                   # Development setup
│   ├── testing.md                 # Testing guidelines
│   └── ci_cd.md                   # CI/CD documentation
└── user_guides/
    ├── emotion_engine.md          # Emotion Engine user guide
    ├── story_builder.md           # Story Builder user guide
    └── communication_tools.md     # Communication tools guide
```

## File Naming Conventions

### Dart Files

```dart
// Use snake_case for file names
emotion_detection_service.dart       ✅
emotionDetectionService.dart        ❌
emotion-detection-service.dart      ❌

// Feature pages should end with _page.dart
emotion_engine_page.dart            ✅
story_builder_page.dart             ✅

// Widgets should be descriptive
emotion_display_widget.dart         ✅
story_mood_recommendation.dart      ✅

// Models should end with appropriate suffix
student_profile_model.dart          ✅
emotional_state.dart                ✅ (entity)
emotion_request.dart                ✅ (schema)

// Services should end with _service.dart
emotion_service.dart                ✅
api_service.dart                    ✅

// Providers should end with _provider.dart
emotion_provider.dart               ✅
user_preferences_provider.dart     ✅
```

### Python Files

```python
# Use snake_case for Python files
emotion_service.py                  ✅
story_generation_chain.py          ✅

# Models should be singular nouns
student.py                          ✅
emotion.py                          ✅

# Services should end with _service.py
mistral_service.py                  ✅
analytics_service.py               ✅

# Schemas should match model names
student.py                          ✅ (in schemas/)
emotion.py                          ✅ (in schemas/)
```

### Asset Files

```
# Use descriptive, lowercase names with hyphens
happy-face-icon.png                 ✅
student-avatar-1.jpg               ✅
calming-background-music.mp3       ✅

# Group by category and feature
emotions/happy-face.svg             ✅
avatars/student-default.png        ✅
sounds/button-click.wav             ✅
```

## Code Organization Best Practices

### Import Organization

```dart
// 1. Dart SDK imports
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// 2. Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party package imports
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:riverpod/riverpod.dart';

// 4. Local imports (relative paths)
import '../core/models/emotional_state.dart';
import '../core/services/emotion_service.dart';
import '../shared/widgets/neuro_card.dart';
```

### Class Organization

```dart
class EmotionDetectionService {
  // 1. Static members
  static const Duration _detectionInterval = Duration(seconds: 2);
  static EmotionDetectionService? _instance;
  
  // 2. Instance variables (private first)
  final StreamController<EmotionalState?> _emotionController;
  final FaceDetector _faceDetector;
  Timer? _detectionTimer;
  bool _isDetecting = false;
  
  // 3. Constructors
  EmotionDetectionService._();
  
  // 4. Static getters/methods
  static EmotionDetectionService get instance => _instance ??= EmotionDetectionService._();
  
  // 5. Public getters
  Stream<EmotionalState?> get emotionStream => _emotionController.stream;
  bool get isDetecting => _isDetecting;
  
  // 6. Public methods
  Future<void> startDetection() async {
    // Implementation
  }
  
  Future<void> stopDetection() async {
    // Implementation
  }
  
  // 7. Private methods
  Future<void> _processEmotionFrame() async {
    // Implementation
  }
  
  void _handleEmotionDetected(EmotionalState emotion) {
    // Implementation
  }
  
  // 8. Disposal
  void dispose() {
    _emotionController.close();
    _detectionTimer?.cancel();
  }
}
```

### Feature Organization Guidelines

#### When to Create a New Feature Module

Create a new feature module when:
- The functionality is cohesive and self-contained
- It has its own domain models and business logic
- It could potentially be extracted as a separate package
- It has distinct user interfaces and workflows

#### How to Structure a New Feature

1. **Start with Domain Layer**
   ```dart
   // Define entities first
   lib/features/new_feature/domain/entities/
   
   // Then repository interfaces
   lib/features/new_feature/domain/repositories/
   
   // Finally use cases
   lib/features/new_feature/domain/usecases/
   ```

2. **Implement Data Layer**
   ```dart
   // Create data models
   lib/features/new_feature/data/models/
   
   // Implement repositories
   lib/features/new_feature/data/repositories/
   
   // Add data sources
   lib/features/new_feature/data/datasources/
   ```

3. **Build Presentation Layer**
   ```dart
   // Create pages
   lib/features/new_feature/presentation/pages/
   
   // Add widgets
   lib/features/new_feature/presentation/widgets/
   
   // Implement state management
   lib/features/new_feature/presentation/providers/
   ```

### Shared Component Guidelines

#### When to Add to Shared

Move components to shared when:
- Used by 3 or more features
- Provides core UI functionality
- Implements accessibility standards
- Could benefit other similar projects

#### Shared Widget Structure

```dart
// lib/shared/widgets/category/component_name.dart
class NeuroButton extends StatelessWidget {
  // Always include semantic labeling
  final String? semanticLabel;
  
  // Support accessibility features
  final bool highContrast;
  final bool reduceMotion;
  
  // Include comprehensive documentation
  /// Accessible button component following neurodivergent design principles.
  /// 
  /// This button automatically handles:
  /// - Minimum 44x44 touch targets
  /// - High contrast mode support
  /// - Reduced motion preferences
  /// - Screen reader compatibility
  const NeuroButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.highContrast = false,
    this.reduceMotion = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implementation with accessibility features
  }
}
```

## Migration Guide

### Moving from Current Structure

If you need to reorganize existing code:

1. **Identify Feature Boundaries**
   ```bash
   # Group related files by feature
   find lib/ -name "*emotion*" | sort
   find lib/ -name "*story*" | sort
   ```

2. **Create Feature Structure**
   ```bash
   mkdir -p lib/features/emotion_engine/{data,domain,presentation}
   mkdir -p lib/features/emotion_engine/data/{models,repositories,datasources}
   mkdir -p lib/features/emotion_engine/domain/{entities,repositories,usecases}
   mkdir -p lib/features/emotion_engine/presentation/{pages,widgets,providers}
   ```

3. **Move Files Systematically**
   ```bash
   # Move models to domain entities
   mv lib/core/models/emotional_state.dart lib/features/emotion_engine/domain/entities/
   
   # Move services to data layer
   mv lib/core/services/emotion_service.dart lib/features/emotion_engine/data/repositories/
   
   # Move UI components
   mv lib/features/emotion_engine/emotion_engine_page.dart lib/features/emotion_engine/presentation/pages/
   ```

4. **Update Imports**
   Use IDE refactoring tools to update import statements across the project.

## Best Practices Summary

### File Organization
- ✅ Use feature-based organization for scalability
- ✅ Follow Clean Architecture principles
- ✅ Keep shared components truly reusable
- ✅ Use consistent naming conventions
- ✅ Group related functionality together

### Code Structure
- ✅ Organize imports by source (Dart, Flutter, packages, local)
- ✅ Order class members logically
- ✅ Include comprehensive documentation
- ✅ Follow accessibility guidelines
- ✅ Implement proper error handling

### Maintainability
- ✅ Keep files focused and cohesive
- ✅ Use descriptive names for files and classes
- ✅ Document complex business logic
- ✅ Include examples in documentation
- ✅ Regular refactoring and cleanup

---

*This code organization guide evolves with the project structure. Last updated: January 15, 2024* 